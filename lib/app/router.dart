import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/providers/app_providers.dart';
import '../app/providers/device_config_provider.dart';
import '../ui/pages/device_config_page.dart';
import '../ui/pages/test_prepare_page.dart';
import '../ui/pages/test_run_page.dart';
import '../ui/pages/test_result_page.dart';
import '../ui/pages/history_page.dart';
import '../vision/domain/vision_models.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const LaunchGatePage(),
    ),
    GoRoute(
      path: '/config',
      name: 'config',
      builder: (context, state) => const DeviceConfigPage(),
    ),
    GoRoute(
      path: '/prepare',
      name: 'prepare',
      builder: (context, state) => const TestPreparePage(),
    ),
    GoRoute(
      path: '/test',
      name: 'test',
      builder: (context, state) {
        final config = state.extra as TestConfig?;
        if (config == null) {
          return _buildInvalidArgumentPage(
            context,
            title: '参数错误',
            message: '测试配置缺失，请返回测试准备页重新开始。',
            backPath: '/prepare',
            buttonLabel: '返回准备页',
          );
        }
        return TestRunPage(config: config);
      },
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
        final result = state.extra as EyeTestResult?;
        return TestResultPage(result: result);
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('页面未找到'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            '页面未找到: ${state.matchedLocation}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('返回首页'),
          ),
        ],
      ),
    ),
  ),
);

class LaunchGatePage extends ConsumerStatefulWidget {
  const LaunchGatePage({super.key});

  @override
  ConsumerState<LaunchGatePage> createState() => _LaunchGatePageState();
}

class _LaunchGatePageState extends ConsumerState<LaunchGatePage> {
  bool _redirected = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(deviceConfigProvider);

    if (!_redirected && config.isLoaded) {
      _redirected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        if (config.hasValidConfig) {
          ref.read(screenProfileProvider.notifier).state = config.toScreenProfile();
          context.go('/prepare');
          return;
        }

        context.go('/config');
      });
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Widget _buildInvalidArgumentPage(
  BuildContext context, {
  required String title,
  required String message,
  required String backPath,
  required String buttonLabel,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      centerTitle: true,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_outlined, size: 56, color: Colors.orange),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(backPath),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    ),
  );
}
