# 视力表自测应用

基于视力学原理的远视力自测应用。

## 功能特性

- 标准化 E 视标测试
- 基于视力学公式的精确计算
- 支持小数视力和五分制对数视力显示
- 基于 ETDRS 标准化流程的测试引擎
- 支持临床常见行读结果映射
- 像素瓶颈保护
- 本地历史记录

## 技术栈

- Flutter 3
- Riverpod (状态管理)
- GoRouter (路由)
- Drift (本地数据库)
- SharedPreferences (轻量存储)

## 开始使用

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 安装依赖

```bash
flutter pub get
```

### 生成代码

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 运行应用

```bash
flutter run -d windows
```

## 项目结构

```
lib/
├── app/                    # 应用层
│   ├── providers/          # Riverpod Providers
│   ├── platform/           # 平台适配
│   ├── router.dart         # 路由配置
│   ├── test_session_controller.dart
│   ├── result_interpreter.dart
│   └── fullscreen_service.dart
├── data/                   # 数据层
│   └── local/              # 本地存储
│       ├── database.dart
│       └── dao/
├── ui/                     # UI 层
│   ├── pages/              # 页面
│   ├── widgets/            # 组件
│   └── layout/
├── vision/                 # 领域层
│   ├── domain/             # 领域模型
│   ├── math/               # 视力学公式
│   └── testing/            # 测试引擎
├── eyechart_core.dart      # 核心导出
└── main.dart               # 应用入口
```

## 测试

```bash
flutter test
```

## 许可证

MIT License
