import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'platform/platform_display.dart';

final platformDisplayServiceProvider = Provider<PlatformDisplayService>((ref) {
  final service = createPlatformDisplayService();
  ref.onDispose(() => service.dispose());
  return service;
});

final displayInfoProvider = FutureProvider<DisplayInfo>((ref) async {
  final service = ref.watch(platformDisplayServiceProvider);
  await service.initialize();
  return service.displayInfo;
});

final devicePixelRatioProvider = Provider<double>((ref) {
  final service = ref.watch(platformDisplayServiceProvider);
  return service.devicePixelRatio;
});

final systemScaleFactorProvider = Provider<double>((ref) {
  final service = ref.watch(platformDisplayServiceProvider);
  return service.systemScaleFactor;
});

final isHighDpiProvider = Provider<bool>((ref) {
  final service = ref.watch(platformDisplayServiceProvider);
  return service.isHighDpi;
});
