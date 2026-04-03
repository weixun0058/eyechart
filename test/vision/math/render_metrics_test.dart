import 'package:flutter_test/flutter_test.dart';
import 'package:eyechart/vision/math/vision_math.dart';
import 'package:eyechart/vision/domain/vision_models.dart';

void main() {
  group('VisionMath.calculateRenderMetrics', () {
    late ScreenProfile standardScreen;

    setUp(() {
      standardScreen = ScreenProfile(
        id: 'test-screen',
        deviceName: 'Test Device',
        screenWidthMm: 344.0,
        screenHeightMm: 194.0,
        screenWidthPx: 1920,
        screenHeightPx: 1080,
        devicePixelRatio: 1.0,
        isDpiAware: true,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
    });

    group('基本功能测试', () {
      test('应正确计算 RenderMetrics 对象', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        expect(metrics, isA<RenderMetrics>());
        expect(metrics.testDistanceMm, equals(6000.0));
        expect(metrics.optotypeSizeMm, greaterThan(0));
        expect(metrics.detailSizeMm, greaterThan(0));
      });

      test('detailSizeMm 应为 optotypeSizeMm 的五分之一', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        expect(metrics.detailSizeMm, closeTo(metrics.optotypeSizeMm / 5, 0.0001));
      });
    });

    group('物理尺寸到像素尺寸映射', () {
      test('应正确计算像素尺寸（方形像素）', () {
        final squarePixelScreen = ScreenProfile(
          id: 'square-screen',
          deviceName: 'Square Pixel Device',
          screenWidthMm: 200.0,
          screenHeightMm: 200.0,
          screenWidthPx: 1000,
          screenHeightPx: 1000,
          devicePixelRatio: 1.0,
          isDpiAware: true,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        );

        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 5000.0,
          screenProfile: squarePixelScreen,
        );

        expect(metrics.optotypeWidthPx, closeTo(metrics.optotypeHeightPx, 0.0001));
        expect(metrics.detailWidthPx, closeTo(metrics.detailHeightPx, 0.0001));
      });

      test('像素尺寸应与物理尺寸和像素密度成比例', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        final expectedOptotypeWidthPx = metrics.optotypeSizeMm / standardScreen.pixelWidthMm;
        final expectedOptotypeHeightPx = metrics.optotypeSizeMm / standardScreen.pixelHeightMm;

        expect(metrics.optotypeWidthPx, closeTo(expectedOptotypeWidthPx, 0.0001));
        expect(metrics.optotypeHeightPx, closeTo(expectedOptotypeHeightPx, 0.0001));
      });

      test('logMar 增大时像素尺寸应增大', () {
        final metrics0 = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );
        final metrics1 = VisionMath.calculateRenderMetrics(
          logMar: 0.3,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        expect(metrics1.optotypeWidthPx, greaterThan(metrics0.optotypeWidthPx));
        expect(metrics1.detailWidthPx, greaterThan(metrics0.detailWidthPx));
      });

      test('测试距离增大时像素尺寸应增大', () {
        final metricsNear = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 3000.0,
          screenProfile: standardScreen,
        );
        final metricsFar = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        expect(metricsFar.optotypeWidthPx, greaterThan(metricsNear.optotypeWidthPx));
        expect(metricsFar.detailWidthPx, greaterThan(metricsNear.detailWidthPx));
      });
    });

    group('像素瓶颈判定', () {
      test('criticalDetailPx >= 3.0 时 pixelLimitReached 应为 false（允许继续）', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.3,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
          minCriticalDetailPx: 3.0,
        );

        expect(metrics.criticalDetailPx, greaterThanOrEqualTo(3.0));
        expect(metrics.pixelLimitReached, isFalse);
      });

      test('2.0 <= criticalDetailPx < 3.0 时 pixelLimitReached 应为 true（警告区）', () {
        final highDpiScreen = ScreenProfile(
          id: 'high-dpi-screen',
          deviceName: 'High DPI Device',
          screenWidthMm: 100.0,
          screenHeightMm: 100.0,
          screenWidthPx: 2000,
          screenHeightPx: 2000,
          devicePixelRatio: 1.0,
          isDpiAware: true,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        );

        final metrics = VisionMath.calculateRenderMetrics(
          logMar: -0.2,
          testDistanceMm: 3000.0,
          screenProfile: highDpiScreen,
          minCriticalDetailPx: 3.0,
        );

        expect(metrics.criticalDetailPx, inInclusiveRange(2.0, 2.99));
        expect(metrics.pixelLimitReached, isTrue);
      });

      test('criticalDetailPx < 2.0 时 pixelLimitReached 应为 true（禁止继续）', () {
        final veryHighDpiScreen = ScreenProfile(
          id: 'very-high-dpi-screen',
          deviceName: 'Very High DPI Device',
          screenWidthMm: 50.0,
          screenHeightMm: 50.0,
          screenWidthPx: 2000,
          screenHeightPx: 2000,
          devicePixelRatio: 1.0,
          isDpiAware: true,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        );

        final metrics = VisionMath.calculateRenderMetrics(
          logMar: -0.4,
          testDistanceMm: 2000.0,
          screenProfile: veryHighDpiScreen,
          minCriticalDetailPx: 3.0,
        );

        expect(metrics.criticalDetailPx, lessThan(2.0));
        expect(metrics.pixelLimitReached, isTrue);
      });

      test('自定义 minCriticalDetailPx 阈值应生效', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
          minCriticalDetailPx: 5.0,
        );

        final expectedLimitReached = metrics.criticalDetailPx < 5.0;
        expect(metrics.pixelLimitReached, equals(expectedLimitReached));
      });
    });

    group('横竖像素不一致场景', () {
      test('criticalDetailPx 应取 detailWidthPx 和 detailHeightPx 的较小值', () {
        final nonSquareScreen = ScreenProfile(
          id: 'non-square-screen',
          deviceName: 'Non-Square Pixel Device',
          screenWidthMm: 300.0,
          screenHeightMm: 200.0,
          screenWidthPx: 1000,
          screenHeightPx: 1000,
          devicePixelRatio: 1.0,
          isDpiAware: true,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        );

        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 5000.0,
          screenProfile: nonSquareScreen,
        );

        final expectedCritical = metrics.detailWidthPx < metrics.detailHeightPx
            ? metrics.detailWidthPx
            : metrics.detailHeightPx;

        expect(metrics.criticalDetailPx, closeTo(expectedCritical, 0.0001));
      });

      test('非方形像素屏幕应产生不同的宽高像素值', () {
        final nonSquareScreen = ScreenProfile(
          id: 'non-square-screen',
          deviceName: 'Non-Square Pixel Device',
          screenWidthMm: 300.0,
          screenHeightMm: 200.0,
          screenWidthPx: 1000,
          screenHeightPx: 1000,
          devicePixelRatio: 1.0,
          isDpiAware: true,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        );

        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 5000.0,
          screenProfile: nonSquareScreen,
        );

        expect(metrics.optotypeWidthPx, isNot(equals(metrics.optotypeHeightPx)));
        expect(metrics.detailWidthPx, isNot(equals(metrics.detailHeightPx)));
      });

      test('像素瓶颈应由较小的像素维度决定', () {
        final nonSquareScreen = ScreenProfile(
          id: 'non-square-screen',
          deviceName: 'Non-Square Pixel Device',
          screenWidthMm: 300.0,
          screenHeightMm: 150.0,
          screenWidthPx: 1000,
          screenHeightPx: 1000,
          devicePixelRatio: 1.0,
          isDpiAware: true,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        );

        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 5000.0,
          screenProfile: nonSquareScreen,
        );

        expect(metrics.criticalDetailPx, equals(metrics.detailHeightPx));
        expect(metrics.detailHeightPx, lessThan(metrics.detailWidthPx));
      });
    });

    group('边界条件测试', () {
      test('logMar = 1.0 时应正确计算大尺寸视标', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 1.0,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        expect(metrics.optotypeSizeMm, greaterThan(0));
        expect(metrics.optotypeWidthPx, greaterThan(0));
        expect(metrics.criticalDetailPx, greaterThan(10));
      });

      test('logMar = -0.3 时应正确计算小尺寸视标', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: -0.3,
          testDistanceMm: 6000.0,
          screenProfile: standardScreen,
        );

        expect(metrics.optotypeSizeMm, greaterThan(0));
        expect(metrics.optotypeWidthPx, greaterThan(0));
      });

      test('极小测试距离时应正确计算', () {
        final metrics = VisionMath.calculateRenderMetrics(
          logMar: 0.0,
          testDistanceMm: 1000.0,
          screenProfile: standardScreen,
        );

        expect(metrics.optotypeSizeMm, greaterThan(0));
        expect(metrics.testDistanceMm, equals(1000.0));
      });
    });
  });

  group('VisionMath.isPixelLimitReached', () {
    test('应正确判断像素限制', () {
      final metricsAboveLimit = RenderMetrics(
        testDistanceMm: 6000.0,
        optotypeSizeMm: 10.0,
        detailSizeMm: 2.0,
        optotypeWidthPx: 50.0,
        optotypeHeightPx: 50.0,
        detailWidthPx: 10.0,
        detailHeightPx: 10.0,
        criticalDetailPx: 5.0,
        pixelLimitReached: false,
      );

      final metricsBelowLimit = RenderMetrics(
        testDistanceMm: 6000.0,
        optotypeSizeMm: 10.0,
        detailSizeMm: 2.0,
        optotypeWidthPx: 50.0,
        optotypeHeightPx: 50.0,
        detailWidthPx: 2.0,
        detailHeightPx: 2.0,
        criticalDetailPx: 2.0,
        pixelLimitReached: true,
      );

      expect(VisionMath.isPixelLimitReached(metricsAboveLimit, 3.0), isFalse);
      expect(VisionMath.isPixelLimitReached(metricsBelowLimit, 3.0), isTrue);
    });

    test('临界值判断应为 < 而非 <=', () {
      final metrics = RenderMetrics(
        testDistanceMm: 6000.0,
        optotypeSizeMm: 10.0,
        detailSizeMm: 2.0,
        optotypeWidthPx: 50.0,
        optotypeHeightPx: 50.0,
        detailWidthPx: 3.0,
        detailHeightPx: 3.0,
        criticalDetailPx: 3.0,
        pixelLimitReached: false,
      );

      expect(VisionMath.isPixelLimitReached(metrics, 3.0), isFalse);
    });
  });
}
