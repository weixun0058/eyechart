# Android MVP 闭环验收清单

## 功能闭环
- [x] 测试结束即写入一条 TestSessions 记录
- [x] 同步批量写入对应的 QuestionRecords
- [ ] 从结果页返回历史页后，立刻可见刚完成记录
- [ ] 无 UI 卡顿或崩溃

## 参数统一
- [x] 默认值与统一标准对齐：protocol=ETDRS
- [x] 默认值与统一标准对齐：testDistanceMm=4000
- [x] 默认值与统一标准对齐：nearFallbackDistanceMm=1000
- [x] 默认值与统一标准对齐：optotypesPerLine=5
- [x] 默认值与统一标准对齐：maxErrorsPerLine=2
- [x] 默认值与《设计稿》对齐：answerTimeLimitMs=3000
- [x] 默认值与《设计稿》对齐：minCriticalDetailPx=3.0
- [x] 工程不再引用 app_providers.dart 中旧的 testConfigProvider
- [x] flutter analyze 通过

## 自动化测试
- [x] 新增 test_persistence_test.dart 并通过
- [x] 现有数学与标准化流程相关测试继续通过

## 真机证据（M1/M2）
- [ ] AO-003：debug 真机全流程截图已回填
- [ ] AO-005：release 安装运行与冷启动截图已回填
- [ ] 记录测试设备型号、系统版本、APK 版本信息

## 文档
- [ ] 更新 Android-only 规格说明
- [ ] 更新统一标准参数默认值与解释
- [ ] 链接真机截图证据
