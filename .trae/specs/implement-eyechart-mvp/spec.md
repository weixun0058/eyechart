# 视力表自测应用 MVP 实现规格

## Why
开发一个基于视力学原理的远视力自测应用，支持用户通过标准 E 视标完成专业化的视力测试。项目已有核心领域层代码，需要完成单元测试、Flutter 应用壳、UI 页面、本地存储等模块，最终交付 Windows MVP 版本。

## What Changes
- 补充 M1 阶段单元测试，确保核心计算逻辑可验证
- 创建 Flutter 应用骨架，建立路由与状态管理
- 实现设备配置页面，支持屏幕物理尺寸输入
- 实现测试准备页面，支持测试参数配置
- 实现 E 视标绘制组件，支持参数化渲染
- 实现测试执行页面，支持键盘/触控输入
- 实现结果页面，展示小数视力和五分制对数视力
- 实现本地存储，保存设备配置和测试历史
- 处理 Windows DPI 感知与缩放修正
- 支持移动端触控输入与横屏适配

## Impact
- Affected specs: 视力学公式与数据结构设计稿, 项目规划
- Affected code: 
  - 新增: `lib/app/`, `lib/ui/`, `lib/data/`, `test/`
  - 已有: `lib/vision/` (领域层已完成)

## ADDED Requirements

### Requirement: M1 单元测试
系统 SHALL 提供完整的单元测试覆盖核心计算逻辑。

#### Scenario: 视力学公式转换测试
- **WHEN** 执行公式转换测试
- **THEN** logMAR、MAR、小数视力、五分制对数视力互转结果与设计稿公式一致
- **AND** 回环转换误差在可接受范围内

#### Scenario: 渲染尺寸计算测试
- **WHEN** 给定屏幕参数和测试距离
- **THEN** 视标物理尺寸和像素尺寸计算正确
- **AND** 像素瓶颈判定逻辑正确触发

#### Scenario: 阶梯法状态迁移测试
- **WHEN** 连续答对 3 次
- **THEN** 档位下降 0.1 logMAR
- **WHEN** 答错 1 次
- **THEN** 档位上升 0.1 logMAR
- **AND** 反转点正确识别和记录

### Requirement: Flutter 应用骨架
系统 SHALL 提供完整的 Flutter 应用框架。

#### Scenario: 路由配置
- **WHEN** 应用启动
- **THEN** 可导航至设备配置页、测试准备页、测试执行页、结果页
- **AND** 页面参数正确传递

#### Scenario: 状态管理
- **WHEN** 使用 Riverpod 管理状态
- **THEN** 测试会话状态可在页面间共享
- **AND** 设备配置可持久化

### Requirement: 设备配置页面
系统 SHALL 支持用户输入屏幕物理参数。

#### Scenario: 屏幕尺寸输入
- **WHEN** 用户输入屏幕物理宽度和高度
- **THEN** 系统自动读取屏幕分辨率
- **AND** 计算并显示像素物理尺寸

#### Scenario: 配置保存
- **WHEN** 用户完成配置
- **THEN** 配置保存至本地存储
- **AND** 下次启动自动加载

### Requirement: E 视标绘制组件
系统 SHALL 提供参数化的 E 视标绘制能力。

#### Scenario: 标准结构
- **WHEN** 渲染 E 视标
- **THEN** 符合 5×5 单元结构
- **AND** 笔画宽度 = 缺口宽度 = 1 单元

#### Scenario: 方向旋转
- **WHEN** 指定方向为上/下/左/右
- **THEN** E 视标正确旋转显示

#### Scenario: 尺寸控制
- **WHEN** 给定目标像素尺寸
- **THEN** 视标尺寸与 RenderMetrics 计算结果一致

### Requirement: 测试执行页面
系统 SHALL 支持完整的测试流程。

#### Scenario: 题目展示
- **WHEN** 开始测试
- **THEN** 显示当前档位的 E 视标
- **AND** 方向随机生成

#### Scenario: 键盘输入
- **WHEN** 用户按下方向键
- **THEN** 立即判定正误
- **AND** 记录答题数据

#### Scenario: 触控输入
- **WHEN** 用户点击方向按钮
- **THEN** 立即判定正误
- **AND** 记录答题数据

#### Scenario: 档位调整
- **WHEN** 满足升降档条件
- **THEN** 自动调整视标大小
- **AND** 检查像素瓶颈

#### Scenario: 测试终止
- **WHEN** 达到终止条件
- **THEN** 结束测试并跳转结果页

### Requirement: 结果页面
系统 SHALL 展示测试结果。

#### Scenario: 主结果显示
- **WHEN** 显示测试结果
- **THEN** 主显示小数视力
- **AND** 辅助显示五分制对数视力

#### Scenario: 详细信息
- **WHEN** 查看结果详情
- **THEN** 显示题量、正确率、测试距离、设备参数

### Requirement: 本地存储
系统 SHALL 持久化关键数据。

#### Scenario: 设备配置存储
- **WHEN** 保存设备配置
- **THEN** 数据写入本地数据库
- **AND** 应用重启后可恢复

#### Scenario: 测试历史存储
- **WHEN** 完成测试
- **THEN** 测试会话完整保存
- **AND** 支持历史查询

### Requirement: Windows DPI 处理
系统 SHALL 正确处理 Windows 缩放。

#### Scenario: DPI 感知
- **WHEN** Windows 系统缩放非 100%
- **THEN** 视标尺寸仍按物理公式正确计算
- **AND** 不受系统缩放影响

### Requirement: 移动端适配
系统 SHALL 支持移动端平台。

#### Scenario: 横屏测试
- **WHEN** 在移动端运行
- **THEN** 强制横屏测试流程
- **AND** 布局正确适配

#### Scenario: 安全区处理
- **WHEN** 设备有刘海或打孔
- **THEN** 关键 UI 不被遮挡
- **AND** 测试区域完整显示

## MODIFIED Requirements
无修改需求，均为新增功能。

## REMOVED Requirements
无移除需求。
