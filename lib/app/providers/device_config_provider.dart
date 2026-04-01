import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../vision/domain/vision_models.dart';

class DeviceConfigState {
  final String deviceName;
  final double screenWidthMm;
  final double screenHeightMm;
  final int screenWidthPx;
  final int screenHeightPx;
  final double devicePixelRatio;
  final bool isSaving;
  final String? errorMessage;

  const DeviceConfigState({
    this.deviceName = '',
    this.screenWidthMm = 0.0,
    this.screenHeightMm = 0.0,
    this.screenWidthPx = 0,
    this.screenHeightPx = 0,
    this.devicePixelRatio = 1.0,
    this.isSaving = false,
    this.errorMessage,
  });

  double get pixelWidthMm =>
      screenWidthPx > 0 ? screenWidthMm / screenWidthPx : 0.0;

  double get pixelHeightMm =>
      screenHeightPx > 0 ? screenHeightMm / screenHeightPx : 0.0;

  bool get hasValidConfig =>
      screenWidthMm > 0 && screenHeightMm > 0 && screenWidthPx > 0;

  DeviceConfigState copyWith({
    String? deviceName,
    double? screenWidthMm,
    double? screenHeightMm,
    int? screenWidthPx,
    int? screenHeightPx,
    double? devicePixelRatio,
    bool? isSaving,
    String? errorMessage,
  }) {
    return DeviceConfigState(
      deviceName: deviceName ?? this.deviceName,
      screenWidthMm: screenWidthMm ?? this.screenWidthMm,
      screenHeightMm: screenHeightMm ?? this.screenHeightMm,
      screenWidthPx: screenWidthPx ?? this.screenWidthPx,
      screenHeightPx: screenHeightPx ?? this.screenHeightPx,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }

  ScreenProfile toScreenProfile() {
    final now = DateTime.now();
    return ScreenProfile(
      id: 'device_${now.millisecondsSinceEpoch}',
      deviceName: deviceName,
      screenWidthMm: screenWidthMm,
      screenHeightMm: screenHeightMm,
      screenWidthPx: screenWidthPx,
      screenHeightPx: screenHeightPx,
      devicePixelRatio: devicePixelRatio,
      isDpiAware: true,
      createdAt: now,
      updatedAt: now,
    );
  }
}

class DeviceConfigNotifier extends StateNotifier<DeviceConfigState> {
  static const String _keyDeviceName = 'device_config_name';
  static const String _keyScreenWidthMm = 'device_config_width_mm';
  static const String _keyScreenHeightMm = 'device_config_height_mm';
  static const String _keyScreenWidthPx = 'device_config_width_px';
  static const String _keyScreenHeightPx = 'device_config_height_px';
  static const String _keyDevicePixelRatio = 'device_config_pixel_ratio';

  DeviceConfigNotifier() : super(const DeviceConfigState()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = state.copyWith(
        deviceName: prefs.getString(_keyDeviceName) ?? '',
        screenWidthMm: prefs.getDouble(_keyScreenWidthMm) ?? 0.0,
        screenHeightMm: prefs.getDouble(_keyScreenHeightMm) ?? 0.0,
        screenWidthPx: prefs.getInt(_keyScreenWidthPx) ?? 0,
        screenHeightPx: prefs.getInt(_keyScreenHeightPx) ?? 0,
        devicePixelRatio: prefs.getDouble(_keyDevicePixelRatio) ?? 1.0,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: '加载配置失败: $e');
    }
  }

  Future<bool> saveConfig({
    required String deviceName,
    required double screenWidthMm,
    required double screenHeightMm,
    required int screenWidthPx,
    required int screenHeightPx,
    required double devicePixelRatio,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyDeviceName, deviceName);
      await prefs.setDouble(_keyScreenWidthMm, screenWidthMm);
      await prefs.setDouble(_keyScreenHeightMm, screenHeightMm);
      await prefs.setInt(_keyScreenWidthPx, screenWidthPx);
      await prefs.setInt(_keyScreenHeightPx, screenHeightPx);
      await prefs.setDouble(_keyDevicePixelRatio, devicePixelRatio);

      state = state.copyWith(
        deviceName: deviceName,
        screenWidthMm: screenWidthMm,
        screenHeightMm: screenHeightMm,
        screenWidthPx: screenWidthPx,
        screenHeightPx: screenHeightPx,
        devicePixelRatio: devicePixelRatio,
        isSaving: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: '保存配置失败: $e',
      );
      return false;
    }
  }

  void updateScreenWidthMm(double width) {
    state = state.copyWith(screenWidthMm: width);
  }

  void updateScreenHeightMm(double height) {
    state = state.copyWith(screenHeightMm: height);
  }

  void updateDeviceName(String name) {
    state = state.copyWith(deviceName: name);
  }

  void setScreenResolution({
    required int widthPx,
    required int heightPx,
    required double pixelRatio,
  }) {
    state = state.copyWith(
      screenWidthPx: widthPx,
      screenHeightPx: heightPx,
      devicePixelRatio: pixelRatio,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final deviceConfigProvider =
    StateNotifierProvider<DeviceConfigNotifier, DeviceConfigState>(
  (ref) => DeviceConfigNotifier(),
);
