import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:eyechart/vision/math/vision_math.dart';
import 'package:eyechart/vision/domain/vision_models.dart';

void main() {
  const double epsilon = 1e-9;
  const double tolerance = 0.005;

  group('MAR 与 logMAR 转换', () {
    test('marFromLogMar: logMAR 0.0 应返回 MAR 1.0', () {
      expect(VisionMath.marFromLogMar(0.0), closeTo(1.0, epsilon));
    });

    test('marFromLogMar: logMAR 1.0 应返回 MAR 10.0', () {
      expect(VisionMath.marFromLogMar(1.0), closeTo(10.0, epsilon));
    });

    test('logMarFromMar: MAR 1.0 应返回 logMAR 0.0', () {
      expect(VisionMath.logMarFromMar(1.0), closeTo(0.0, epsilon));
    });

    test('logMarFromMar: MAR 10.0 应返回 logMAR 1.0', () {
      expect(VisionMath.logMarFromMar(10.0), closeTo(1.0, epsilon));
    });

    test('logMarFromMar: 非法输入（零）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.logMarFromMar(0.0),
        throwsArgumentError,
      );
    });

    test('logMarFromMar: 非法输入（负数）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.logMarFromMar(-1.0),
        throwsArgumentError,
      );
    });
  });

  group('小数视力与 logMAR 转换', () {
    test('decimalFromLogMar: logMAR 0.0 应返回小数视力 1.0', () {
      expect(VisionMath.decimalFromLogMar(0.0), closeTo(1.0, epsilon));
    });

    test('decimalFromLogMar: logMAR 1.0 应返回小数视力 0.1', () {
      expect(VisionMath.decimalFromLogMar(1.0), closeTo(0.1, epsilon));
    });

    test('decimalFromLogMar: logMAR -0.1 应返回小数视力约 1.259', () {
      expect(VisionMath.decimalFromLogMar(-0.1), closeTo(1.259, tolerance));
    });

    test('logMarFromDecimal: 小数视力 1.0 应返回 logMAR 0.0', () {
      expect(VisionMath.logMarFromDecimal(1.0), closeTo(0.0, epsilon));
    });

    test('logMarFromDecimal: 小数视力 0.1 应返回 logMAR 1.0', () {
      expect(VisionMath.logMarFromDecimal(0.1), closeTo(1.0, epsilon));
    });

    test('logMarFromDecimal: 小数视力 0.5 应返回 logMAR 约 0.301', () {
      expect(VisionMath.logMarFromDecimal(0.5), closeTo(0.301, tolerance));
    });

    test('logMarFromDecimal: 非法输入（零）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.logMarFromDecimal(0.0),
        throwsArgumentError,
      );
    });

    test('logMarFromDecimal: 非法输入（负数）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.logMarFromDecimal(-0.5),
        throwsArgumentError,
      );
    });
  });

  group('五分制对数视力与 logMAR 转换', () {
    test('fivePointFromLogMar: logMAR 0.0 应返回五分制 5.0', () {
      expect(VisionMath.fivePointFromLogMar(0.0), closeTo(5.0, epsilon));
    });

    test('fivePointFromLogMar: logMAR 1.0 应返回五分制 4.0', () {
      expect(VisionMath.fivePointFromLogMar(1.0), closeTo(4.0, epsilon));
    });

    test('fivePointFromLogMar: logMAR 0.301 应返回五分制约 4.699', () {
      expect(VisionMath.fivePointFromLogMar(0.301), closeTo(4.699, tolerance));
    });

    test('logMarFromFivePoint: 五分制 5.0 应返回 logMAR 0.0', () {
      expect(VisionMath.logMarFromFivePoint(5.0), closeTo(0.0, epsilon));
    });

    test('logMarFromFivePoint: 五分制 4.0 应返回 logMAR 1.0', () {
      expect(VisionMath.logMarFromFivePoint(4.0), closeTo(1.0, epsilon));
    });

    test('logMarFromFivePoint: 五分制 4.7 应返回 logMAR 约 0.3', () {
      expect(VisionMath.logMarFromFivePoint(4.7), closeTo(0.3, tolerance));
    });
  });

  group('五分制对数视力与小数视力直接转换', () {
    test('fivePointFromDecimal: 小数视力 1.0 应返回五分制 5.0', () {
      expect(VisionMath.fivePointFromDecimal(1.0), closeTo(5.0, epsilon));
    });

    test('fivePointFromDecimal: 小数视力 0.5 应返回五分制约 4.7', () {
      expect(VisionMath.fivePointFromDecimal(0.5), closeTo(4.7, tolerance));
    });

    test('fivePointFromDecimal: 小数视力 0.1 应返回五分制 4.0', () {
      expect(VisionMath.fivePointFromDecimal(0.1), closeTo(4.0, epsilon));
    });

    test('decimalFromFivePoint: 五分制 5.0 应返回小数视力 1.0', () {
      expect(VisionMath.decimalFromFivePoint(5.0), closeTo(1.0, epsilon));
    });

    test('decimalFromFivePoint: 五分制 4.7 应返回小数视力约 0.5', () {
      expect(VisionMath.decimalFromFivePoint(4.7), closeTo(0.5, tolerance));
    });

    test('decimalFromFivePoint: 五分制 4.0 应返回小数视力 0.1', () {
      expect(VisionMath.decimalFromFivePoint(4.0), closeTo(0.1, epsilon));
    });

    test('fivePointFromDecimal: 非法输入（零）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.fivePointFromDecimal(0.0),
        throwsArgumentError,
      );
    });

    test('fivePointFromDecimal: 非法输入（负数）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.fivePointFromDecimal(-1.0),
        throwsArgumentError,
      );
    });
  });

  group('设计稿样例值验证', () {
    test('样例1: 小数视力 1.0 ↔ logMAR 0.0 ↔ 五分制对数视力 5.0', () {
      const decimalAcuity = 1.0;
      const expectedLogMar = 0.0;
      const expectedFivePoint = 5.0;

      final logMar = VisionMath.logMarFromDecimal(decimalAcuity);
      expect(logMar, closeTo(expectedLogMar, epsilon));

      final fivePoint = VisionMath.fivePointFromLogMar(logMar);
      expect(fivePoint, closeTo(expectedFivePoint, epsilon));

      final backToDecimal = VisionMath.decimalFromLogMar(logMar);
      expect(backToDecimal, closeTo(decimalAcuity, epsilon));
    });

    test('样例2: 小数视力 0.5 ↔ logMAR ≈ 0.301 ↔ 五分制对数视力约 4.7', () {
      const decimalAcuity = 0.5;
      const expectedLogMar = 0.301;
      const expectedFivePoint = 4.7;

      final logMar = VisionMath.logMarFromDecimal(decimalAcuity);
      expect(logMar, closeTo(expectedLogMar, tolerance));

      final fivePoint = VisionMath.fivePointFromLogMar(logMar);
      expect(fivePoint, closeTo(expectedFivePoint, tolerance));

      final backToDecimal = VisionMath.decimalFromLogMar(logMar);
      expect(backToDecimal, closeTo(decimalAcuity, epsilon));
    });

    test('样例3: 小数视力 0.1 ↔ logMAR 1.0 ↔ 五分制对数视力 4.0', () {
      const decimalAcuity = 0.1;
      const expectedLogMar = 1.0;
      const expectedFivePoint = 4.0;

      final logMar = VisionMath.logMarFromDecimal(decimalAcuity);
      expect(logMar, closeTo(expectedLogMar, epsilon));

      final fivePoint = VisionMath.fivePointFromLogMar(logMar);
      expect(fivePoint, closeTo(expectedFivePoint, epsilon));

      final backToDecimal = VisionMath.decimalFromLogMar(logMar);
      expect(backToDecimal, closeTo(decimalAcuity, epsilon));
    });
  });

  group('回环误差测试', () {
    test('小数视力 → logMAR → 小数视力 回环误差应在可接受范围', () {
      final testValues = [0.1, 0.2, 0.5, 0.8, 1.0, 1.5, 2.0];

      for (final original in testValues) {
        final logMar = VisionMath.logMarFromDecimal(original);
        final recovered = VisionMath.decimalFromLogMar(logMar);
        expect(
          (recovered - original).abs(),
          lessThan(epsilon),
          reason: '小数视力 $original 回环误差过大',
        );
      }
    });

    test('五分制 → logMAR → 五分制 回环误差应在可接受范围', () {
      final testValues = [4.0, 4.5, 4.7, 5.0, 5.2];

      for (final original in testValues) {
        final logMar = VisionMath.logMarFromFivePoint(original);
        final recovered = VisionMath.fivePointFromLogMar(logMar);
        expect(
          (recovered - original).abs(),
          lessThan(epsilon),
          reason: '五分制 $original 回环误差过大',
        );
      }
    });

    test('小数视力 → 五分制 → 小数视力 回环误差应在可接受范围', () {
      final testValues = [0.1, 0.3, 0.5, 1.0, 1.5];

      for (final original in testValues) {
        final fivePoint = VisionMath.fivePointFromDecimal(original);
        final recovered = VisionMath.decimalFromFivePoint(fivePoint);
        expect(
          (recovered - original).abs(),
          lessThan(tolerance),
          reason: '小数视力 $original 经五分制回环误差过大',
        );
      }
    });

    test('MAR → logMAR → MAR 回环误差应在可接受范围', () {
      final testValues = [0.5, 1.0, 2.0, 5.0, 10.0];

      for (final original in testValues) {
        final logMar = VisionMath.logMarFromMar(original);
        final recovered = VisionMath.marFromLogMar(logMar);
        expect(
          (recovered - original).abs(),
          lessThan(epsilon),
          reason: 'MAR $original 回环误差过大',
        );
      }
    });
  });

  group('角度转换', () {
    test('arcminToRad: 0 arcmin 应返回 0 rad', () {
      expect(VisionMath.arcminToRad(0.0), closeTo(0.0, epsilon));
    });

    test('arcminToRad: 10800 arcmin (180度) 应返回 π rad', () {
      expect(VisionMath.arcminToRad(10800.0), closeTo(math.pi, epsilon));
    });

    test('arcminToRad: 60 arcmin (1度) 应返回 π/180 rad', () {
      expect(
        VisionMath.arcminToRad(60.0),
        closeTo(math.pi / 180, epsilon),
      );
    });
  });

  group('视标尺寸计算', () {
    test('optotypeSizeMm: logMAR 0.0, 5米距离应返回约 7.27mm', () {
      final size = VisionMath.optotypeSizeMm(
        logMar: 0.0,
        testDistanceMm: 5000.0,
      );
      expect(size, closeTo(7.27, 0.01));
    });

    test('optotypeSizeMm: logMAR 1.0, 5米距离应返回约 72.7mm', () {
      final size = VisionMath.optotypeSizeMm(
        logMar: 1.0,
        testDistanceMm: 5000.0,
      );
      expect(size, closeTo(72.7, 0.1));
    });

    test('detailSizeMm: 应为 optotypeSizeMm 的 1/5', () {
      final optotypeSize = VisionMath.optotypeSizeMm(
        logMar: 0.0,
        testDistanceMm: 5000.0,
      );
      final detailSize = VisionMath.detailSizeMm(
        logMar: 0.0,
        testDistanceMm: 5000.0,
      );
      expect(detailSize, closeTo(optotypeSize / 5, epsilon));
    });

    test('optotypeSizeMm: 非法距离（零）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.optotypeSizeMm(
          logMar: 0.0,
          testDistanceMm: 0.0,
        ),
        throwsArgumentError,
      );
    });

    test('optotypeSizeMm: 非法距离（负数）应抛出 ArgumentError', () {
      expect(
        () => VisionMath.optotypeSizeMm(
          logMar: 0.0,
          testDistanceMm: -1000.0,
        ),
        throwsArgumentError,
      );
    });
  });

  group('AcuityLevel 创建', () {
    test('createAcuityLevel: logMAR 0.0 应创建正确的 AcuityLevel', () {
      final level = VisionMath.createAcuityLevel(0.0);

      expect(level.logMar, closeTo(0.0, epsilon));
      expect(level.marArcmin, closeTo(1.0, epsilon));
      expect(level.decimalAcuity, closeTo(1.0, epsilon));
      expect(level.fivePointAcuity, closeTo(5.0, epsilon));
      expect(level.optotypeAngleArcmin, closeTo(5.0, epsilon));
      expect(level.detailAngleArcmin, closeTo(1.0, epsilon));
    });

    test('createAcuityLevel: logMAR 1.0 应创建正确的 AcuityLevel', () {
      final level = VisionMath.createAcuityLevel(1.0);

      expect(level.logMar, closeTo(1.0, epsilon));
      expect(level.marArcmin, closeTo(10.0, epsilon));
      expect(level.decimalAcuity, closeTo(0.1, epsilon));
      expect(level.fivePointAcuity, closeTo(4.0, epsilon));
      expect(level.optotypeAngleArcmin, closeTo(50.0, epsilon));
      expect(level.detailAngleArcmin, closeTo(10.0, epsilon));
    });
  });

  group('RenderMetrics 计算', () {
    late ScreenProfile testScreen;

    setUp(() {
      testScreen = ScreenProfile(
        id: 'test-screen',
        deviceName: 'Test Device',
        screenWidthMm: 200.0,
        screenHeightMm: 150.0,
        screenWidthPx: 1920,
        screenHeightPx: 1440,
        devicePixelRatio: 1.0,
        isDpiAware: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    test('calculateRenderMetrics: 应正确计算渲染参数', () {
      final metrics = VisionMath.calculateRenderMetrics(
        logMar: 0.0,
        testDistanceMm: 5000.0,
        screenProfile: testScreen,
      );

      expect(metrics.testDistanceMm, equals(5000.0));
      expect(metrics.optotypeSizeMm, closeTo(7.27, 0.01));
      expect(metrics.detailSizeMm, closeTo(1.45, 0.01));
      expect(metrics.optotypeWidthPx, greaterThan(0));
      expect(metrics.optotypeHeightPx, greaterThan(0));
      expect(metrics.detailWidthPx, greaterThan(0));
      expect(metrics.detailHeightPx, greaterThan(0));
    });

    test('calculateRenderMetrics: 像素极限检测应正确触发', () {
      final metrics = VisionMath.calculateRenderMetrics(
        logMar: -0.3,
        testDistanceMm: 5000.0,
        screenProfile: testScreen,
        minCriticalDetailPx: 3.0,
      );

      expect(
        metrics.pixelLimitReached,
        equals(metrics.criticalDetailPx < 3.0),
      );
    });

    test('isPixelLimitReached: 应正确判断像素极限', () {
      final metrics = VisionMath.calculateRenderMetrics(
        logMar: 0.0,
        testDistanceMm: 5000.0,
        screenProfile: testScreen,
      );

      final isReached = VisionMath.isPixelLimitReached(metrics, 100.0);
      expect(isReached, isTrue);

      final isNotReached = VisionMath.isPixelLimitReached(metrics, 0.1);
      expect(isNotReached, isFalse);
    });

    test('minimumTestDistanceMm: 应正确计算 1px 极限下的最小测试距离', () {
      final minimumDistance = VisionMath.minimumTestDistanceMm(
        logMar: VisionMath.logMarFromDecimal(1.5),
        screenProfile: testScreen,
        minCriticalDetailPx: 1.0,
      );

      expect(minimumDistance, closeTo(537.1, 1.0));
    });

    test('minimumTestDistanceMm: 像素阈值越大最小测试距离越大', () {
      final distanceForOnePixel = VisionMath.minimumTestDistanceMm(
        logMar: VisionMath.logMarFromDecimal(1.5),
        screenProfile: testScreen,
        minCriticalDetailPx: 1.0,
      );
      final distanceForThreePixels = VisionMath.minimumTestDistanceMm(
        logMar: VisionMath.logMarFromDecimal(1.5),
        screenProfile: testScreen,
        minCriticalDetailPx: 3.0,
      );

      expect(distanceForThreePixels, greaterThan(distanceForOnePixel));
    });
  });

  group('统计函数', () {
    test('mean: 应正确计算平均值', () {
      expect(VisionMath.mean([1.0, 2.0, 3.0, 4.0, 5.0]), closeTo(3.0, epsilon));
    });

    test('mean: 单元素列表应返回该元素', () {
      expect(VisionMath.mean([5.0]), equals(5.0));
    });

    test('mean: 空列表应抛出 ArgumentError', () {
      expect(() => VisionMath.mean([]), throwsArgumentError);
    });

    test('standardDeviation: 应正确计算标准差', () {
      final values = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0];
      final stdDev = VisionMath.standardDeviation(values);
      expect(stdDev, closeTo(2.0, 0.01));
    });

    test('standardDeviation: 单元素列表应返回 0', () {
      expect(VisionMath.standardDeviation([5.0]), equals(0.0));
    });

    test('standardDeviation: 空列表应抛出 ArgumentError', () {
      expect(() => VisionMath.standardDeviation([]), throwsArgumentError);
    });
  });

  group('边界条件测试', () {
    test('极小正数输入应正常处理', () {
      expect(
        () => VisionMath.logMarFromDecimal(1e-10),
        returnsNormally,
      );
    });

    test('极大正数输入应正常处理', () {
      expect(
        () => VisionMath.logMarFromDecimal(1e10),
        returnsNormally,
      );
    });

    test('负 logMAR 应正确转换为大于 1 的小数视力', () {
      final decimal = VisionMath.decimalFromLogMar(-0.3);
      expect(decimal, closeTo(1.995, tolerance));
    });
  });
}
