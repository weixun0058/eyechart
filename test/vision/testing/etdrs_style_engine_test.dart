import 'package:flutter_test/flutter_test.dart';

import 'package:eyechart/vision/domain/vision_enums.dart';
import 'package:eyechart/vision/domain/vision_models.dart';
import 'package:eyechart/vision/testing/etdrs_style_engine.dart';

void main() {
  group('EtdrsStyleEngine', () {
    late TestConfig config;

    setUp(() {
      config = const TestConfig(
        id: 'test-config',
        eyeSide: EyeSide.right,
        testMode: TestMode.isolated,
        inputMode: InputMode.keyboard,
        testDistanceMm: 4000,
        startLogMar: 0.5,
        minLogMar: -0.2,
        maxLogMar: 1.0,
        stepLogMar: 0.1,
        optotypesPerLine: 5,
        consecutiveCorrectToPass: 3,
        consecutiveWrongToFail: 2,
        maxErrorsPerLine: 1,
        requiredLineReversals: 2,
        maxQuestionCount: 50,
        answerTimeLimitMs: 5000,
        minCriticalDetailPx: 3.0,
        enableEnvironmentCheck: true,
        enablePixelLimitProtection: true,
      );
    });

    group('initialState', () {
      test('should create initial state with correct values', () {
        final state = EtdrsStyleEngine.initialState(config);

        expect(state.currentLogMar, equals(0.5));
        expect(state.currentLinePresentedCount, equals(0));
        expect(state.currentLineCorrectCount, equals(0));
        expect(state.currentLineErrorCount, equals(0));
        expect(state.lineDirection, equals(LineDirection.down));
        expect(state.lineReversalCount, equals(0));
        expect(state.protocolCompleted, isFalse);
      });
    });

    group('line progression', () {
      test('should stay on same line after answering', () {
        var state = EtdrsStyleEngine.initialState(config);

        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );

        expect(state.currentLogMar, equals(0.5));
        expect(state.currentLinePresentedCount, equals(1));
        expect(state.currentLineCorrectCount, equals(1));
        expect(state.currentLineErrorCount, equals(0));
      });

      test('should move to next line when line is passed', () {
        var state = EtdrsStyleEngine.initialState(config);

        // 5 correct answers to pass the line (minCorrectPerLine = 3)
        for (var i = 0; i < 5; i++) {
          state = EtdrsStyleEngine.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
          );
        }

        expect(state.currentLogMar, closeTo(0.4, 0.0001));
        expect(state.currentLinePresentedCount, equals(0));
        expect(state.currentLineCorrectCount, equals(0));
      });

      test('should reverse direction when line fails (error > maxErrorsPerLine)', () {
        var state = EtdrsStyleEngine.initialState(config);

        // 2 errors in a row (maxErrorsPerLine = 1)
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );

        expect(state.currentLogMar, equals(0.6));
        expect(state.lineDirection, equals(LineDirection.up));
        expect(state.lineReversalCount, equals(1));
      });

      test('should reverse direction when line is not passed', () {
        var state = EtdrsStyleEngine.initialState(config);

        // Complete line with only 2 correct (minCorrectPerLine = 3)
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );

        expect(state.currentLogMar, equals(0.6));
        expect(state.lineDirection, equals(LineDirection.up));
        expect(state.lineReversalCount, equals(1));
      });
    });

    group('termination condition', () {
      test('should complete when required line reversals reached', () {
        var state = EtdrsStyleEngine.initialState(config);

        // Initial: lineIndex 5 (logMAR 0.5)
        // After 5 correct: lineIndex 6 (logMAR 0.4)
        for (var i = 0; i < 5; i++) {
          state = EtdrsStyleEngine.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
          );
        }
        expect(state.currentLogMar, closeTo(0.4, 0.0001));

        // Fail to trigger reverse (1st reversal: down -> up)
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        expect(state.lineReversalCount, equals(1));
        expect(state.protocolCompleted, isFalse);

        // Now going up at lineIndex 5 (logMAR 0.5), fail to trigger second reverse
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        state = EtdrsStyleEngine.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
        );
        expect(state.lineReversalCount, equals(2));
        expect(state.protocolCompleted, isTrue);
      });
    });

    group('calculateLetterScore', () {
      test('should calculate letter score correctly', () {
        expect(EtdrsStyleEngine.calculateLetterScore(0), equals(30));
        expect(EtdrsStyleEngine.calculateLetterScore(10), equals(40));
        expect(EtdrsStyleEngine.calculateLetterScore(20), equals(50));
      });
    });

    group('calculateEquivalentLogMar', () {
      test('should calculate logMAR correctly', () {
        expect(
          EtdrsStyleEngine.calculateEquivalentLogMar(30),
          closeTo(1.1, 0.0001),
        );
        expect(
          EtdrsStyleEngine.calculateEquivalentLogMar(40),
          closeTo(0.9, 0.0001),
        );
        expect(
          EtdrsStyleEngine.calculateEquivalentLogMar(50),
          closeTo(0.7, 0.0001),
        );
      });
    });

    group('calculateBestLineLogMar', () {
      test('should return startLogMar for empty questions', () {
        final result = EtdrsStyleEngine.calculateBestLineLogMar([], config);
        expect(result, equals(config.startLogMar));
      });

      test('should find best passed line', () {
        // 使用 config.maxLogMar (1.0) - lineIndex * stepLogMar (0.1)
        // lineIndex 0 = 1.0, lineIndex 1 = 0.9, lineIndex 2 = 0.8
        final questions = [
          _buildQuestionRecord(lineIndex: 0, isCorrect: true),
          _buildQuestionRecord(lineIndex: 0, isCorrect: true),
          _buildQuestionRecord(lineIndex: 0, isCorrect: true),
          _buildQuestionRecord(lineIndex: 1, isCorrect: true),
          _buildQuestionRecord(lineIndex: 1, isCorrect: true),
          _buildQuestionRecord(lineIndex: 1, isCorrect: true),
          _buildQuestionRecord(lineIndex: 2, isCorrect: false),
          _buildQuestionRecord(lineIndex: 2, isCorrect: false),
        ];

        final result = EtdrsStyleEngine.calculateBestLineLogMar(questions, config);
        expect(result, closeTo(0.9, 0.0001)); // lineIndex 1 = logMAR 0.9
      });
    });

    group('buildEyeTestResult', () {
      test('should build result with correct values', () {
        final questions = [
          _buildQuestionRecord(lineIndex: 0, isCorrect: true, responseTimeMs: 1500),
          _buildQuestionRecord(lineIndex: 0, isCorrect: false, responseTimeMs: 2000),
        ];

        final result = EtdrsStyleEngine.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.isolated,
          questions: questions,
          config: config,
          pixelLimitEncountered: false,
        );

        expect(result.eyeSide, equals(EyeSide.right));
        expect(result.testMode, equals(TestMode.isolated));
        expect(result.totalQuestions, equals(2));
        expect(result.correctQuestions, equals(1));
        expect(result.accuracy, equals(0.5));
        expect(result.meanResponseTimeMs, equals(1750));
        expect(result.etdrsLetterScore, equals(31));
        expect(result.pixelLimitEncountered, isFalse);
      });

      test('should calculate equivalent logMAR correctly', () {
        final questions = [
          for (var i = 0; i < 20; i++)
            _buildQuestionRecord(lineIndex: i ~/ 5, isCorrect: true),
        ];

        final result = EtdrsStyleEngine.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.isolated,
          questions: questions,
          config: config,
          pixelLimitEncountered: false,
        );

        expect(result.etdrsLetterScore, equals(50));
        expect(result.equivalentLogMar, closeTo(0.7, 0.0001));
      });
    });

    group('integration scenarios', () {
      test('should simulate complete test session', () {
        var state = EtdrsStyleEngine.initialState(config);
        final answers = [
          // Line 0 (logMAR 1.0): 5 correct, pass
          true, true, true, true, true,
          // Line 1 (logMAR 0.9): 5 correct, pass
          true, true, true, true, true,
          // Line 2 (logMAR 0.8): 2 errors, fail and reverse (1st reversal: down -> up)
          false, false,
          // Now at Line 1 (logMAR 0.9) going up: 2 errors, fail and reverse (2nd reversal: up -> down, stop)
          false, false,
        ];

        for (final answer in answers) {
          state = EtdrsStyleEngine.applyAnswer(
            state: state,
            config: config,
            isCorrect: answer,
          );
        }

        expect(state.lineReversalCount, equals(2));
        expect(state.protocolCompleted, isTrue);
        expect(state.totalCorrectCount, equals(10));
      });
    });
  });
}

QuestionRecord _buildQuestionRecord({
  required int lineIndex,
  required bool isCorrect,
  int responseTimeMs = 1500,
}) {
  return QuestionRecord(
    index: 0,
    eyeSide: EyeSide.right,
    testMode: TestMode.isolated,
    lineIndex: lineIndex,
    optotypeIndexInLine: 0,
    targetLogMar: 0.5 - lineIndex * 0.1,
    targetDecimalAcuity: 0.3,
    targetFivePointAcuity: 4.5,
    displayedDirection: OptotypeDirection.up,
    userAnswer: isCorrect ? OptotypeDirection.up : OptotypeDirection.down,
    isCorrect: isCorrect,
    isTimeout: false,
    responseTimeMs: responseTimeMs,
    renderMetrics: const RenderMetrics(
      testDistanceMm: 4000,
      optotypeSizeMm: 10,
      detailSizeMm: 2,
      optotypeWidthPx: 30,
      optotypeHeightPx: 30,
      detailWidthPx: 6,
      detailHeightPx: 6,
      criticalDetailPx: 6,
      pixelLimitReached: false,
    ),
    shownAt: DateTime.now(),
    answeredAt: DateTime.now(),
  );
}
