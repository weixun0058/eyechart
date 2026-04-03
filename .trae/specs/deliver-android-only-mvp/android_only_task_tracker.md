# Android-only 可跟踪任务清单

## 使用规则
- 状态仅允许：`todo` / `doing` / `blocked` / `done`
- 每次状态变化都要更新“最后更新时间”和“证据”
- 证据必须可回溯：命令、输出摘要、文件路径、截图编号
- 若任务阻塞，必须在“阻塞原因”写明下一步解法

## 当前迭代任务

| ID | 任务 | 优先级 | 状态 | 验收标准 | 证据 | 阻塞原因 | 负责人 | 最后更新时间 |
|---|---|---|---|---|---|---|---|---|
| AO-001 | 锁定 Android-only 交付边界 | P0 | done | 文档中明确 Android 为唯一验收目标 | `.trae/specs/deliver-android-only-mvp/spec.md`、`.trae/specs/deliver-android-only-mvp/checklist.md` | 无 | AI+用户 | 2026-04-04 |
| AO-002 | 收敛核心测试反馈回路 | P0 | doing | 能稳定执行核心测试命令并用于日常开发 | 本机执行 `flutter test --no-pub test/vision/math/render_metrics_test.dart`，输出 `All tests passed!`，耗时约 2s | staircase 核心测试仍待同口径复核与耗时记录 | AI+用户 | 2026-04-04 |
| AO-003 | 建立 Android 真机日回归流程 | P0 | todo | 每日完成一次“开始测试→答题→结果→历史”闭环验证 | 待补充 | 待执行 | 用户 | 2026-04-04 |
| AO-004 | 建立提测前最小回归命令清单 | P1 | done | 一条命令序列覆盖核心单测与 Android 构建 | `.trae/specs/deliver-android-only-mvp/android_only_task_tracker.md` 中“提测前最小回归命令序列（A1.3）” | 无 | AI | 2026-04-04 |
| AO-005 | 打通 release APK 构建与安装验证 | P2 | todo | 能产出 release APK 且可安装运行 | 待补充 | 待执行 | 用户 | 2026-04-04 |
| AO-006 | 一周后技术路径复盘 | P2 | todo | 基于反馈速度和稳定性决定“继续 Flutter/迁移原生” | 待补充 | 待执行 | AI+用户 | 2026-04-04 |

## 开发日常命令序列（A1.2）

```powershell
flutter test --no-pub test/vision/testing/staircase_estimator_test.dart
flutter test --no-pub test/vision/math/
```

## 提测前最小回归命令序列（A1.3）

```powershell
flutter test --no-pub test/vision/testing/staircase_estimator_test.dart
flutter test --no-pub test/vision/math/
flutter build apk --debug
```

## 代码生成触发策略（A5）

仅在以下变更时运行：
- `lib/**` 中新增/修改了 `@riverpod`、`@JsonSerializable`、drift 表/DAO 定义
- `pubspec.yaml` 变更导致生成配置可能受影响

非上述变更时不运行 `build_runner`，直接执行核心测试命令验证。

执行命令：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## 每日跟踪记录

| 日期 | 完成项 | 新增阻塞 | 下一步 |
|---|---|---|---|
| 2026-04-04 | Android-only 清单已落地，任务追踪文件已初始化 | 当前环境测试命令存在长时与权限限制 | 在本机 PowerShell 执行核心命令并回填证据 |
| 2026-04-04 | 已固化开发日常/提测前命令序列，已定义代码生成触发策略 | 沙箱内核心测试命令连续超时并被跳过 | 在本机 PowerShell 执行并回填耗时与结果 |
| 2026-04-04 | render_metrics 核心测试本机通过（All tests passed）并完成对应断言修正 | staircase 核心测试尚未补齐同口径结果 | 执行 staircase 核心测试并进入 Android 真机闭环 |

## 回填模板

```text
[任务ID]
状态:
执行命令:
结果摘要:
证据位置:
阻塞原因:
下一步:
更新时间:
```
