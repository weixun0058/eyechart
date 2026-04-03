import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/test_session_controller.dart';
import '../../vision/domain/vision_enums.dart';
import '../../vision/domain/vision_models.dart';
import '../widgets/direction_pad.dart';
import '../widgets/e_optotype_view.dart';
import '../../app/providers/app_providers.dart';

class TestRunPage extends ConsumerStatefulWidget {
  final TestConfig config;

  const TestRunPage({
    super.key,
    required this.config,
  });

  @override
  ConsumerState<TestRunPage> createState() => _TestRunPageState();
}

class _TestRunPageState extends ConsumerState<TestRunPage> {
  final FocusNode _focusNode = FocusNode();
  bool _showFeedback = false;
  bool _isCorrect = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeTest();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeTest() {
    final screenProfile = ref.read(screenProfileProvider);
    if (screenProfile == null) {
      _showErrorAndGoBack('屏幕配置不存在，请先完成设备配置');
      return;
    }

    final controller = ref.read(testSessionControllerProvider.notifier);
    controller.startSession(
      config: widget.config,
      screenProfile: screenProfile,
    );
  }

  void _showErrorAndGoBack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    context.go('/prepare');
  }

  void _handleDirectionInput(OptotypeDirection direction) {
    if (_isProcessing) return;

    final state = ref.read(testSessionControllerProvider);
    if (state == null || state.isFinished) return;

    setState(() {
      _isProcessing = true;
    });

    final controller = ref.read(testSessionControllerProvider.notifier);
    final result = controller.submitAnswer(direction);

    setState(() {
      _isCorrect = result == AnswerResult.correct ||
          result == AnswerResult.correctFinished;
      _showFeedback = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () async {
      if (mounted) {
        setState(() {
          _showFeedback = false;
          _isProcessing = false;
        });

        if (result == AnswerResult.correctFinished ||
            result == AnswerResult.wrongFinished) {
          await _handleSessionFinished();
        }
      }
    });
  }

  Future<void> _handleSessionFinished() async {
    final sessionState = ref.read(testSessionControllerProvider);
    if (sessionState?.endReason == SessionEndReason.bestAcuityReached) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('测试完成'),
          content: const Text('已达到最佳视力上限（2.0），本次测试将结束。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
    if (!mounted) return;
    _navigateToResult();
  }

  void _navigateToResult() {
    final controller = ref.read(testSessionControllerProvider.notifier);
    final result = controller.buildResult();
    context.go('/result', extra: result);
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    OptotypeDirection? direction;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      direction = OptotypeDirection.up;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      direction = OptotypeDirection.down;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      direction = OptotypeDirection.left;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      direction = OptotypeDirection.right;
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _confirmExit();
      return;
    }

    if (direction != null) {
      _handleDirectionInput(direction);
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要中止当前测试吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('继续测试'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(testSessionControllerProvider.notifier).endSession();
              context.go('/prepare');
            },
            child: const Text('退出测试'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(testSessionControllerProvider);
    final theme = Theme.of(context);

    if (sessionState == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('测试执行')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: _showFeedback
            ? (_isCorrect ? Colors.green.shade100 : Colors.red.shade100)
            : Colors.white,
        appBar: AppBar(
          title: const Text('视力测试'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _confirmExit,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildStatusBar(sessionState, theme),
              Expanded(
                child: _buildOptotypeArea(sessionState, theme),
              ),
              _buildControlArea(sessionState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(TestSessionState state, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoChip(
            icon: Icons.format_list_numbered,
            label: '${state.currentQuestionIndex + 1}/${state.config.maxQuestionCount}',
            theme: theme,
          ),
          _buildInfoChip(
            icon: Icons.visibility,
            label: 'logMAR ${state.currentLogMar.toStringAsFixed(2)}',
            theme: theme,
          ),
          _buildInfoChip(
            icon: Icons.remove_red_eye,
            label: state.currentDecimalAcuity.toStringAsFixed(2),
            theme: theme,
          ),
          _buildInfoChip(
            icon: Icons.swap_vert,
            label: '${state.staircaseState.reversals.length} 反转',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOptotypeArea(TestSessionState state, ThemeData theme) {
    final renderMetrics = state.currentRenderMetrics;
    if (renderMetrics == null) {
      return const Center(child: Text('渲染参数错误'));
    }

    final optotypeSize = renderMetrics.optotypeWidthPx;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: EOptotypeView(
          size: optotypeSize.clamp(1.0, 300.0),
          direction: state.currentDirection,
          color: _showFeedback
              ? (_isCorrect ? Colors.green : Colors.red)
              : Colors.black,
        ),
      ),
    );
  }

  Widget _buildControlArea(TestSessionState state) {
    final inputMode = state.config.inputMode;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '请选择 E 字开口方向',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (inputMode == InputMode.touchButtons ||
              inputMode == InputMode.keyboard) ...[
            DirectionPad(
              onDirectionSelected: _handleDirectionInput,
              enabled: !_isProcessing,
              buttonSize: 56,
            ),
          ],
          if (inputMode == InputMode.keyboard) ...[
            const SizedBox(height: 16),
            Text(
              '或使用键盘方向键',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
          if (inputMode == InputMode.swipe) ...[
            const Text('请在屏幕上滑动选择方向'),
          ],
          const SizedBox(height: 24),
          _buildPixelWarning(state),
        ],
      ),
    );
  }

  Widget _buildPixelWarning(TestSessionState state) {
    if (!state.pixelLimitEncountered) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Text(
            '已达到屏幕像素限制',
            style: TextStyle(color: Colors.orange.shade900),
          ),
        ],
      ),
    );
  }
}
