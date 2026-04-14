# Android MVP 闭环实施任务（可执行清单）

> 基于 TDD 与最小变更原则，每步 2-5 分钟粒度，便于频繁验证与提交

## 任务 1：抽取数据库 Provider（去除页面内定义）
- 新增文件：lib/app/providers/db_providers.dart
  - 提供 Provider<AppDatabase>、Provider<TestSessionDao>
- 修改文件：lib/ui/pages/history_page.dart
  - 移除本页内的 databaseProvider/testSessionDaoProvider 定义
  - 改为引用 db_providers.dart 中的 Provider
- 验证：
  - flutter analyze 通过
  - 历史页仍能正常加载历史数据（无新增或删除记录的情况下）

## 任务 2：新增持久化服务（封装 DAO 调用）
- 新增文件：lib/data/services/test_persistence_service.dart
  - 函数：Future<String> saveCompletedSession({...})
    - 插入一条 TestSessions，返回 sessionId
    - 批量插入 QuestionRecords
  - 通过 Riverpod 注入 TestSessionDao
- 验证：
  - 编译通过，服务可被注入

## 任务 3：在测试结束时落库并导航
- 修改文件：lib/ui/pages/test_run_page.dart
  - 在 _handleSessionFinished 中：
    - 调用 saveCompletedSession(...) 获取 sessionId
    - 将 sessionId 连同 EyeTestResult 作为参数导航至结果页
- 修改文件：lib/ui/pages/test_result_page.dart
  - 只读展示结果；不进行数据库写入
- 验证：
  - 运行一次完整流程（模拟器即可）：结束后不报错，能到达结果页

## 任务 4：历史页实时可见新记录
- 修改文件：lib/ui/pages/history_page.dart
  - sessionsProvider 调整为使用 dao.watchAllSessions() 或在返回时触发刷新
  - 确保从结果页返回历史页后立刻出现新记录
- 验证：
  - 真机/模拟器手动跑通一次：历史页出现刚完成会话

## 任务 5：参数默认值统一（以统一标准为准）
- 修改文件：lib/app/providers/test_config_provider.dart
  - 覆盖默认值：protocol=ETDRS、testDistanceMm=4000、nearFallbackDistanceMm=1000、optotypesPerLine=5、maxErrorsPerLine=2、answerTimeLimitMs=3000、minCriticalDetailPx=3.0、maxQuestionCount=50
- 调整/移除：lib/app/providers/app_providers.dart 中 testConfigProvider
  - 将所有引用处替换为 test_config_provider.dart 中的权威 Provider
- 验证：
  - flutter analyze 通过
  - 搜索工程确保不再引用旧 Provider

## 任务 6：持久化单元测试（Drift 内存库）
- 新增文件：test/data/local/test_persistence_test.dart
  - 用内存数据库构建 AppDatabase 与 TestSessionDao
  - 调用 saveCompletedSession 插入会话与题目记录
  - 读取会话与题目记录断言一致
- 运行：flutter test -r expanded test/data/local/test_persistence_test.dart
- 验证：测试通过

## 任务 7：M1/M2 验收与证据回填
- AO-003（debug 真机闭环）
  - 安装 debug APK：adb install -r build/app/outputs/flutter-apk/app-debug.apk
  - 跑通开始→答题→结果→历史的完整流程
  - 截图并回填版本、设备信息
- AO-005（release 安装运行）
  - 安装 release APK：adb install -r build/app/outputs/flutter-apk/app-release.apk
  - 冷启动与核心路径验证
  - 截图回填

## 任务 8：文档更新
- 更新 Android-only 规格、参数默认值说明
- 在仓库 docs/ 下新增或更新说明，链接至截图证据
