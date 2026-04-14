# 视力表自测应用 MVP 开发任务

## 阶段一：M1 核心引擎完善

### Task 1: 补充 M1 单元测试
为核心计算逻辑建立可回归的单元测试。

- [x] SubTask 1.1: 创建视力学公式测试文件
  - 创建 `test/vision/math/vision_math_test.dart`
  - 测试 logMAR、MAR、小数视力、五分制对数视力互转
  - 验证设计稿中的样例值（1.0/0.5/0.1 视力）
  - 测试非法输入抛错

- [x] SubTask 1.2: 创建渲染尺寸测试文件
  - 创建 `test/vision/math/render_metrics_test.dart`
  - 测试物理尺寸到像素尺寸映射
  - 测试像素瓶颈判定（3.0/2.0/1.9 边界）
  - 测试横竖像素不一致场景

- [x] SubTask 1.3: 创建标准化流程测试文件
  - 创建 `test/vision/testing/` 下的标准化流程测试
  - 测试行内正确数统计
  - 测试行推进与终止条件
  - 测试 ETDRS 分数换算
  - 测试临床兼容行结果映射

## 阶段二：M2 Windows MVP

### Task 2: 初始化 Flutter 项目骨架
建立 Flutter 应用框架和基础结构。

- [x] SubTask 2.1: 创建 Flutter 项目
  - 配置 pubspec.yaml 添加依赖（riverpod, go_router, drift, shared_preferences, json_serializable, logger）
  - 配置 Windows 平台支持

- [x] SubTask 2.2: 建立目录结构
  - 创建 `lib/app/` 目录（路由、状态管理）
  - 创建 `lib/ui/pages/` 目录（页面）
  - 创建 `lib/ui/widgets/` 目录（组件）
  - 创建 `lib/data/` 目录（存储层）

- [x] SubTask 2.3: 配置路由
  - 创建 `lib/app/router.dart`
  - 定义路由：设备配置页、测试准备页、测试执行页、结果页、历史页
  - 使用 GoRouter 实现路由管理

### Task 3: 实现设备配置页面
支持用户输入屏幕物理参数。

- [x] SubTask 3.1: 创建设备配置页面
  - 创建 `lib/ui/pages/device_config_page.dart`
  - 实现屏幕物理宽度输入框
  - 实现屏幕物理高度输入框
  - 显示当前屏幕分辨率（只读）
  - 显示计算后的像素物理尺寸

- [x] SubTask 3.2: 实现配置状态管理
  - 创建 `lib/app/providers/device_config_provider.dart`
  - 使用 Riverpod 管理设备配置状态
  - 实现配置保存和加载

### Task 4: 实现 E 视标绘制组件
参数化绘制标准 E 视标。

- [x] SubTask 4.1: 创建 E 视标绘制器
  - 创建 `lib/ui/widgets/e_optotype_painter.dart`
  - 实现 CustomPainter 自绘 E 视标
  - 保证 5×5 单元结构
  - 支持四方向旋转

- [x] SubTask 4.2: 创建 E 视标组件
  - 创建 `lib/ui/widgets/e_optotype_view.dart`
  - 封装绘制器为可复用组件
  - 支持尺寸和方向参数
  - 支持颜色配置

### Task 5: 实现测试准备页面
配置测试参数并显示测试前说明。

- [x] SubTask 5.1: 创建测试准备页面
  - 创建 `lib/ui/pages/test_prepare_page.dart`
  - 实现测试距离输入
  - 实现眼别选择（左眼/右眼/双眼）
  - 实现测试模式选择（孤立/拥挤）

- [x] SubTask 5.2: 实现测试前说明
  - 显示遮眼方式提示
  - 显示测试距离提示
  - 显示环境光建议
  - 显示结果参考性质说明

### Task 6: 实现测试执行页面
核心测试流程实现。

- [x] SubTask 6.1: 创建测试执行页面
  - 创建 `lib/ui/pages/test_run_page.dart`
  - 显示当前 E 视标
  - 显示当前档位信息
  - 显示答题进度

- [x] SubTask 6.2: 实现键盘输入处理
  - 监听方向键事件
  - 映射到上/下/左/右方向
  - 实现输入防抖

- [x] SubTask 6.3: 实现触控方向按钮
  - 创建 `lib/ui/widgets/direction_pad.dart`
  - 实现四个方向按钮
  - 支持移动端触控输入

- [x] SubTask 6.4: 实现题目控制逻辑
  - 创建 `lib/app/test_session_controller.dart`
  - 实现随机方向生成
  - 实现单题判定
  - 实现行级推进
  - 实现逐视标记录
  - 实现终止条件判断

### Task 7: 实现结果页面
展示测试结果和详细信息。

- [x] SubTask 7.1: 创建结果页面
  - 创建 `lib/ui/pages/test_result_page.dart`
  - 主显示小数视力
  - 辅助显示五分制对数视力
  - 显示 logMAR 值

- [x] SubTask 7.2: 实现详细信息展示
  - 显示题量和正确率
  - 显示测试距离
  - 显示设备参数
  - 显示可信度提示

### Task 8: 实现本地存储
持久化设备配置和测试历史。

- [x] SubTask 8.1: 配置数据库
  - 创建 `lib/data/local/database.dart`
  - 使用 drift 定义表结构
  - 定义 ScreenProfile 表
  - 定义 TestSession 表
  - 定义 QuestionRecord 表

- [x] SubTask 8.2: 实现数据访问层
  - 创建 `lib/data/local/dao/screen_profile_dao.dart`
  - 创建 `lib/data/local/dao/test_session_dao.dart`
  - 实现增删改查接口

- [x] SubTask 8.3: 实现历史记录页面
  - 创建 `lib/ui/pages/history_page.dart`
  - 显示历史测试列表
  - 支持查看详情

### Task 9: Windows DPI 与全屏适配
处理 Windows 平台特性。

- [x] SubTask 9.1: 实现 DPI 感知
  - 创建 `windows/runner/app.manifest` 启用 DPI 感知
  - 创建 `lib/app/platform/windows_display_service.dart`
  - 获取真实显示分辨率
  - 处理系统缩放修正

- [x] SubTask 9.2: 实现全屏模式
  - 创建 `lib/app/fullscreen_service.dart`
  - 实现测试页面全屏切换
  - 保持全屏状态稳定

## 阶段三：M3 移动端适配

### Task 10: 移动端输入与横屏流程
适配移动端平台。

- [ ] SubTask 10.1: 强制横屏
  - 配置 Android/iOS 横屏锁定
  - 适配横屏布局

- [ ] SubTask 10.2: 优化触控输入
  - 优化方向按钮布局
  - 适配不同屏幕尺寸

### Task 11: 安全区与异形屏适配
处理移动端显示特性。

- [ ] SubTask 11.1: 实现安全区处理
  - 创建 `lib/ui/layout/adaptive_scaffold.dart`
  - 处理刘海屏/打孔屏边界
  - 保证关键 UI 不被遮挡

- [ ] SubTask 11.2: 测试异形屏适配
  - 测试常见异形屏机型
  - 修复布局问题

## 阶段四：M4 可靠性增强

### Task 12: 拥挤效应模式
实现拥挤效应测试模式。

- [ ] SubTask 12.1: 实现拥挤效应绘制
  - 修改 E 视标组件支持 flankers
  - 实现边框干扰元素

- [ ] SubTask 12.2: 集成模式切换
  - 在测试配置中支持模式选择
  - 记录测试模式到题目记录

### Task 13: 可信度指标与重测建议
提供结果可信度评估。

- [ ] SubTask 13.1: 计算可信度指标
  - 计算行级稳定性
  - 计算平均反应时
  - 制定可信度等级

- [ ] SubTask 13.2: 实现重测建议
  - 在结果页显示可信度
  - 波动异常时提示重测

### Task 14: 趋势分析
支持历史趋势查看。

- [ ] SubTask 14.1: 实现趋势数据聚合
  - 创建 `lib/data/analytics/history_analytics_service.dart`
  - 按眼别聚合历史数据

- [ ] SubTask 14.2: 实现趋势图
  - 创建 `lib/ui/pages/history_trend_page.dart`
  - 显示视力变化趋势图

# Task Dependencies
- [Task 2] 依赖 [Task 1] 完成
- [Task 3] 依赖 [Task 2] 完成
- [Task 4] 依赖 [Task 2] 完成，可与 [Task 3] 并行
- [Task 5] 依赖 [Task 3] 完成
- [Task 6] 依赖 [Task 4] 和 [Task 5] 完成
- [Task 7] 依赖 [Task 6] 完成
- [Task 8] 依赖 [Task 2] 完成，可与 [Task 4] 并行
- [Task 9] 依赖 [Task 6] 完成
- [Task 10] 依赖 [Task 6] 完成
- [Task 11] 依赖 [Task 10] 完成
- [Task 12] 依赖 [Task 6] 完成
- [Task 13] 依赖 [Task 7] 完成
- [Task 14] 依赖 [Task 8] 完成

# 优先级建议
首期优先完成：Task 1 → Task 2 → Task 3 → Task 4 → Task 5 → Task 6 → Task 7 → Task 8 → Task 9 ✅ 已完成
第二期完成：Task 10 → Task 11 → Task 12 → Task 13 → Task 14
