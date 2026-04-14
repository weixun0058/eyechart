import 'package:flutter_test/flutter_test.dart';
import 'package:eyechart/vision/domain/vision_enums.dart';
import 'package:eyechart/vision/domain/vision_models.dart';
import 'package:eyechart/vision/testing/adaptive_line_engine.dart';

void main() {
  group('AdaptiveLineEngine', () {
    late TestConfig config;

    setUp(() {
      config = TestConfig(
        id: 'test',
        eyeSide: EyeSide.right,
        testMode: TestMode.isolated,
        inputMode: InputMode.touchButtons,
        testDistanceMm: 400,
        startLogMar: 0.5,
        minLogMar: -0.3,
        maxLogMar: 1.0,
        stepLogMar: 0.1,
        optotypesPerLine: 5,
        consecutiveCorrectToPass: 3,
        consecutiveWrongToFail: 2,
        maxErrorsPerLine: 1,
        requiredLineReversals: 3,
        maxQuestionCount: 999,
        answerTimeLimitMs: 3000,
        minCriticalDetailPx: 1.0,
        enableEnvironmentCheck: true,
        enablePixelLimitProtection: true,
      );
    });

    group('initialState', () {
      test('应该从 startLogMar 开始', () {
        final state = AdaptiveLineEngine.initialState(config);

        expect(state.currentLogMar, 0.5);
        expect(state.currentLineIndex, 5); // (1.0 - 0.5) / 0.1 = 5
        expect(state.lineDirection, LineDirection.down);
        expect(state.protocolCompleted, false);
        expect(state.consecutiveCorrectCount, 0);
        expect(state.consecutiveWrongCount, 0);
        expect(state.determinedLogMar, isNull);
      });
    });

    group('快速通过 - 前3题全对', () {
      test('前3题全对应快速通过并下行', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 前3题全对
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );
        expect(state.currentLinePresentedCount, 1);
        expect(state.consecutiveCorrectCount, 1);

        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );
        expect(state.currentLinePresentedCount, 2);
        expect(state.consecutiveCorrectCount, 2);

        // 第3题答对后应该快速通过，跳到下一行
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );

        // 验证下行到下一行
        expect(state.currentLogMar, closeTo(0.4, 0.0001)); // 下行到 0.4
        expect(state.currentLinePresentedCount, 0); // 新行，计数重置
        expect(state.determinedLogMar, 0.5); // 视力暂定为上一行
        expect(state.lineDirection, LineDirection.down);
      });
    });

    group('快速失败 - 任意位置连续2错', () {
      test('第1-2题连续错应快速失败并上行', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1题错
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        expect(state.currentLinePresentedCount, 1);
        expect(state.consecutiveWrongCount, 1);

        // 第2题错，连续2错，快速失败
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );

        // 验证上行到上一行
        expect(state.currentLogMar, closeTo(0.6, 0.0001)); // 上行到 0.6
        expect(state.currentLinePresentedCount, 0);
        expect(state.determinedLogMar, 0.6); // 视力暂定为上一级
        expect(state.lineDirection, LineDirection.up);
        expect(state.lineReversalCount, 1); // 第1次反转（下行→上行）
      });

      test('第2-3题连续错应快速失败', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1题对
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );

        // 第2题错
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        expect(state.consecutiveWrongCount, 1);

        // 第3题错，连续2错
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );

        expect(state.currentLogMar, closeTo(0.6, 0.0001)); // 上行
        expect(state.lineReversalCount, 1);
      });

      test('不连续的2错不应触发快速失败', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1题错
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );

        // 第2题对（打断连续错误）
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );
        expect(state.consecutiveWrongCount, 0);

        // 第3题错
        state = AdaptiveLineEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        expect(state.consecutiveWrongCount, 1);

        // 仍在当前行，没有上行
        expect(state.currentLogMar, 0.5);
        expect(state.currentLinePresentedCount, 3);
      });
    });

    group('完整测试 - 前3题只有1错', () {
      test('前3题1错，5题后错误数≤1应通过', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1题对
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        // 第2题对
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        // 第3题错（前3题只有1错）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);

        // 仍在当前行，需要答完5题
        expect(state.currentLogMar, 0.5);
        expect(state.currentLinePresentedCount, 3);

        // 第4题对
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        // 第5题对（5题共1错，通过）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);

        // 验证下行
        expect(state.currentLogMar, closeTo(0.4, 0.0001));
        expect(state.determinedLogMar, 0.5);
        expect(state.lineDirection, LineDirection.down);
      });

      test('前3题1错，5题后错误数≥2应失败', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1题对
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        // 第2题错
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        // 第3题对（前3题1错）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);

        // 第4题对
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        // 第5题错（5题共2错，失败）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);

        // 验证上行
        expect(state.currentLogMar, closeTo(0.6, 0.0001));
        expect(state.determinedLogMar, closeTo(0.6, 0.0001));
        expect(state.lineDirection, LineDirection.up);
        expect(state.lineReversalCount, 1);
      });
    });

    group('反转计数 - 只计下行→上行', () {
      test('下行→上行应计为反转', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 快速失败触发上行
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);

        expect(state.lineDirection, LineDirection.up);
        expect(state.lineReversalCount, 1);
      });

      test('上行→下行不应计为反转', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1次反转：下行→上行
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        expect(state.lineReversalCount, 1);

        // 在第2行（0.6）快速通过，下行到第1行（0.5）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);

        // 上行→下行，反转次数不变
        expect(state.lineDirection, LineDirection.down);
        expect(state.lineReversalCount, 1);
      });

      test('3次下行→上行反转应终止测试', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 第1次反转
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        expect(state.lineReversalCount, 1);
        expect(state.protocolCompleted, false);

        // 下行（不计反转）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);

        // 第2次反转
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        expect(state.lineReversalCount, 2);
        expect(state.protocolCompleted, false);

        // 下行（不计反转）
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);

        // 第3次反转，应终止
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        expect(state.lineReversalCount, 3);
        expect(state.protocolCompleted, true);
      });
    });

    group('视力值确定', () {
      test('行通过时视力应暂定为当前行', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 快速通过
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: true);

        expect(state.determinedLogMar, 0.5);
      });

      test('行失败时视力应暂定为向上一级', () {
        var state = AdaptiveLineEngine.initialState(config);

        // 快速失败
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);
        state = AdaptiveLineEngine.applyAnswer(state: state, config: config, isCorrect: false);

        expect(state.determinedLogMar, 0.6);
      });
    });
  });
}
