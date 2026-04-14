import 'package:eyechart/ui/widgets/e_optotype_view.dart';
import 'package:eyechart/vision/domain/vision_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EOptotypeView', () {
    testWidgets('孤立模式只渲染单个视标', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: EOptotypeView(
                size: 100,
                direction: OptotypeDirection.up,
              ),
            ),
          ),
        ),
      );

      final optotypeFinder = find.byType(EOptotypeView);

      expect(
        find.descendant(
          of: optotypeFinder,
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: optotypeFinder,
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: optotypeFinder,
          matching: find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox &&
              widget.width != null &&
              widget.height != null &&
              (widget.width! - 100).abs() < 0.001 &&
              (widget.height! - 100).abs() < 0.001,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('拥挤模式渲染四个干扰条与更大的包围区域', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: EOptotypeView(
                size: 100,
                direction: OptotypeDirection.left,
                testMode: TestMode.crowded,
              ),
            ),
          ),
        ),
      );

      final optotypeFinder = find.byType(EOptotypeView);

      expect(
        find.descendant(
          of: optotypeFinder,
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: optotypeFinder,
          matching: find.byType(DecoratedBox),
        ),
        findsNWidgets(4),
      );
      expect(
        find.descendant(
          of: optotypeFinder,
          matching: find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox &&
              widget.width != null &&
              widget.height != null &&
              (widget.width! - 180).abs() < 0.001 &&
              (widget.height! - 180).abs() < 0.001,
          ),
        ),
        findsOneWidget,
      );
    });
  });
}
