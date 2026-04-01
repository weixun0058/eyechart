import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/device_config_provider.dart';

class DeviceConfigPage extends ConsumerStatefulWidget {
  const DeviceConfigPage({super.key});

  @override
  ConsumerState<DeviceConfigPage> createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends ConsumerState<DeviceConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromState();
      _updateScreenResolution();
    });
  }

  void _initializeFromState() {
    final config = ref.read(deviceConfigProvider);
    _deviceNameController.text = config.deviceName;
    _widthController.text =
        config.screenWidthMm > 0 ? config.screenWidthMm.toString() : '';
    _heightController.text =
        config.screenHeightMm > 0 ? config.screenHeightMm.toString() : '';
  }

  void _updateScreenResolution() {
    final mediaQuery = MediaQuery.of(context);
    final notifier = ref.read(deviceConfigProvider.notifier);
    notifier.setScreenResolution(
      widthPx: mediaQuery.size.width.toInt(),
      heightPx: mediaQuery.size.height.toInt(),
      pixelRatio: mediaQuery.devicePixelRatio,
    );
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

    final config = ref.read(deviceConfigProvider);
    final notifier = ref.read(deviceConfigProvider.notifier);

    final success = await notifier.saveConfig(
      deviceName: _deviceNameController.text.trim(),
      screenWidthMm: double.parse(_widthController.text),
      screenHeightMm: double.parse(_heightController.text),
      screenWidthPx: config.screenWidthPx,
      screenHeightPx: config.screenHeightPx,
      devicePixelRatio: config.devicePixelRatio,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('设备配置已保存'),
            backgroundColor: Colors.green,
          ),
        );
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
                decoration: const InputDecoration(
                  labelText: '设备名称',
                  hintText: '例如：iPhone 15 Pro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('屏幕物理尺寸'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
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
    final hasData = config.screenWidthPx > 0;
    final pixelWidth = hasData ? config.pixelWidthMm : 0.0;
    final pixelHeight = hasData ? config.pixelHeightMm : 0.0;

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
            '配置状态',
            config.hasValidConfig ? '已配置' : '未配置',
            valueColor: config.hasValidConfig ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
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
