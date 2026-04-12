import 'dart:io';
import 'dart:ui';

import 'windows_display_service.dart';

abstract class PlatformDisplayService {
  double get physicalWidth;
  double get physicalHeight;
  double get logicalWidth;
  double get logicalHeight;
  double get devicePixelRatio;
  double get systemScaleFactor;
  double get dpi;
  double get rawDpi;
  bool get isHighDpi;
  DisplayInfo get displayInfo;
  Future<void> initialize();
  void dispose();
}

class DisplayInfo {
  final double physicalWidthMm;
  final double physicalHeightMm;
  final double diagonalInches;
  final double refreshRate;
  final String displayName;
  final int displayIndex;

  const DisplayInfo({
    required this.physicalWidthMm,
    required this.physicalHeightMm,
    required this.diagonalInches,
    this.refreshRate = 60.0,
    this.displayName = 'Unknown',
    this.displayIndex = 0,
  });

  double get physicalWidthInches => physicalWidthMm / 25.4;
  double get physicalHeightInches => physicalHeightMm / 25.4;

  double get ppi => diagonalInches > 0 
      ? (physicalWidthMm > 0 
          ? (physicalWidthMm / 25.4) / diagonalInches * 
            ((physicalWidthMm / 25.4) * (physicalWidthMm / 25.4) + 
             (physicalHeightMm / 25.4) * (physicalHeightMm / 25.4)) /
            (diagonalInches * diagonalInches)
          : 96.0)
      : 96.0;

  @override
  String toString() {
    return 'DisplayInfo($displayName: ${diagonalInches.toStringAsFixed(1)}", '
        '${physicalWidthMm.toStringAsFixed(0)}x${physicalHeightMm.toStringAsFixed(0)}mm, '
        '${refreshRate}Hz)';
  }
}

class DefaultDisplayService implements PlatformDisplayService {
  double _physicalWidth = 0;
  double _physicalHeight = 0;
  double _devicePixelRatio = 1.0;
  bool _initialized = false;

  @override
  double get physicalWidth => _physicalWidth;

  @override
  double get physicalHeight => _physicalHeight;

  @override
  double get logicalWidth => _physicalWidth / _devicePixelRatio;

  @override
  double get logicalHeight => _physicalHeight / _devicePixelRatio;

  @override
  double get devicePixelRatio => _devicePixelRatio;

  @override
  double get systemScaleFactor => 1.0;

  @override
  double get dpi => 96.0;

  @override
  double get rawDpi => 96.0;

  @override
  bool get isHighDpi => _devicePixelRatio > 1.5;

  @override
  DisplayInfo get displayInfo => const DisplayInfo(
        physicalWidthMm: 0,
        physicalHeightMm: 0,
        diagonalInches: 0,
      );

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    final dispatcher = PlatformDispatcher.instance;
    _devicePixelRatio = dispatcher.displays.first.devicePixelRatio;
    
    final size = dispatcher.displays.first.size;
    _physicalWidth = size.width * _devicePixelRatio;
    _physicalHeight = size.height * _devicePixelRatio;

    _initialized = true;
  }

  @override
  void dispose() {
    _initialized = false;
  }
}

PlatformDisplayService createPlatformDisplayService() {
  if (Platform.isWindows) {
    try {
      return WindowsDisplayService();
    } catch (e) {
      return DefaultDisplayService();
    }
  }
  return DefaultDisplayService();
}
