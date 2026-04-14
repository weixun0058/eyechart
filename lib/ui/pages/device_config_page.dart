import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vision/domain/vision_models.dart';
import '../../app/providers/app_providers.dart';
import '../../app/providers/device_config_provider.dart';

class DeviceConfigPage extends ConsumerStatefulWidget {
  const DeviceConfigPage({super.key});

  @override
  ConsumerState<DeviceConfigPage> createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends ConsumerState<DeviceConfigPage> {
  static const double _referenceCardWidthMm = 85.60;
  static const double _referenceCardHeightMm = 53.98;

  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  bool _deviceNameEdited = false;
  bool _widthEdited = false;
  bool _heightEdited = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePage();
    });
  }

  Future<void> _initializePage() async {
    _initializeFromState();
    await _applyDetectedDefaults();
  }

  void _initializeFromState() {
    final config = ref.read(deviceConfigProvider);
    _deviceNameController.text = config.deviceName;
    _widthController.text =
        config.screenWidthMm > 0 ? config.screenWidthMm.toString() : '';
    _heightController.text =
        config.screenHeightMm > 0 ? config.screenHeightMm.toString() : '';
  }

  Future<void> _applyDetectedDefaults() async {
    final notifier = ref.read(deviceConfigProvider.notifier);
    final (widthPx, heightPx, pixelRatio) = _detectScreenResolution();
    if (widthPx <= 0 || heightPx <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _applyDetectedDefaults();
        }
      });
      return;
    }

    notifier.setScreenResolution(
      widthPx: widthPx,
      heightPx: heightPx,
      pixelRatio: pixelRatio,
    );

    final deviceInfo = await ref
        .read(deviceDefaultsServiceProvider)
        .queryDeviceInfo();

    notifier.applyDetectedDefaults(
      detectedDeviceName: deviceInfo.deviceName,
      detectedDiagonalInches: deviceInfo.screenDiagonalInches,
      widthPx: widthPx,
      heightPx: heightPx,
      pixelRatio: pixelRatio,
    );

    if (!mounted) {
      return;
    }

    final config = ref.read(deviceConfigProvider);
    _syncControllersFromState(config);
  }

  void _syncControllersFromState(DeviceConfigState config) {
    if (!_deviceNameEdited &&
        _deviceNameController.text.trim().isEmpty &&
        config.deviceName.trim().isNotEmpty) {
      _deviceNameController.text = config.deviceName;
    }

    if (!_widthEdited &&
        _widthController.text.trim().isEmpty &&
        config.screenWidthMm > 0) {
      _widthController.text = config.screenWidthMm.toStringAsFixed(2);
    }

    if (!_heightEdited &&
        _heightController.text.trim().isEmpty &&
        config.screenHeightMm > 0) {
      _heightController.text = config.screenHeightMm.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final (widthPx, heightPx, pixelRatio) = _detectScreenResolution();
    if (widthPx <= 0 || heightPx <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('无法读取屏幕分辨率，请稍后重试或重启应用'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    final config = ref.read(deviceConfigProvider);
    final notifier = ref.read(deviceConfigProvider.notifier);

    final success = await notifier.saveConfig(
      deviceName: _deviceNameController.text.trim(),
      screenWidthMm: double.parse(_widthController.text),
      screenHeightMm: double.parse(_heightController.text),
      screenWidthPx: widthPx,
      screenHeightPx: heightPx,
      devicePixelRatio: pixelRatio,
    );

    if (mounted) {
      if (success) {
        final now = DateTime.now();
        final screenProfile = ScreenProfile(
          id: 'screen-${now.millisecondsSinceEpoch}',
          deviceName: _deviceNameController.text.trim().isEmpty
              ? '当前设备'
              : _deviceNameController.text.trim(),
          screenWidthMm: double.parse(_widthController.text),
          screenHeightMm: double.parse(_heightController.text),
          screenWidthPx: widthPx,
          screenHeightPx: heightPx,
          devicePixelRatio: pixelRatio,
          isDpiAware: true,
          createdAt: now,
          updatedAt: now,
        );
        ref.read(screenProfileProvider.notifier).state = screenProfile;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('设备配置已保存'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/prepare');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(config.errorMessage ?? '保存失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  (int, int, double) _detectScreenResolution() {
    final mediaQuery = MediaQuery.of(context);
    final view = View.of(context);
    final viewWidthPx = view.physicalSize.width.round();
    final viewHeightPx = view.physicalSize.height.round();
    if (viewWidthPx > 0 && viewHeightPx > 0) {
      return (viewWidthPx, viewHeightPx, view.devicePixelRatio);
    }

    final dispatcherView = WidgetsBinding.instance.platformDispatcher.views.first;
    final dispatcherWidthPx = dispatcherView.physicalSize.width.round();
    final dispatcherHeightPx = dispatcherView.physicalSize.height.round();
    if (dispatcherWidthPx > 0 && dispatcherHeightPx > 0) {
      return (
        dispatcherWidthPx,
        dispatcherHeightPx,
        dispatcherView.devicePixelRatio,
      );
    }

    final fallbackWidthPx =
        (mediaQuery.size.width * mediaQuery.devicePixelRatio).round();
    final fallbackHeightPx =
        (mediaQuery.size.height * mediaQuery.devicePixelRatio).round();
    return (fallbackWidthPx, fallbackHeightPx, mediaQuery.devicePixelRatio);
  }

  Future<void> _openCardCalibrationSheet() async {
    final (screenWidthPx, screenHeightPx, devicePixelRatio) =
        _detectScreenResolution();
    if (screenWidthPx <= 0 || screenHeightPx <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('当前无法读取屏幕分辨率，暂时不能进行信用卡校准'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final result = await Navigator.of(context).push<_CardCalibrationResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _CardCalibrationSheet(
          screenWidthPx: screenWidthPx,
          screenHeightPx: screenHeightPx,
          devicePixelRatio: devicePixelRatio,
          referenceCardWidthMm: _referenceCardWidthMm,
          referenceCardHeightMm: _referenceCardHeightMm,
          initialCardWidthLogicalPx: _buildInitialCardWidthLogicalPx(
            devicePixelRatio: devicePixelRatio,
          ),
        ),
      ),
    );

    if (result == null) {
      return;
    }

    _applyCalibrationResult(result);
  }

  /// 根据当前估算尺寸，给校准面板一个更接近真实尺寸的初始矩形。
  double _buildInitialCardWidthLogicalPx({
    required double devicePixelRatio,
  }) {
    final config = ref.read(deviceConfigProvider);
    final estimatedCardWidthPhysicalPx =
        config.screenWidthMm > 0 && config.screenWidthPx > 0
            ? config.screenWidthPx * _referenceCardHeightMm / config.screenWidthMm
            : 0.0;
    final estimatedCardWidthLogicalPx = estimatedCardWidthPhysicalPx > 0
        ? estimatedCardWidthPhysicalPx / devicePixelRatio
        : MediaQuery.of(context).size.width * 0.62;
    return estimatedCardWidthLogicalPx.clamp(140.0, 420.0);
  }

  void _applyCalibrationResult(_CardCalibrationResult result) {
    final notifier = ref.read(deviceConfigProvider.notifier);
    final widthText = result.screenWidthMm.toStringAsFixed(2);
    final heightText = result.screenHeightMm.toStringAsFixed(2);

    setState(() {
      _widthEdited = true;
      _heightEdited = true;
      _widthController.text = widthText;
      _heightController.text = heightText;
    });

    notifier.updateScreenWidthMm(result.screenWidthMm);
    notifier.updateScreenHeightMm(result.screenHeightMm);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '已应用信用卡校准：约 ${result.estimatedPpi.toStringAsFixed(1)} PPI',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(deviceConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设备配置'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('设备信息'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deviceNameController,
                onChanged: (value) {
                  _deviceNameEdited = true;
                  ref.read(deviceConfigProvider.notifier).updateDeviceName(value);
                },
                decoration: const InputDecoration(
                  labelText: '设备名称',
                  hintText: '例如：iPhone 15 Pro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('屏幕物理尺寸'),
              const SizedBox(height: 12),
              _buildCalibrationCard(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      onChanged: (value) {
                        _widthEdited = true;
                        final width = double.tryParse(value);
                        if (width != null && width > 0) {
                          ref
                              .read(deviceConfigProvider.notifier)
                              .updateScreenWidthMm(width);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: '宽度 (mm)',
                        hintText: '例如：71.5',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入屏幕宽度';
                        }
                        final width = double.tryParse(value);
                        if (width == null || width <= 0) {
                          return '请输入有效的宽度';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      onChanged: (value) {
                        _heightEdited = true;
                        final height = double.tryParse(value);
                        if (height != null && height > 0) {
                          ref
                              .read(deviceConfigProvider.notifier)
                              .updateScreenHeightMm(height);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: '高度 (mm)',
                        hintText: '例如：147.0',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入屏幕高度';
                        }
                        final height = double.tryParse(value);
                        if (height == null || height <= 0) {
                          return '请输入有效的高度';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('屏幕分辨率（只读）'),
              const SizedBox(height: 12),
              _buildReadOnlyField(
                label: '分辨率',
                value:
                    '${config.screenWidthPx} × ${config.screenHeightPx} 像素',
              ),
              const SizedBox(height: 8),
              _buildReadOnlyField(
                label: '设备像素比',
                value: config.devicePixelRatio.toStringAsFixed(2),
              ),
              const SizedBox(height: 8),
              _buildReadOnlyField(
                label: '检测对角线',
                value: config.detectedDiagonalInches > 0
                    ? '${config.detectedDiagonalInches.toStringAsFixed(2)} 英寸'
                    : '未检测到',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('计算结果'),
              const SizedBox(height: 12),
              _buildCalculatedResults(config),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: config.isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: config.isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '保存配置',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              if (config.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          config.errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCalibrationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '信用卡校准',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '如果自动识别不准，请拿一张银行卡或身份证竖着贴在屏幕上校准。进入后页面只保留卡片外框和缩小、重置、放大、应用四个按钮。',
            style: TextStyle(
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: _openCardCalibrationSheet,
              icon: const Icon(Icons.straighten),
              label: const Text('开始信用卡校准'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatedResults(DeviceConfigState config) {
    final hasData = config.screenWidthPx > 0 && config.screenHeightPx > 0;
    final pixelWidth = hasData ? config.pixelWidthMm : 0.0;
    final pixelHeight = hasData ? config.pixelHeightMm : 0.0;
    final estimatedPpi = hasData ? _calculateEstimatedPpi(config) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          _buildResultRow(
            '像素物理宽度',
            hasData ? '${pixelWidth.toStringAsFixed(4)} mm' : '--',
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            '像素物理高度',
            hasData ? '${pixelHeight.toStringAsFixed(4)} mm' : '--',
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            '估算 PPI',
            hasData ? estimatedPpi.toStringAsFixed(1) : '--',
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            '配置状态',
            config.hasValidConfig ? '已配置' : '未配置',
            valueColor: config.hasValidConfig ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  double _calculateEstimatedPpi(DeviceConfigState config) {
    final widthPpi = config.screenWidthMm > 0
        ? config.screenWidthPx * 25.4 / config.screenWidthMm
        : 0.0;
    final heightPpi = config.screenHeightMm > 0
        ? config.screenHeightPx * 25.4 / config.screenHeightMm
        : 0.0;

    if (widthPpi <= 0) {
      return heightPpi;
    }

    if (heightPpi <= 0) {
      return widthPpi;
    }

    return (widthPpi + heightPpi) / 2;
  }

  Widget _buildResultRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _CardCalibrationResult {
  final double screenWidthMm;
  final double screenHeightMm;
  final double estimatedPpi;
  final double calibrationScale;

  const _CardCalibrationResult({
    required this.screenWidthMm,
    required this.screenHeightMm,
    required this.estimatedPpi,
    required this.calibrationScale,
  });
}

class _CardCalibrationSheet extends StatefulWidget {
  final int screenWidthPx;
  final int screenHeightPx;
  final double devicePixelRatio;
  final double referenceCardWidthMm;
  final double referenceCardHeightMm;
  final double initialCardWidthLogicalPx;

  const _CardCalibrationSheet({
    required this.screenWidthPx,
    required this.screenHeightPx,
    required this.devicePixelRatio,
    required this.referenceCardWidthMm,
    required this.referenceCardHeightMm,
    required this.initialCardWidthLogicalPx,
  });

  @override
  State<_CardCalibrationSheet> createState() => _CardCalibrationSheetState();
}

class _CardCalibrationSheetState extends State<_CardCalibrationSheet> {
  double _calibrationScale = 1.0;

  static const double _minCalibrationScale = 0.9;
  static const double _maxCalibrationScale = 1.1;
  static const double _calibrationStep = 0.005;

  /// 竖放卡片时，屏幕横向对应卡片短边。
  double get _displayWidthMm => widget.referenceCardHeightMm;

  /// 竖放卡片时，屏幕纵向对应卡片长边。
  double get _displayHeightMm => widget.referenceCardWidthMm;

  /// 返回基于系统估算值绘制出的初始卡片宽度。
  double get _baseCardWidthLogicalPx => widget.initialCardWidthLogicalPx;

  /// 返回应用微调系数后的当前卡片宽度。
  double get _cardWidthLogicalPx => _baseCardWidthLogicalPx * _calibrationScale;

  double get _cardAspectRatio => _displayWidthMm / _displayHeightMm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildCalibrationPreview(),
            ),
            _buildCalibrationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationPreview() {
    final cardWidthLogicalPx = _cardWidthLogicalPx;
    final cardHeightLogicalPx = cardWidthLogicalPx / _cardAspectRatio;
    const scalePadding = 14.0;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: cardWidthLogicalPx + scalePadding * 2,
        height: cardHeightLogicalPx + scalePadding * 2,
        child: CustomPaint(
          painter: _CalibrationScalePainter(
            scalePadding: scalePadding,
            cardWidthLogicalPx: cardWidthLogicalPx,
            cardHeightLogicalPx: cardHeightLogicalPx,
            widthMm: _displayWidthMm,
            heightMm: _displayHeightMm,
          ),
        ),
      ),
    );
  }

  /// 构建用于小范围微调的加减按钮和状态显示。
  Widget _buildCalibrationControls() {
    final canDecrease = _calibrationScale > _minCalibrationScale;
    final canIncrease = _calibrationScale < _maxCalibrationScale;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: canDecrease ? _decreaseCalibration : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade600),
              ),
              child: const Text('缩小'),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: OutlinedButton(
              onPressed: _resetCalibration,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade600),
              ),
              child: const Text('重置'),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: OutlinedButton(
              onPressed: canIncrease ? _increaseCalibration : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade600),
              ),
              child: const Text('放大'),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop(_buildCalibrationResult());
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('应用'),
            ),
          ),
        ],
      ),
    );
  }

  /// 将卡片框缩小一个微调步进。
  void _decreaseCalibration() {
    setState(() {
      _calibrationScale =
          (_calibrationScale - _calibrationStep).clamp(
            _minCalibrationScale,
            _maxCalibrationScale,
          );
    });
  }

  /// 将卡片框放大一个微调步进。
  void _increaseCalibration() {
    setState(() {
      _calibrationScale =
          (_calibrationScale + _calibrationStep).clamp(
            _minCalibrationScale,
            _maxCalibrationScale,
          );
    });
  }

  /// 恢复到系统估算出的初始卡片尺寸。
  void _resetCalibration() {
    setState(() {
      _calibrationScale = 1.0;
    });
  }

  /// 根据当前卡片框大小，反推出更新后的屏幕物理尺寸。
  _CardCalibrationResult _buildCalibrationResult() {
    final cardWidthPhysicalPx = _cardWidthLogicalPx * widget.devicePixelRatio;
    final cardHeightPhysicalPx =
        (_cardWidthLogicalPx / _cardAspectRatio) * widget.devicePixelRatio;
    final widthMmPerPx = _displayWidthMm / cardWidthPhysicalPx;
    final heightMmPerPx = _displayHeightMm / cardHeightPhysicalPx;
    final screenWidthMm = widget.screenWidthPx * widthMmPerPx;
    final screenHeightMm = widget.screenHeightPx * heightMmPerPx;
    final widthPpi = 25.4 / widthMmPerPx;
    final heightPpi = 25.4 / heightMmPerPx;

    return _CardCalibrationResult(
      screenWidthMm: screenWidthMm,
      screenHeightMm: screenHeightMm,
      estimatedPpi: (widthPpi + heightPpi) / 2,
      calibrationScale: _calibrationScale,
    );
  }
}

class _CalibrationScalePainter extends CustomPainter {
  final double scalePadding;
  final double cardWidthLogicalPx;
  final double cardHeightLogicalPx;
  final double widthMm;
  final double heightMm;

  const _CalibrationScalePainter({
    required this.scalePadding,
    required this.cardWidthLogicalPx,
    required this.cardHeightLogicalPx,
    required this.widthMm,
    required this.heightMm,
  });

  /// 绘制白色直角标尺区，以及外侧毫米刻度线。
  @override
  void paint(Canvas canvas, Size size) {
    final cardRect = Rect.fromLTWH(
      scalePadding,
      scalePadding,
      cardWidthLogicalPx,
      cardHeightLogicalPx,
    );
    final cardPaint = Paint()..color = Colors.white;

    canvas.drawRect(cardRect, cardPaint);
    _paintHorizontalTicks(
      canvas: canvas,
      startX: cardRect.left,
      y: cardRect.top,
      mmLength: widthMm,
      pxLength: cardRect.width,
      direction: AxisDirection.up,
    );
    _paintHorizontalTicks(
      canvas: canvas,
      startX: cardRect.left,
      y: cardRect.bottom,
      mmLength: widthMm,
      pxLength: cardRect.width,
      direction: AxisDirection.down,
    );
    _paintVerticalTicks(
      canvas: canvas,
      x: cardRect.left,
      startY: cardRect.top,
      mmLength: heightMm,
      pxLength: cardRect.height,
      direction: AxisDirection.left,
    );
    _paintVerticalTicks(
      canvas: canvas,
      x: cardRect.right,
      startY: cardRect.top,
      mmLength: heightMm,
      pxLength: cardRect.height,
      direction: AxisDirection.right,
    );
  }

  /// 沿水平边绘制毫米刻度，10mm/5mm 使用更长的细线。
  void _paintHorizontalTicks({
    required Canvas canvas,
    required double startX,
    required double y,
    required double mmLength,
    required double pxLength,
    required AxisDirection direction,
  }) {
    final pxPerMm = pxLength / mmLength;
    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.square;
    final tickCount = mmLength.floor();

    for (var mm = 0; mm <= tickCount; mm += 1) {
      final x = startX + pxPerMm * mm;
      final tickLength = _tickLength(mm);
      final y2 = direction == AxisDirection.up ? y - tickLength : y + tickLength;
      canvas.drawLine(Offset(x, y), Offset(x, y2), tickPaint);
    }
  }

  /// 沿垂直边绘制毫米刻度，保持线条细而清楚。
  void _paintVerticalTicks({
    required Canvas canvas,
    required double x,
    required double startY,
    required double mmLength,
    required double pxLength,
    required AxisDirection direction,
  }) {
    final pxPerMm = pxLength / mmLength;
    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.square;
    final tickCount = mmLength.floor();

    for (var mm = 0; mm <= tickCount; mm += 1) {
      final y = startY + pxPerMm * mm;
      final tickLength = _tickLength(mm);
      final x2 = direction == AxisDirection.left ? x - tickLength : x + tickLength;
      canvas.drawLine(Offset(x, y), Offset(x2, y), tickPaint);
    }
  }

  /// 为 1mm、5mm、10mm 刻度分配不同长度，便于快速判断。
  double _tickLength(int mm) {
    if (mm % 10 == 0) {
      return 10;
    }
    if (mm % 5 == 0) {
      return 7;
    }
    return 4;
  }

  @override
  bool shouldRepaint(covariant _CalibrationScalePainter oldDelegate) {
    return scalePadding != oldDelegate.scalePadding ||
        cardWidthLogicalPx != oldDelegate.cardWidthLogicalPx ||
        cardHeightLogicalPx != oldDelegate.cardHeightLogicalPx ||
        widthMm != oldDelegate.widthMm ||
        heightMm != oldDelegate.heightMm;
  }
}
