# 视力测试方法和结果判断标准重构 Spec

## Why

根据最新的 `临床视力测试标准基线.md`，当前代码实现采用的是已废止的 "3-down 1-up" 阶梯法（staircase）和 "6次反转终止" 算法。本文档定义将项目迁移到**适配自测场景的 ETDRS 风格流程**。

**关键理解**：本应用的核心是**个人视力自测**，不是临床检查。因此：
- ✅ **吸收 ETDRS 的优点**：逐字母计分、行级推进逻辑、科学的结果计算公式
- ❌ **不照搬临床限制**：不强制 4m/5m 测距、不需要医生指导、不强制双眼分别测试
- ✅ **保持自测友好**：允许用户自定义测试距离、单眼测试、随时终止

**本次调整**：
- 停止条件：某行错误数 > 1（即错 2 个就停止）
- 保留反转机制：以**行级别**为单位进行 2-3 次反转，提高测试准确性

当前代码存在的问题：
- `staircase_estimator.dart` 使用已废止的 `3-down 1-up` 阶梯法
- 依赖 `reversal`（反转点）概念计算阈值，不符合 ETDRS 标准
- 结果计算不科学（反转点均值 ≠ 真实视力阈值）

## What Changes

### 1. 新增 ETDRS 风格测试引擎
- 创建 `etdrs_style_engine.dart` 实现适配自测的 ETDRS 风格流程
- **行级推进**：每行固定 5 个视标，逐视标计分（吸收 ETDRS 核心逻辑）
- **停止条件**：某行错误数 > 1 时停止（错 2 个即停止）
- **行级反转**：以行为单位进行 2-3 次反转，提高准确性
  - 下行：某行正确数 ≥ 通过阈值（如 3/5）→ 进入下一行（更小视标）
  - 上行：某行错误数 > 1 → 回到上一行（更大视标）
  - 记录行级反转点
- **测距灵活**：使用用户设定的任意测试距离，不是强制 4m
- **无近距补测**：自测场景下用户可自行调整距离，不需要补测流程

### 2. 重构结果计算逻辑（核心改进）
- **BREAKING**: 移除 `StaircaseEstimator` 中的逐题反转点相关计算
- **新增行级反转机制**：
  - 记录行级反转点（从大到小 ↔ 从小到大的转折点）
  - 进行 2-3 次行级反转后终止测试
- **新增 ETDRS 风格结果计算**：
  - 字母分数：`letterScore = totalCorrect + 30`（适配任意距离）
  - 等效 logMAR：`logMAR = 1.7 - 0.02 × letterScore`
  - 小数视力：`decimal = 10^(-logMAR)`
- **保留行级结果**：`bestLineLogMar` 作为临床兼容参考

### 3. 扩展数据模型
- **BREAKING**: `QuestionRecord` 新增 `lineIndex` 和 `optotypeIndexInLine` 字段（支持行级计分）
- **BREAKING**: `TestConfig` 新增字段：
  - `optotypesPerLine`（默认 5）
  - `maxErrorsPerLine`（默认 1，错 2 个即停止）
  - `minCorrectPerLine`（默认 3，5 题中对 3 题算通过）
  - `requiredLineReversals`（默认 2，行级反转次数）
- **BREAKING**: `EyeTestResult` 结构调整：
  - 移除 `reversalStdDev`（逐题阶梯法概念）
  - 新增 `etdrsLetterScore`（ETDRS 字母分数）
  - 新增 `bestLineLogMar`（最佳通过行）
  - 新增 `lineReversals`（行级反转点列表）
  - 重命名 `estimatedLogMar` → `equivalentLogMar`
- 新增 `LineProgressState` 用于行级状态管理
- 新增 `LineReversalPoint` 用于记录行级反转点

### 4. 更新测试会话控制器
- 使用新的 ETDRS 风格引擎替换 staircase 逻辑
- 支持行级推进逻辑（每行 5 个视标）
- 停止条件改为"某行错误数 > 1 或达到指定反转次数"

### 5. 迁移期兼容
- 保留旧版 `staircase_estimator.dart` 作为兼容层
- 标记为 `@deprecated`
- 旧字段保留但标记为"迁移期兼容字段"

## Impact

- Affected specs: `视力学公式与数据结构设计稿.md`
- Affected code:
  - `lib/vision/testing/staircase_estimator.dart`
  - `lib/vision/testing/` (新增文件)
  - `lib/vision/domain/vision_models.dart`
  - `lib/vision/domain/vision_enums.dart`
  - `lib/app/test_session_controller.dart`
  - `test/vision/testing/staircase_estimator_test.dart`

## ADDED Requirements

### Requirement: ETDRS 风格测试引擎（适配自测）

The system SHALL provide an ETDRS-style testing engine adapted for self-testing scenarios.

#### Scenario: 行级推进
- **GIVEN** 用户开始测试
- **WHEN** 系统生成题目
- **THEN** 按以下规则推进：
  - 每行固定 5 个视标
  - 从大到小逐行读取
  - 每个视标只允许作答一次
  - 记录每行的正确/错误数
  - 使用用户设定的测试距离（任意距离，不是强制 4m）

#### Scenario: 行通过判定（下行）
- **GIVEN** 当前行已完成
- **WHEN** 正确数 ≥ minCorrectPerLine（默认 3/5）
- **THEN** 进入下一行（更小视标）

#### Scenario: 行失败判定（上行）
- **GIVEN** 当前行进行中或已完成
- **WHEN** 错误数 > maxErrorsPerLine（默认 1，即错 2 个）
- **THEN** 停止当前行，回到上一行（更大视标）

#### Scenario: 行级反转记录
- **GIVEN** 行进方向改变（下行→上行 或 上行→下行）
- **WHEN** 方向改变时
- **THEN** 记录行级反转点：
  - 当前行索引
  - 当前 logMAR
  - 反转方向
  - 该行正确/错误数

#### Scenario: 测试终止条件
- **GIVEN** 测试进行中
- **WHEN** 满足以下任一条件：
  - 行级反转次数达到 requiredLineReversals（默认 2 次）
  - 达到最大题量保护（默认 50 题）
  - 用户主动终止
- **THEN** 测试结束

#### Scenario: 字母分数计算（适配任意距离）
- **GIVEN** 测试完成
- **WHEN** 计算 ETDRS 风格分数
- **THEN** 按以下规则计算：
  - 总正确字母数：`totalCorrect`
  - 字母分数：`letterScore = totalCorrect + 30`
  - 等效 logMAR：`logMAR = 1.7 - 0.02 × letterScore`
  - 小数视力：`decimal = 10^(-logMAR)`

#### Scenario: 行级结果计算
- **GIVEN** 测试完成
- **WHEN** 计算临床兼容结果
- **THEN** 记录"通过的最小一行"作为 `bestLineLogMar`

### Requirement: 行级状态管理

The system SHALL maintain line-level progress state.

#### Scenario: 行级状态跟踪
- **GIVEN** 测试进行中
- **WHEN** 每道题作答后
- **THEN** 更新以下状态：
  - 当前行索引
  - 当前行已展示视标数
  - 当前行正确数
  - 当前行错误数
  - 总行数和总正确数
  - 行进方向（上行/下行）
  - 行级反转次数

## MODIFIED Requirements

### Requirement: TestConfig 数据结构

```dart
class TestConfig {
  // ... 现有字段 ...
  
  // ADDED: 每行视标数（默认 5，ETDRS 标准）
  final int optotypesPerLine;
  
  // ADDED: 单行最大允许错误数（默认 1，错 2 个即停止）
  final int maxErrorsPerLine;
  
  // ADDED: 单行通过所需正确数（默认 3，5 题中对 3 题）
  final int minCorrectPerLine;
  
  // ADDED: 所需行级反转次数（默认 2）
  final int requiredLineReversals;
  
  // REMOVED: requiredCorrectForStepDown（阶梯法废弃）
  // REMOVED: allowedWrongForStepUp（阶梯法废弃）
  // REMOVED: requiredReversalCount（阶梯法废弃）
}
```

### Requirement: QuestionRecord 数据结构

```dart
class QuestionRecord {
  // ... 现有字段 ...
  
  // ADDED: 当前行索引（0-based）
  final int lineIndex;
  
  // ADDED: 当前视标在该行中的序号（0-based）
  final int optotypeIndexInLine;
}
```

### Requirement: EyeTestResult 数据结构

```dart
class EyeTestResult {
  // ... 现有字段 ...
  
  // ADDED: ETDRS 风格字母分数
  final int etdrsLetterScore;
  
  // ADDED: 最佳通过行的 logMAR（临床兼容）
  final double bestLineLogMar;
  
  // ADDED: 行级反转点列表
  final List<LineReversalPoint> lineReversals;
  
  // MODIFIED: 等效 logMAR（从 estimatedLogMar 重命名）
  final double equivalentLogMar;
  
  // REMOVED: reversalStdDev（阶梯法废弃）
  // REMOVED: estimatedLogMar（重命名为 equivalentLogMar）
}
```

## REMOVED Requirements

### Requirement: 阶梯法（Staircase）核心逻辑

**Reason**: `3-down 1-up`、`6次反转终止` 等逐题阶梯概念已废止，改为**行级**反转机制。

**Migration**: 
- 保留 `staircase_estimator.dart` 作为迁移期兼容层
- 标记为 `@deprecated`
- 新代码必须使用 ETDRS 风格引擎（行级反转）

### Requirement: ReversalPoint 数据结构（逐题）

**Reason**: 逐题反转点是阶梯法特有的概念，新流程使用**行级**反转。

**Migration**:
- 保留 `ReversalPoint` 类但标记为 `@deprecated`
- 新流程使用 `LineReversalPoint` 记录行级反转

## 默认参数配置

| 参数 | 默认值 | 说明 |
|------|-------|------|
| optotypesPerLine | 5 | 每行视标数（ETDRS 标准） |
| maxErrorsPerLine | 1 | 单行最大允许错误数（错 2 个即停止） |
| minCorrectPerLine | 3 | 单行通过所需正确数（5 题中对 3 题） |
| requiredLineReversals | 2 | 所需行级反转次数 |
| startLogMar | 0.5 | 起始 logMAR |
| minLogMar | -0.3 | 最小 logMAR |
| maxLogMar | 1.0 | 最大 logMAR |
| stepLogMar | 0.1 | 行间步长 |
| maxQuestionCount | 50 | 最大题量保护 |

## 测试流程示例

假设用户进行测试：

**第 1 轮（下行）**：
- 第 0 行 (logMAR 0.5)：5 题全对 → 通过，继续下行
- 第 1 行 (logMAR 0.4)：5 题全对 → 通过，继续下行
- 第 2 行 (logMAR 0.3)：3 对 2 错 → 错误数 > 1，停止当前行，**反转上行**（第 1 次反转）

**第 2 轮（上行）**：
- 回到第 1 行 (logMAR 0.4)：5 题全对 → 通过，**反转下行**（第 2 次反转）

**第 3 轮（下行）**：
- 第 2 行 (logMAR 0.3)：4 对 1 错 → 通过，继续下行
- 第 3 行 (logMAR 0.2)：1 对 2 错 → 错误数 > 1，停止当前行，**反转上行**（第 3 次反转）

**终止**：达到 requiredLineReversals = 2？不，已达到 3 次，但配置是 2 次，实际应在第 2 次反转后终止。

修正：达到 2 次行级反转后终止测试。

**计算结果**：
- 总正确数：5 + 5 + 3 + 5 + 4 + 1 = 23
- 字母分数：23 + 30 = 53
- 等效 logMAR：1.7 - 0.02 × 53 = 0.64
- 小数视力：10^(-0.64) ≈ 0.229
- 最佳行 logMAR：0.3（第 2 行通过）
- 行级反转点：[(2, 0.3, down→up), (1, 0.4, up→down), (3, 0.2, down→up)]
