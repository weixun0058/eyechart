import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class DetectedDeviceInfo {
  final String deviceName;
  final double screenDiagonalInches;

  const DetectedDeviceInfo({
    required this.deviceName,
    required this.screenDiagonalInches,
  });
}

class EstimatedPhysicalScreenSize {
  final double widthMm;
  final double heightMm;

  const EstimatedPhysicalScreenSize({
    required this.widthMm,
    required this.heightMm,
  });
}

class DeviceDefaultsService {
  static const MethodChannel _channel = MethodChannel('eyechart/device_info');

  const DeviceDefaultsService();

  Future<DetectedDeviceInfo> queryDeviceInfo() async {
    if (!Platform.isAndroid) {
      return DetectedDeviceInfo(
        deviceName: _fallbackDeviceName(),
        screenDiagonalInches: 0,
      );
    }

    try {
      final result = await _channel.invokeMapMethod<String, Object?>(
        'getDeviceInfo',
      );

      return DetectedDeviceInfo(
        deviceName: _resolveDeviceName(result?['deviceName']),
        screenDiagonalInches: _parsePositiveDouble(
          result?['screenDiagonalInches'],
        ),
      );
    } on PlatformException {
      return DetectedDeviceInfo(
        deviceName: _fallbackDeviceName(),
        screenDiagonalInches: 0,
      );
    }
  }
}

EstimatedPhysicalScreenSize estimatePhysicalScreenSize({
  required int widthPx,
  required int heightPx,
  required double diagonalInches,
}) {
  if (widthPx <= 0 || heightPx <= 0 || diagonalInches <= 0) {
    return const EstimatedPhysicalScreenSize(widthMm: 0, heightMm: 0);
  }

  final diagonalMm = diagonalInches * 25.4;
  final pixelDiagonal = math.sqrt(
    widthPx * widthPx + heightPx * heightPx,
  );

  if (pixelDiagonal <= 0) {
    return const EstimatedPhysicalScreenSize(widthMm: 0, heightMm: 0);
  }

  return EstimatedPhysicalScreenSize(
    widthMm: diagonalMm * widthPx / pixelDiagonal,
    heightMm: diagonalMm * heightPx / pixelDiagonal,
  );
}

String _resolveDeviceName(Object? rawDeviceName) {
  final deviceName = (rawDeviceName as String?)?.trim();
  if (deviceName == null || deviceName.isEmpty) {
    return _fallbackDeviceName();
  }
  return deviceName;
}

double _parsePositiveDouble(Object? value) {
  if (value is num && value > 0) {
    return value.toDouble();
  }
  return 0;
}

String _fallbackDeviceName() {
  if (Platform.isAndroid) {
    return 'Android 设备';
  }
  if (Platform.isWindows) {
    return 'Windows 设备';
  }
  return '当前设备';
}
