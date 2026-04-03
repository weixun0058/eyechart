# Android-only MVP 规格说明

## Why
以 Android 作为唯一交付目标，收缩多端复杂度，重建快速反馈回路，优先实现真机稳定闭环与可发布产物。

## What Changes
- 将产品验收边界改为 Android-only，Windows/iOS 不作为当前迭代验收门槛
- 重构测试策略：核心域逻辑单测为主，集成/UI 测试降频
- 固化 Android 构建与真机回归命令序列，形成可追溯证据
- 规范代码生成触发点：仅在模型/注解改动时运行 build_runner
- 建立迭代度量：核心测试耗时、构建耗时、冷启动耗时
- **BREAKING** 将 Windows 专项适配（DPI/全屏/桌面交互）移出当前迭代范围

## Impact
- 受影响能力：
  - 构建与测试流程（命令、频率、证据留存）
  - 发布链路（debug/release APK）
  - 任务与验收标准（Android 真机闭环）
- 受影响代码（仅示例，按需变更）：
  - test/vision/**（核心域逻辑测试）
  - lib/app/test_session_controller.dart（测试流程控制）
  - lib/ui/pages/**（测试运行与结果展示）
  - pubspec.yaml（依赖与生成工具）

## ADDED Requirements
### Requirement: Android 真机回归闭环
系统 SHALL 在 Android 真机完成“开始测试→答题→结果→历史记录”完整流程，并留存证据。

#### Scenario: 成功闭环
- WHEN 开发者执行固定命令序列并在真机运行应用
- THEN 流程无阻断，结果页显示预期数据，历史页出现记录，且有命令输出与截图证据

### Requirement: 快速核心测试
系统 SHALL 提供核心测试文件的快速执行路径，并作为日常开发的验证基线。

#### Scenario: 快速测试
- WHEN 执行核心测试命令
- THEN 在可接受时间内得到稳定结果（目标 < 10s 级别），用于驱动开发迭代

### Requirement: 可追溯发布产物
系统 SHALL 产出可安装的 debug/release APK，并记录构建参数与版本号。

#### Scenario: 产出 APK
- WHEN 执行构建命令
- THEN 生成 APK 文件，安装运行正常，并记录版本、时间与输出摘要

## MODIFIED Requirements
### Requirement: 代码生成触发策略
从“频繁运行 build_runner”修改为“仅在模型/注解变更时运行”，以减少构建开销并提升反馈速度。

## REMOVED Requirements
### Requirement: Windows 专项适配纳入当前迭代验收
Reason: 与 Android-only 目标不一致，会降低反馈效率  
Migration: 相关任务移入 backlog，待 Android 路线稳定后再单独排期
