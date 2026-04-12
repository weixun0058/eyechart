import 'package:eyechart/app/platform/device_defaults_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('estimatePhysicalScreenSize', () {
    test('按分辨率比例和对角线推导宽高毫米值', () {
      final estimatedSize = estimatePhysicalScreenSize(
        widthPx: 1080,
        heightPx: 2400,
        diagonalInches: 6.7,
      );

      expect(estimatedSize.widthMm, closeTo(69.84, 0.02));
      expect(estimatedSize.heightMm, closeTo(155.19, 0.02));
    });

    test('缺少有效输入时返回零尺寸', () {
      final estimatedSize = estimatePhysicalScreenSize(
        widthPx: 0,
        heightPx: 2400,
        diagonalInches: 6.7,
      );

      expect(estimatedSize.widthMm, 0);
      expect(estimatedSize.heightMm, 0);
    });
  });
}
