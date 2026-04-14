# Android MVP 闭环规格（持久化打通 + 参数统一 + 真机验收）

## 1. 范围与目标
- 平台范围：仅 Android（Flutter）
- 目标：
  - 在“测试结束”时自动将会话与题目记录持久化到本地数据库（Drift）
  - 历史页返回后立即可见刚完成的记录（实时订阅或主动刷新）
  - 统一测试参数默认值与来源，采用 `临床视力测试标准基线.md` + 《设计稿》同步口径作为唯一权威默认值
  - 完成 AO-003（debug 真机闭环）与 AO-005（release 安装运行）验收并回填证据

## 2. 现状依据（关键文件）
- 数据库定义与 DAO：
  - [database.dart](file:///v:/eyechart/lib/data/local/database.dart)
  - [test_session_dao.dart](file:///v:/eyechart/lib/data/local/dao/test_session_dao.dart)
- 历史页（当前仅读取）：  
  - [history_page.dart](file:///v:/eyechart/lib/ui/pages/history_page.dart)
- 测试流程与结束跳转（当前未落库）：  
  - [test_session_controller.dart](file:///v:/eyechart/lib/app/test_session_controller.dart)  
  - [test_run_page.dart](file:///v:/eyechart/lib/ui/pages/test_run_page.dart)  
  - [test_result_page.dart](file:///v:/eyechart/lib/ui/pages/test_result_page.dart)
- 参数提供者（存在两套默认值）：  
  - [test_config_provider.dart](file:///v:/eyechart/lib/app/providers/test_config_provider.dart)  
  - [app_providers.dart](file:///v:/eyechart/lib/app/providers/app_providers.dart)

## 3. 核心决策
- 参数默认值口径：采用 `临床视力测试标准基线.md` 与《设计稿》统一后的默认值
  - protocol = ETDRS
  - testDistanceMm = 4000
  - nearFallbackDistanceMm = 1000
  - optotypesPerLine = 5
  - maxErrorsPerLine = 2
  - answerTimeLimitMs = 3000
  - minCriticalDetailPx = 3.0
  - maxQuestionCount = 50
- 落库时机：测试结束即自动写入（经用户确认）
- 历史页策略：实时订阅或返回后自动刷新（经用户确认）

## 4. 技术方案
### 4.1 数据流与职责
- TestRunPage 检测到会话结束时，收集 EyeTestResult 与题目轨迹
- 通过 Riverpod 注入的 TestPersistenceService 调用 TestSessionDao：
  - 插入一条 TestSessions（生成 sessionId、startedAt、endedAt、eyeSide、核心指标等）
  - 批量插入 QuestionRecords（questionIndex、lineIndex、optotypeIndexInLine、呈现的 logMAR/方向、用户应答、正误等）
  - 返回 sessionId
- 导航到 ResultPage 时携带 sessionId 与结果对象
- 历史页通过 watchAllSessions()（或返回时触发刷新）展示最新记录

### 4.2 代码变更点
- 新增共享 Provider 文件，避免在页面内定义 DB Provider：
  - 新增：lib/app/providers/db_providers.dart  
    - 提供 AppDatabase、TestSessionDao 的 Provider
  - 调整：history_page.dart 改为引用上述 Provider，移除页面内的 Provider 定义
- 新增持久化服务：
  - 新增：lib/data/services/test_persistence_service.dart  
    - saveCompletedSession(...)：封装插入会话与批量插入题目记录，返回 sessionId
- 接入落库调用：
  - 修改：test_run_page.dart  
    - 在 _handleSessionFinished 中调用 saveCompletedSession 后再导航至结果页
  - 结果页无需再落库，仅展示
- 参数统一：
  - 修改：test_config_provider.dart 默认值对齐统一标准口径（protocol/行级参数/超时/像素阈值）
  - 调整/移除：app_providers.dart 中的 testConfigProvider，所有调用迁移至 test_config_provider.dart 提供的权威 Provider

### 4.3 数据模型与字段对应（概要）
- TestSessions：id（string/uuid）、startedAt、endedAt、eyeSide、equivalentLogMar、bestLineLogMar、decimalAcuity、etdrsLetterScore、lineConsistencyScore 等
- QuestionRecords：sessionId、questionIndex、lineIndex、optotypeIndexInLine、targetLogMar、targetDirection、answer、isCorrect、timestamp 等
- 以上字段以已存在的 Drift 表定义为准；如有字段缺口，以最小变更为原则补齐

## 5. 测试与验证
### 5.1 自动化测试
- 新增 tests/data/local/test_persistence_test.dart：
  - 使用内存数据库验证：插入会话 + 批量插入题目记录 + 读取历史 = 数据一致
  - 覆盖失败用例：空题目列表/重复 sessionId 等（按需）
### 5.2 手动验证（M1/M2 验收）
- M1（Android MVP 闭环成立）
  - debug 真机：开始测试 → 答题 → 结果 → 返回历史页立即可见记录
  - 记录 sessionId 与关键字段截图
- M2（Android 可发布验证）
  - release APK 安装 → 冷启动 → 核心流程无阻断
  - 关键页面截图可回溯

## 6. 风险与缓解
- 参数口径调整可能影响结果一致性 → 以统一标准文档为准，真机复测验证
- 持久化接入可能引入 UI 卡顿 → 在服务层批量插入，必要时异步/最小化 UI 阻塞
- Drift schema 变更风险 → 本次优先“不改表”，如需变更则补充 migration 与测试

## 7. 交付物
- 功能：测试结束自动入库；历史页立即可见
- 代码：db_providers.dart、test_persistence_service.dart、test_run_page.dart 修改、参数 Provider 统一
- 测试：test_persistence_test.dart 通过；flutter analyze 通过
- 文档：回填 AO-003/AO-005 验收截图与统一标准参数说明
