# Checklist

## 数据模型

- [x] `SessionEndReason` 已添加 `protocolCompleted`
- [x] `TestConfig` 已添加 `optotypesPerLine` 字段
- [x] `TestConfig` 已添加 `maxErrorsPerLine` 字段（默认 1，错 2 个停止）
- [x] `TestConfig` 已添加 `minCorrectPerLine` 字段（默认 3）
- [x] `TestConfig` 已添加 `requiredLineReversals` 字段（默认 2）
- [x] `TestConfig` 旧字段已标记 `@deprecated`
- [x] `QuestionRecord` 已添加 `lineIndex` 字段
- [x] `QuestionRecord` 已添加 `optotypeIndexInLine` 字段
- [x] `EyeTestResult` 已添加 `etdrsLetterScore` 字段
- [x] `EyeTestResult` 已添加 `bestLineLogMar` 字段
- [x] `EyeTestResult` 已添加 `lineReversals` 字段
- [x] `EyeTestResult` `estimatedLogMar` 已重命名为 `equivalentLogMar`
- [x] `EyeTestResult` `reversalStdDev` 已标记废弃
- [x] `LineProgressState` 类已创建
- [x] `LineProgressState` 包含所有必需字段
- [x] `LineReversalPoint` 类已创建
- [x] `LineReversalPoint` 包含所有必需字段

## ETDRS 风格引擎

- [x] `etdrs_style_engine.dart` 文件已创建
- [x] `EtdrsStyleEngine` 类已实现
- [x] `initialState` 方法已实现
- [x] `applyAnswer` 方法已实现
- [x] 行级推进逻辑正确（每行 5 个视标）
- [x] 行通过判定正确（正确数 ≥ minCorrectPerLine）
- [x] 行失败判定正确（错误数 > maxErrorsPerLine，即错 2 个停止）
- [x] 行级反转记录正确（LineReversalPoint）
- [x] 测试终止条件正确（达到 requiredLineReversals 次反转）
- [x] `calculateLetterScore` 方法正确（letterScore = totalCorrect + 30）
- [x] `calculateEquivalentLogMar` 方法正确（logMAR = 1.7 - 0.02 × letterScore）
- [x] `calculateBestLineLogMar` 方法正确
- [x] `buildEyeTestResult` 方法正确

## 测试会话控制器

- [x] `TestSessionState` 已使用 `lineProgressState`
- [x] `startSession` 方法已使用 ETDRS 风格引擎
- [x] `_submitAnswerInternal` 方法已使用行级推进
- [x] `buildResult` 方法已调用 ETDRS 引擎
- [x] 旧版 staircase 兼容代码已标记 `@deprecated`

## 废弃标记

- [x] `staircase_estimator.dart` 已标记 `@deprecated`
- [x] `ReversalPoint` 类已标记 `@deprecated`
- [x] `StaircaseState` 类已标记 `@deprecated`
- [x] 废弃注释已说明替代方案

## 单元测试

- [x] ETDRS 风格引擎行级推进测试通过
- [x] ETDRS 风格引擎行通过判定测试通过
- [x] ETDRS 风格引擎行失败判定测试通过（错 2 个停止）
- [x] ETDRS 风格引擎行级反转记录测试通过
- [x] ETDRS 风格引擎测试终止条件测试通过
- [x] ETDRS 风格引擎字母分数计算测试通过
- [x] ETDRS 风格引擎等效 logMAR 计算测试通过
- [x] ETDRS 风格引擎最佳行计算测试通过
- [x] 所有边界条件测试通过

## 集成测试

- [x] 完整 ETDRS 风格测试流程测试通过
- [x] 结果计算正确性验证通过
- [x] `flutter test` 全部通过

## 文档

- [x] `视力学公式与数据结构设计稿.md` 已更新数据模型定义
- [x] `视力学公式与数据结构设计稿.md` 已更新测试流程描述
- [x] `视力学公式与数据结构设计稿.md` 已添加结果计算示例
