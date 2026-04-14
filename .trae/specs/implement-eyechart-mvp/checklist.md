# Android-only 精简执行清单

## 目标边界
- [x] 核心目标定义为 Android 应用交付
- [x] Windows 桌面端不作为验收门槛
- [x] iOS 暂不纳入当前迭代范围

## P0 今天执行
- [ ] 只处理阻断 Android 构建/运行/测试的问题
- [ ] 暂停 Windows 平台专项开发与专项修复
- [ ] 开发默认只跑核心测试文件，不跑全量
- [ ] 仅在模型/注解变更后运行代码生成
- [ ] 每天至少一次 Android 真机完整流程验证

## P1 1~3 天执行
- [ ] 将测试拆分为快速单测与慢速集成测试
- [ ] 建立固定的开发日常命令序列
- [ ] 建立提测前最小回归命令序列
- [ ] 将非阻断信息级告警降级到后续批处理

## P2 4~7 天执行
- [ ] 打通 Android debug/release 构建与安装
- [ ] 记录并跟踪核心反馈时间指标
- [ ] 固化每次迭代的验收证据（命令输出、截图、版本号）

## Windows PowerShell 命令基线

### 开发日常
```powershell
flutter test --no-pub test/vision/testing/
flutter test --no-pub test/vision/math/
```

### 仅在必要时执行
```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Android 构建与真机运行
```powershell
flutter run -d android
flutter build apk --debug
flutter build apk --release
```

## 一周后继续/迁移决策阈值
- [ ] 核心测试反馈速度达到团队可接受阈值
- [ ] 关键流程在 Android 真机回归稳定
- [ ] 不再频繁因生成链或平台差异阻断开发
- [ ] 若连续两周未达成，启动 Kotlin/Compose 迁移评估
