import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vision/domain/vision_models.dart';
import '../../vision/domain/vision_enums.dart';
import '../../app/providers/app_providers.dart';
import '../../app/result_interpreter.dart';

class TestResultPage extends ConsumerWidget {
  const TestResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(testSessionProvider);
    final screenProfile = ref.watch(screenProfileProvider);
    final theme = Theme.of(context);

    if (session == null) {
      return _buildNoResultPage(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('测试结果'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...session.eyeResults.map(
              (result) => _buildResultCard(context, result, session, screenProfile),
            ),
            const SizedBox(height: 16),
            _buildSessionInfoCard(context, session),
            const SizedBox(height: 16),
            _buildDisclaimerCard(context),
            const SizedBox(height: 24),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试结果'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无测试结果',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '请先完成视力测试',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/prepare'),
              child: const Text('开始测试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    EyeTestResult result,
    TestSession session,
    ScreenProfile? screenProfile,
  ) {
    final theme = Theme.of(context);
    final displayData = ResultDisplayData.fromResult(result);
    final confidence = displayData.confidence;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildEyeSideHeader(context, result.eyeSide),
            const SizedBox(height: 20),
            _buildMainAcuityDisplay(context, displayData),
            const SizedBox(height: 16),
            _buildSecondaryAcuityDisplay(context, displayData),
            const Divider(height: 32),
            _buildAcuityInterpretation(context, displayData),
            const SizedBox(height: 16),
            _buildConfidenceIndicator(context, confidence),
            if (confidence.factors.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildConfidenceFactors(context, confidence),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEyeSideHeader(BuildContext context, EyeSide eyeSide) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            eyeSide == EyeSide.left
                ? Icons.visibility
                : eyeSide == EyeSide.right
                    ? Icons.visibility
                    : Icons.remove_red_eye,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            ResultInterpreter.getEyeSideLabel(eyeSide),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainAcuityDisplay(BuildContext context, ResultDisplayData displayData) {
    return Column(
      children: [
        Text(
          displayData.decimalAcuityFormatted,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 56,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '小数视力',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildSecondaryAcuityDisplay(BuildContext context, ResultDisplayData displayData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAcuityItem(
          context,
          label: '五分制',
          value: displayData.fivePointAcuityFormatted,
        ),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey[300],
        ),
        _buildAcuityItem(
          context,
          label: 'logMAR',
          value: displayData.logMarFormatted,
        ),
      ],
    );
  }

  Widget _buildAcuityItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildAcuityInterpretation(BuildContext context, ResultDisplayData displayData) {
    final color = _getInterpretationColor(displayData.result.decimalAcuity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getInterpretationIcon(displayData.result.decimalAcuity),
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            displayData.acuityInterpretation,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getInterpretationColor(double decimalAcuity) {
    if (decimalAcuity >= 1.0) {
      return Colors.green;
    } else if (decimalAcuity >= 0.5) {
      return Colors.lightGreen;
    } else if (decimalAcuity >= 0.3) {
      return Colors.orange;
    } else if (decimalAcuity >= 0.1) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  IconData _getInterpretationIcon(double decimalAcuity) {
    if (decimalAcuity >= 0.5) {
      return Icons.check_circle_outline;
    } else if (decimalAcuity >= 0.3) {
      return Icons.info_outline;
    } else {
      return Icons.warning_amber_outlined;
    }
  }

  Widget _buildConfidenceIndicator(BuildContext context, ConfidenceAssessment confidence) {
    final color = _getConfidenceColor(confidence.level);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getConfidenceIcon(confidence.level),
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  confidence.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  confidence.recommendation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.high:
        return Colors.green;
      case ConfidenceLevel.medium:
        return Colors.orange;
      case ConfidenceLevel.low:
        return Colors.red;
    }
  }

  IconData _getConfidenceIcon(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.high:
        return Icons.verified_outlined;
      case ConfidenceLevel.medium:
        return Icons.help_outline;
      case ConfidenceLevel.low:
        return Icons.error_outline;
    }
  }

  Widget _buildConfidenceFactors(BuildContext context, ConfidenceAssessment confidence) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: confidence.factors.map((factor) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            factor,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSessionInfoCard(BuildContext context, TestSession session) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '测试详情',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Icons.quiz_outlined,
              label: '题量',
              value: '${session.eyeResults.first.totalQuestions} 题',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.check_circle_outline,
              label: '正确率',
              value: ResultInterpreter.formatAccuracy(session.eyeResults.first.accuracy),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.straighten,
              label: '测试距离',
              value: ResultInterpreter.formatTestDistance(session.config.testDistanceMm),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.timer_outlined,
              label: '平均响应',
              value: ResultInterpreter.formatResponseTime(
                session.eyeResults.first.meanResponseTimeMs,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.schedule,
              label: '测试时长',
              value: ResultInterpreter.formatDuration(
                session.startedAt,
                session.finishedAt,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.flag_outlined,
              label: '结束原因',
              value: ResultInterpreter.getEndReasonLabel(session.endReason),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerCard(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.amber.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '结果参考说明',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '本测试结果仅供参考，不能替代专业眼科检查。'
                    '如有视力问题或疑虑，请及时前往正规医疗机构进行检查。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(testSessionNotifierProvider.notifier).clearSession();
              context.go('/prepare');
            },
            icon: const Icon(Icons.refresh),
            label: const Text('重新测试'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/history'),
            icon: const Icon(Icons.history),
            label: const Text('查看历史'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton.icon(
            onPressed: () {
              ref.read(testSessionNotifierProvider.notifier).clearSession();
              context.go('/');
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('返回首页'),
          ),
        ),
      ],
    );
  }
}
