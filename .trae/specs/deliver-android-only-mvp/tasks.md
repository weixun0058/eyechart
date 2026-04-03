# Tasks

- [x] Task A1: 固化 Android-only 边界与命令基线
  - [x] SubTask A1.1: 在文档中声明 Android-only 验收边界
  - [x] SubTask A1.2: 建立开发日常命令序列（核心测试）
  - [x] SubTask A1.3: 建立提测前最小回归命令序列
  - 验证: 文档存在且命令可执行，输出被记录为证据

- [ ] Task A2: 收敛核心测试反馈回路
  - [x] SubTask A2.1: 仅执行核心测试文件（staircase、math）
  - [ ] SubTask A2.2: 记录核心测试耗时并形成时间序列
  - [x] SubTask A2.3: 若耗时异常，分析生成链或环境因素并出具调整建议
  - 验证: 核心测试稳定、耗时可接受或有清晰整改路径

- [ ] Task A3: Android 真机日回归闭环
  - [ ] SubTask A3.1: 运行应用到真机
  - [ ] SubTask A3.2: 完成“开始测试→答题→结果→历史记录”闭环
  - [ ] SubTask A3.3: 回填证据（命令输出、截图、版本号）
  - 验证: 闭环完整，证据可追溯

- [ ] Task A4: Android 构建与发布产物
  - [ ] SubTask A4.1: 产出 debug APK 并安装验证
  - [ ] SubTask A4.2: 产出 release APK 并安装验证
  - [ ] SubTask A4.3: 记录构建参数与版本号
  - 验证: APK 可安装运行，有证据记录

- [x] Task A5: 代码生成触发策略调整
  - [x] SubTask A5.1: 梳理模型/注解改动清单
  - [x] SubTask A5.2: 调整本地流程，仅在上述改动时运行 build_runner
  - 验证: 非必要改动不触发生成链，反馈速度提升

# Task Dependencies
- [Task A2] 依赖 [Task A1] 命令基线完成
- [Task A3] 可并行于 [Task A2]，但以核心测试通过为前提
- [Task A4] 依赖 [Task A1] 命令基线完成
- [Task A5] 可与 [Task A2] 并行
