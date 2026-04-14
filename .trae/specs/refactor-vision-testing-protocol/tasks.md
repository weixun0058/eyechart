# Tasks

## Phase 1: 数据模型重构

- [x] Task 1: 更新 VisionEnums
  - [x] SubTask 1.1: 在 `SessionEndReason` 添加 `protocolCompleted`（替代 thresholdReached）
  - [x] SubTask 1.2: 运行 `flutter analyze` 验证无错误

- [x] Task 2: 重构 TestConfig 数据模型
  - [x] SubTask 2.1: 添加 `optotypesPerLine` 字段（默认 5）
  - [x] SubTask 2.2: 添加 `maxErrorsPerLine` 字段（默认 1，错 2 个即停止）
  - [x] SubTask 2.3: 添加 `minCorrectPerLine` 字段（默认 3，5 题中对 3 题通过）
  - [x] SubTask 2.4: 添加 `requiredLineReversals` 字段（默认 2，行级反转次数）
  - [x] SubTask 2.5: 保留旧字段（requiredCorrectForStepDown, allowedWrongForStepUp, requiredReversalCount）但标记为 @deprecated
  - [x] SubTask 2.6: 更新 `copyWith` 方法
  - [x] SubTask 2.7: 运行测试验证

- [x] Task 3: 重构 QuestionRecord 数据模型
  - [x] SubTask 3.1: 添加 `lineIndex` 字段（int，当前行索引）
  - [x] SubTask 3.2: 添加 `optotypeIndexInLine` 字段（int，视标在行内序号）
  - [x] SubTask 3.3: 运行测试验证

- [x] Task 4: 重构 EyeTestResult 数据模型
  - [x] SubTask 4.1: 添加 `etdrsLetterScore` 字段（int）
  - [x] SubTask 4.2: 添加 `bestLineLogMar` 字段（double）
  - [x] SubTask 4.3: 添加 `lineReversals` 字段（List<LineReversalPoint>）
  - [x] SubTask 4.4: 将 `estimatedLogMar` 重命名为 `equivalentLogMar`
  - [x] SubTask 4.5: 移除 `reversalStdDev` 字段（标记为废弃）
  - [x] SubTask 4.6: 运行测试验证

- [x] Task 5: 添加 LineProgressState 和 LineReversalPoint 数据模型
  - [x] SubTask 5.1: 创建 `LineProgressState` 类
  - [x] SubTask 5.2: 包含字段：currentLineIndex, currentLogMar, currentLinePresentedCount, currentLineCorrectCount, currentLineErrorCount, totalPresentedCount, totalCorrectCount, lineDirection, lineReversalCount, protocolCompleted
  - [x] SubTask 5.3: 创建 `LineReversalPoint` 类
  - [x] SubTask 5.4: 包含字段：lineIndex, logMar, previousDirection, currentDirection, correctCount, errorCount
  - [x] SubTask 5.5: 添加 copyWith 方法
  - [x] SubTask 5.6: 运行测试验证

## Phase 2: ETDRS 风格测试引擎实现

- [x] Task 6: 实现 ETDRS 风格测试引擎
  - [x] SubTask 6.1: 创建 `etdrs_style_engine.dart` 文件
  - [x] SubTask 6.2: 实现 `EtdrsStyleEngine` 类
  - [x] SubTask 6.3: 实现 `initialState` 方法，返回初始 LineProgressState
  - [x] SubTask 6.4: 实现 `applyAnswer` 方法，处理答题并更新状态
  - [x] SubTask 6.5: 实现行级推进逻辑（每行 5 个视标）
  - [x] SubTask 6.6: 实现行通过判定（正确数 ≥ minCorrectPerLine）
  - [x] SubTask 6.7: 实现行失败判定（错误数 > maxErrorsPerLine，即错 2 个停止）
  - [x] SubTask 6.8: 实现行级反转记录（方向改变时记录 LineReversalPoint）
  - [x] SubTask 6.9: 实现测试终止条件（达到 requiredLineReversals 次反转）
  - [x] SubTask 6.10: 实现 `calculateLetterScore` 方法（letterScore = totalCorrect + 30）
  - [x] SubTask 6.11: 实现 `calculateEquivalentLogMar` 方法（logMAR = 1.7 - 0.02 × letterScore）
  - [x] SubTask 6.12: 实现 `calculateBestLineLogMar` 方法（通过的最小一行）
  - [x] SubTask 6.13: 实现 `buildEyeTestResult` 方法
  - [x] SubTask 6.14: 编写单元测试

## Phase 3: 测试会话控制器重构

- [x] Task 7: 重构 TestSessionController
  - [x] SubTask 7.1: 修改 `TestSessionState`，将 `staircaseState` 替换为 `lineProgressState`
  - [x] SubTask 7.2: 更新 `startSession` 方法，使用 ETDRS 风格引擎初始化
  - [x] SubTask 7.3: 更新 `_submitAnswerInternal` 方法，使用行级推进逻辑
  - [x] SubTask 7.4: 更新 `buildResult` 方法，调用 ETDRS 引擎的结果构建
  - [x] SubTask 7.5: 保留旧版 staircase 兼容代码但标记为 @deprecated
  - [x] SubTask 7.6: 运行现有测试，确保不破坏旧功能

## Phase 4: 废弃标记与兼容层

- [x] Task 8: 标记旧代码为废弃
  - [x] SubTask 8.1: 在 `staircase_estimator.dart` 添加 `@deprecated` 标记
  - [x] SubTask 8.2: 在 `ReversalPoint` 类添加 `@deprecated` 标记
  - [x] SubTask 8.3: 在 `StaircaseState` 类添加 `@deprecated` 标记
  - [x] SubTask 8.4: 添加废弃注释说明替代方案（使用 EtdrsStyleEngine）

## Phase 5: 测试与验证

- [x] Task 9: 编写 ETDRS 风格引擎单元测试
  - [x] SubTask 9.1: 测试行级推进逻辑（每行 5 题）
  - [x] SubTask 9.2: 测试行通过判定（正确数 ≥ 3）
  - [x] SubTask 9.3: 测试行失败判定（错误数 > 1，即错 2 个停止）
  - [x] SubTask 9.4: 测试行级反转记录
  - [x] SubTask 9.5: 测试测试终止条件（达到 2 次行级反转）
  - [x] SubTask 9.6: 测试字母分数计算（letterScore = totalCorrect + 30）
  - [x] SubTask 9.7: 测试等效 logMAR 计算（logMAR = 1.7 - 0.02 × letterScore）
  - [x] SubTask 9.8: 测试最佳行计算
  - [x] SubTask 9.9: 测试边界条件（空结果、全对、全错等）

- [x] Task 10: 集成测试
  - [x] SubTask 10.1: 测试完整 ETDRS 风格测试流程
  - [x] SubTask 10.2: 验证结果计算正确性（与示例数据对比）
  - [x] SubTask 10.3: 运行 `flutter test` 确保所有测试通过

## Phase 6: 文档同步

- [x] Task 11: 更新 `视力学公式与数据结构设计稿.md`
  - [x] SubTask 11.1: 更新数据模型定义（TestConfig, QuestionRecord, EyeTestResult, LineProgressState, LineReversalPoint）
  - [x] SubTask 11.2: 更新测试流程描述（ETDRS 风格，行级反转）
  - [x] SubTask 11.3: 添加结果计算示例

# Task Dependencies

- Task 6 依赖 Task 1, 2, 3, 4, 5
- Task 7 依赖 Task 6
- Task 9 依赖 Task 6
- Task 10 依赖 Task 7, 9
- Task 11 依赖 Task 10
