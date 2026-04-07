import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vision/domain/vision_enums.dart';
import '../../app/providers/test_config_provider.dart';

class TestPreparePage extends ConsumerStatefulWidget {
  const TestPreparePage({super.key});

  @override
  ConsumerState<TestPreparePage> createState() => _TestPreparePageState();
}

class _TestPreparePageState extends ConsumerState<TestPreparePage> {
  final _distanceController = TextEditingController(text: '400');

  @override
  void initState() {
    super.initState();
    _distanceController.addListener(_onDistanceChanged);
  }

  @override
  void dispose() {
    _distanceController.removeListener(_onDistanceChanged);
    _distanceController.dispose();
    super.dispose();
  }

  void _onDistanceChanged() {
    final value = double.tryParse(_distanceController.text);
    if (value != null) {
      ref.read(testConfigProvider.notifier).setTestDistance(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(testConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('测试准备'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfigSection(theme, config),
            const SizedBox(height: 24),
            _buildInstructionsSection(theme),
            const SizedBox(height: 32),
            _buildStartButton(context, config),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection(ThemeData theme, TestConfigState config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '测试配置',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDistanceInput(theme, config),
            const SizedBox(height: 16),
            _buildEyeSideSelector(theme, config),
            const SizedBox(height: 16),
            _buildTestModeSelector(theme, config),
            const SizedBox(height: 16),
            _buildPixelThresholdSelector(theme, config),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceInput(ThemeData theme, TestConfigState config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '测试距离 (mm)',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _distanceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '输入测试距离',
            suffixText: 'mm',
            errorText: config.isValid ? null : '距离应在 200-1000 mm 之间',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        Text(
          '建议距离: 400 mm (40厘米)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEyeSideSelector(ThemeData theme, TestConfigState config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '测试眼别',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<EyeSide>(
          segments: const [
            ButtonSegment(
              value: EyeSide.left,
              label: Text('左眼'),
              icon: Icon(Icons.visibility),
            ),
            ButtonSegment(
              value: EyeSide.right,
              label: Text('右眼'),
              icon: Icon(Icons.visibility),
            ),
            ButtonSegment(
              value: EyeSide.both,
              label: Text('双眼'),
              icon: Icon(Icons.remove_red_eye),
            ),
          ],
          selected: {config.eyeSide},
          onSelectionChanged: (Set<EyeSide> selection) {
            ref.read(testConfigProvider.notifier).setEyeSide(selection.first);
          },
        ),
      ],
    );
  }

  Widget _buildTestModeSelector(ThemeData theme, TestConfigState config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '测试模式',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        RadioListTile<TestMode>(
          title: const Text('孤立模式'),
          subtitle: const Text('单个视标显示，适合初学者'),
          value: TestMode.isolated,
          groupValue: config.testMode,
          onChanged: (TestMode? value) {
            if (value != null) {
              ref.read(testConfigProvider.notifier).setTestMode(value);
            }
          },
        ),
        RadioListTile<TestMode>(
          title: const Text('拥挤模式'),
          subtitle: const Text('多视标显示，更接近临床测试'),
          value: TestMode.crowded,
          groupValue: config.testMode,
          onChanged: (TestMode? value) {
            if (value != null) {
              ref.read(testConfigProvider.notifier).setTestMode(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildPixelThresholdSelector(ThemeData theme, TestConfigState config) {
    final isOnePixelMode = config.minCriticalDetailPx <= 1.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '像素限制阈值',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<double>(
          segments: const [
            ButtonSegment<double>(
              value: 2.0,
              label: Text('2px（推荐）'),
            ),
            ButtonSegment<double>(
              value: 1.0,
              label: Text('1px（激进）'),
            ),
          ],
          selected: {config.minCriticalDetailPx <= 1.0 ? 1.0 : 2.0},
          onSelectionChanged: (Set<double> selection) {
            ref
                .read(testConfigProvider.notifier)
                .setMinCriticalDetailPx(selection.first);
          },
        ),
        const SizedBox(height: 6),
        Text(
          isOnePixelMode
              ? '当前为 1px：会更接近硬件极限，最小视标更小。'
              : '当前为 2px：更保守，通常更符合可辨识体验。',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(ThemeData theme) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  '测试前说明',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              Icons.pan_tool,
              '遮眼方式',
              '测试单眼时，请用遮眼板或手掌完全遮盖非测试眼，避免压迫眼球。',
            ),
            const SizedBox(height: 8),
            _buildInstructionItem(
              Icons.straighten,
              '测试距离',
              '请保持与屏幕的测试距离，可使用卷尺测量或估算。',
            ),
            const SizedBox(height: 8),
            _buildInstructionItem(
              Icons.light_mode,
              '环境光建议',
              '确保测试环境光线充足、均匀，避免屏幕反光或强光直射眼睛。',
            ),
            const SizedBox(height: 8),
            _buildInstructionItem(
              Icons.assessment,
              '结果参考性质',
              '本测试结果仅供参考，不能替代专业眼科检查。如有视力问题，请及时就医。',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, TestConfigState config) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: config.isValid ? () => _startTest(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '开始测试',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _startTest(BuildContext context) {
    final testConfig = ref.read(testConfigProvider).toTestConfig();
    context.go('/test', extra: testConfig);
  }
}
