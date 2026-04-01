import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      builder: (context, state) => const TestRunPage(),
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
