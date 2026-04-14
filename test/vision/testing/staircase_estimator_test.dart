import 'package:flutter_test/flutter_test.dart';

import 'package:eyechart/vision/domain/vision_enums.dart';
import 'package:eyechart/vision/domain/vision_models.dart';
import 'package:eyechart/vision/testing/staircase_estimator.dart';

void main() {
  group('StaircaseEstimator', () {
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
        requiredCorrectForStepDown: 3,
        allowedWrongForStepUp: 1,
        requiredReversalCount: 6,
        maxQuestionCount: 50,
        answerTimeLimitMs: 5000,
        minCriticalDetailPx: 3.0,
        enableEnvironmentCheck: true,
        enablePixelLimitProtection: true,
      );
    });

    group('initialState', () {
      test('should create initial state with correct values', () {
        final state = StaircaseEstimator.initialState(config);

        expect(state.currentLogMar, equals(0.5));
        expect(state.consecutiveCorrectCount, equals(0));
        expect(state.consecutiveWrongCount, equals(0));
        expect(state.lastStepDirection, isNull);
        expect(state.reversals, isEmpty);
        expect(state.thresholdReached, isFalse);
      });
    });

    group('3-down 1-up rule', () {
      test('should not step down after 1 correct answer', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 0,
        );

        expect(state.currentLogMar, equals(0.5));
        expect(state.consecutiveCorrectCount, equals(1));
        expect(state.consecutiveWrongCount, equals(0));
        expect(state.lastStepDirection, isNull);
      });

      test('should not step down after 2 correct answers', () {
        var state = StaircaseEstimator.initialState(config);

        for (var i = 0; i < 2; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: i,
          );
        }

        expect(state.currentLogMar, equals(0.5));
        expect(state.consecutiveCorrectCount, equals(2));
        expect(state.lastStepDirection, isNull);
      });

      test('should step down after 3 consecutive correct answers', () {
        var state = StaircaseEstimator.initialState(config);

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: i,
          );
        }

        expect(state.currentLogMar, equals(0.4));
        expect(state.consecutiveCorrectCount, equals(0));
        expect(state.consecutiveWrongCount, equals(0));
        expect(state.lastStepDirection, equals(StepDirection.down));
      });

      test('should step up after 1 wrong answer', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 0,
        );

        expect(state.currentLogMar, equals(0.6));
        expect(state.consecutiveCorrectCount, equals(0));
        expect(state.consecutiveWrongCount, equals(0));
        expect(state.lastStepDirection, equals(StepDirection.up));
      });

      test('should reset correct count on wrong answer', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 0,
        );
        expect(state.consecutiveCorrectCount, equals(1));

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 1,
        );

        expect(state.consecutiveCorrectCount, equals(0));
        expect(state.consecutiveWrongCount, equals(0));
        expect(state.currentLogMar, equals(0.6));
      });

      test('should reset wrong count on correct answer', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 0,
        );
        expect(state.consecutiveWrongCount, equals(0));

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 1,
        );

        expect(state.consecutiveWrongCount, equals(0));
        expect(state.consecutiveCorrectCount, equals(1));
      });
    });

    group('boundary clamping', () {
      test('should not go below minLogMar', () {
        var state = StaircaseEstimator.initialState(
          config.copyWith(startLogMar: -0.1),
        );

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config.copyWith(startLogMar: -0.1),
            isCorrect: true,
            questionIndex: i,
          );
        }

        expect(state.currentLogMar, equals(-0.2));
      });

      test('should not go above maxLogMar', () {
        var state = StaircaseEstimator.initialState(
          config.copyWith(startLogMar: 1.0),
        );

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config.copyWith(startLogMar: 1.0),
          isCorrect: false,
          questionIndex: 0,
        );

        expect(state.currentLogMar, equals(1.0));
      });
    });

    group('reversal detection', () {
      test('should not record reversal when no previous direction', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 0,
        );

        expect(state.reversals, isEmpty);
      });

      test('should not record reversal when direction unchanged', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 0,
        );
        expect(state.reversals, isEmpty);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 1,
        );
        expect(state.reversals, isEmpty);
      });

      test('should record reversal when direction changes from up to down', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 0,
        );
        expect(state.lastStepDirection, equals(StepDirection.up));

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: 1 + i,
          );
        }

        expect(state.reversals.length, equals(1));
        expect(state.reversals[0].previousDirection, equals(StepDirection.up));
        expect(state.reversals[0].currentDirection, equals(StepDirection.down));
        expect(state.reversals[0].logMar, equals(0.6));
      });

      test('should record reversal when direction changes from down to up', () {
        var state = StaircaseEstimator.initialState(config);

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: i,
          );
        }
        expect(state.lastStepDirection, equals(StepDirection.down));

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 3,
        );

        expect(state.reversals.length, equals(1));
        expect(state.reversals[0].previousDirection, equals(StepDirection.down));
        expect(state.reversals[0].currentDirection, equals(StepDirection.up));
        expect(state.reversals[0].logMar, equals(0.4));
      });

      test('should record multiple reversals correctly', () {
        var state = StaircaseEstimator.initialState(config);

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: i,
          );
        }

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 3,
        );
        expect(state.reversals.length, equals(1));

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: 4 + i,
          );
        }
        expect(state.reversals.length, equals(2));
      });

      test('should record correct question index in reversal', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 5,
        );

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: 6 + i,
          );
        }

        expect(state.reversals[0].questionIndex, equals(8));
      });
    });

    group('termination condition', () {
      test('should not reach threshold with insufficient reversals', () {
        var state = StaircaseEstimator.initialState(config);

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: true,
            questionIndex: i,
          );
        }

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 3,
        );

        expect(state.thresholdReached, isFalse);
      });

      test('should reach threshold when reversal count meets requirement', () {
        var state = StaircaseEstimator.initialState(
          config.copyWith(requiredReversalCount: 2),
        );
        final shortConfig = config.copyWith(requiredReversalCount: 2);

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: shortConfig,
            isCorrect: true,
            questionIndex: i,
          );
        }

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: shortConfig,
          isCorrect: false,
          questionIndex: 3,
        );
        expect(state.reversals.length, equals(1));
        expect(state.thresholdReached, isFalse);

        for (var i = 0; i < 3; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: shortConfig,
            isCorrect: true,
            questionIndex: 4 + i,
          );
        }

        expect(state.reversals.length, equals(2));
        expect(state.thresholdReached, isTrue);
      });

      test('should reach threshold with 6 reversals as configured', () {
        var state = StaircaseEstimator.initialState(config);

        for (var cycle = 0; cycle < 6; cycle++) {
          for (var i = 0; i < 3; i++) {
            state = StaircaseEstimator.applyAnswer(
              state: state,
              config: config,
              isCorrect: true,
              questionIndex: cycle * 4 + i,
            );
          }

          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: false,
            questionIndex: cycle * 4 + 3,
          );
        }

        expect(state.reversals.length, equals(11));
        expect(state.thresholdReached, isTrue);
      });
    });

    group('estimateThresholdLogMar', () {
      test('should throw ArgumentError for empty reversals', () {
        expect(
          () => StaircaseEstimator.estimateThresholdLogMar([]),
          throwsArgumentError,
        );
      });

      test('should calculate median of single reversal', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
        ];

        final threshold = StaircaseEstimator.estimateThresholdLogMar(reversals);

        expect(threshold, closeTo(0.3, 0.0000001));
      });

      test('should calculate median of last N reversals', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.5,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.4,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
          const ReversalPoint(
            questionIndex: 2,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 3,
            logMar: 0.2,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final threshold = StaircaseEstimator.estimateThresholdLogMar(
          reversals,
          lastN: 2,
        );

        expect(threshold, equals(0.25));
      });

      test('should use all reversals when fewer than lastN', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.4,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.2,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final threshold = StaircaseEstimator.estimateThresholdLogMar(
          reversals,
          lastN: 4,
        );

        expect(threshold, closeTo(0.3, 0.0000001));
      });

      test('should use default lastN=4 when not specified', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.6,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.5,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
          const ReversalPoint(
            questionIndex: 2,
            logMar: 0.4,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 3,
            logMar: 0.3,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
          const ReversalPoint(
            questionIndex: 4,
            logMar: 0.2,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
        ];

        final threshold = StaircaseEstimator.estimateThresholdLogMar(reversals);

        expect(threshold, equals(0.35));
      });

      test('should reduce the influence of a single outlier reversal', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.2,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.2,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
          const ReversalPoint(
            questionIndex: 2,
            logMar: 0.2,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 3,
            logMar: 0.4,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final threshold = StaircaseEstimator.estimateThresholdLogMar(reversals);

        expect(threshold, equals(0.2));
      });
    });

    group('calculateReversalStdDev', () {
      test('should return 0 for empty reversals', () {
        final stdDev = StaircaseEstimator.calculateReversalStdDev([]);
        expect(stdDev, equals(0));
      });

      test('should return 0 for single reversal', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
        ];

        final stdDev = StaircaseEstimator.calculateReversalStdDev(reversals);
        expect(stdDev, equals(0));
      });

      test('should calculate standard deviation correctly', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.2,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.4,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final stdDev = StaircaseEstimator.calculateReversalStdDev(reversals);

        expect(stdDev, closeTo(0.1, 0.0001));
      });

      test('should use last N reversals for calculation', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.5,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.5,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
          const ReversalPoint(
            questionIndex: 2,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 3,
            logMar: 0.3,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final stdDev = StaircaseEstimator.calculateReversalStdDev(
          reversals,
          lastN: 2,
        );

        expect(stdDev, equals(0));
      });
    });

    group('buildEyeTestResult', () {
      test('should build result with correct values', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.2,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final questions = [
          QuestionRecord(
            index: 0,
            eyeSide: EyeSide.right,
            testMode: TestMode.isolated,
            targetLogMar: 0.5,
            targetDecimalAcuity: 0.316,
            targetFivePointAcuity: 4.5,
            displayedDirection: OptotypeDirection.up,
            userAnswer: OptotypeDirection.up,
            isCorrect: true,
            isTimeout: false,
            responseTimeMs: 1500,
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
          ),
          QuestionRecord(
            index: 1,
            eyeSide: EyeSide.right,
            testMode: TestMode.isolated,
            targetLogMar: 0.4,
            targetDecimalAcuity: 0.398,
            targetFivePointAcuity: 4.6,
            displayedDirection: OptotypeDirection.down,
            userAnswer: OptotypeDirection.left,
            isCorrect: false,
            isTimeout: false,
            responseTimeMs: 2000,
            renderMetrics: const RenderMetrics(
              testDistanceMm: 4000,
              optotypeSizeMm: 8,
              detailSizeMm: 1.6,
              optotypeWidthPx: 24,
              optotypeHeightPx: 24,
              detailWidthPx: 4.8,
              detailHeightPx: 4.8,
              criticalDetailPx: 4.8,
              pixelLimitReached: false,
            ),
            shownAt: DateTime.now(),
            answeredAt: DateTime.now(),
          ),
        ];

        final result = StaircaseEstimator.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.isolated,
          questions: questions,
          reversals: reversals,
          pixelLimitEncountered: false,
        );

        expect(result.eyeSide, equals(EyeSide.right));
        expect(result.testMode, equals(TestMode.isolated));
        expect(result.estimatedLogMar, equals(0.25));
        expect(result.totalQuestions, equals(2));
        expect(result.correctQuestions, equals(1));
        expect(result.accuracy, equals(0.5));
        expect(result.meanResponseTimeMs, equals(1750));
        expect(result.pixelLimitEncountered, isFalse);
      });

      test('should recommend retest when std dev is high', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.1,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.5,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final result = StaircaseEstimator.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.isolated,
          questions: [],
          reversals: reversals,
          pixelLimitEncountered: false,
        );

        expect(result.retestRecommended, isTrue);
      });

      test('should not recommend retest when std dev is low', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.25,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 1,
            logMar: 0.25,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final result = StaircaseEstimator.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.crowded,
          questions: [],
          reversals: reversals,
          pixelLimitEncountered: false,
        );

        expect(result.testMode, equals(TestMode.crowded));
        expect(result.retestRecommended, isFalse);
      });

      test('should handle empty questions', () {
        final reversals = [
          const ReversalPoint(
            questionIndex: 0,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
        ];

        final result = StaircaseEstimator.buildEyeTestResult(
          eyeSide: EyeSide.left,
          testMode: TestMode.isolated,
          questions: [],
          reversals: reversals,
          pixelLimitEncountered: false,
        );

        expect(result.totalQuestions, equals(0));
        expect(result.correctQuestions, equals(0));
        expect(result.accuracy, equals(0));
        expect(result.meanResponseTimeMs, equals(0));
      });

      test('should use confirmed best line when reversals are absent', () {
        final now = DateTime.now();
        final questions = [
          for (var index = 0; index < 3; index++)
            QuestionRecord(
              index: index,
              eyeSide: EyeSide.right,
              testMode: TestMode.isolated,
              targetLogMar: 0.4,
              targetDecimalAcuity: 0.4,
              targetFivePointAcuity: 4.6,
              displayedDirection: OptotypeDirection.up,
              userAnswer: OptotypeDirection.up,
              isCorrect: true,
              isTimeout: false,
              responseTimeMs: 1500,
              renderMetrics: const RenderMetrics(
                testDistanceMm: 4000,
                optotypeSizeMm: 8,
                detailSizeMm: 1.6,
                optotypeWidthPx: 24,
                optotypeHeightPx: 24,
                detailWidthPx: 4.8,
                detailHeightPx: 4.8,
                criticalDetailPx: 4.8,
                pixelLimitReached: false,
              ),
              shownAt: now,
              answeredAt: now,
            ),
          for (var index = 3; index < 6; index++)
            QuestionRecord(
              index: index,
              eyeSide: EyeSide.right,
              testMode: TestMode.isolated,
              targetLogMar: 0.3,
              targetDecimalAcuity: 0.5,
              targetFivePointAcuity: 4.7,
              displayedDirection: OptotypeDirection.left,
              userAnswer: OptotypeDirection.left,
              isCorrect: true,
              isTimeout: false,
              responseTimeMs: 1500,
              renderMetrics: const RenderMetrics(
                testDistanceMm: 4000,
                optotypeSizeMm: 7,
                detailSizeMm: 1.4,
                optotypeWidthPx: 21,
                optotypeHeightPx: 21,
                detailWidthPx: 4.2,
                detailHeightPx: 4.2,
                criticalDetailPx: 4.2,
                pixelLimitReached: false,
              ),
              shownAt: now,
              answeredAt: now,
            ),
        ];

        final result = StaircaseEstimator.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.isolated,
          questions: questions,
          reversals: const [],
          pixelLimitEncountered: false,
        );

        expect(result.estimatedLogMar, equals(0.3));
      });

      test('should not report worse than the best confirmed line after one bad reversal', () {
        final now = DateTime.now();
        final questions = [
          for (var index = 0; index < 5; index++)
            QuestionRecord(
              index: index,
              eyeSide: EyeSide.right,
              testMode: TestMode.isolated,
              targetLogMar: 0.3,
              targetDecimalAcuity: 0.5,
              targetFivePointAcuity: 4.7,
              displayedDirection: OptotypeDirection.up,
              userAnswer: index == 4 ? OptotypeDirection.left : OptotypeDirection.up,
              isCorrect: index < 4,
              isTimeout: false,
              responseTimeMs: 1500,
              renderMetrics: const RenderMetrics(
                testDistanceMm: 4000,
                optotypeSizeMm: 7,
                detailSizeMm: 1.4,
                optotypeWidthPx: 21,
                optotypeHeightPx: 21,
                detailWidthPx: 4.2,
                detailHeightPx: 4.2,
                criticalDetailPx: 4.2,
                pixelLimitReached: false,
              ),
              shownAt: now,
              answeredAt: now,
            ),
        ];
        final reversals = [
          const ReversalPoint(
            questionIndex: 4,
            logMar: 0.3,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 5,
            logMar: 0.4,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
          const ReversalPoint(
            questionIndex: 6,
            logMar: 0.4,
            previousDirection: StepDirection.up,
            currentDirection: StepDirection.down,
          ),
          const ReversalPoint(
            questionIndex: 7,
            logMar: 0.4,
            previousDirection: StepDirection.down,
            currentDirection: StepDirection.up,
          ),
        ];

        final result = StaircaseEstimator.buildEyeTestResult(
          eyeSide: EyeSide.right,
          testMode: TestMode.isolated,
          questions: questions,
          reversals: reversals,
          pixelLimitEncountered: false,
        );

        expect(result.estimatedLogMar, equals(0.3));
      });
    });

    group('integration scenarios', () {
      test('should simulate complete test session', () {
        var state = StaircaseEstimator.initialState(config);

        final answers = [
          true, true, true,
          false,
          true, true, true,
          false,
          true, true, true,
          false,
          true, true, true,
          false,
          true, true, true,
          false,
          true, true, true,
          false,
        ];

        for (var i = 0; i < answers.length; i++) {
          state = StaircaseEstimator.applyAnswer(
            state: state,
            config: config,
            isCorrect: answers[i],
            questionIndex: i,
          );
        }

        expect(state.reversals.length, equals(11));
        expect(state.thresholdReached, isTrue);

        final threshold = StaircaseEstimator.estimateThresholdLogMar(
          state.reversals,
        );
        expect(threshold, greaterThan(0));
      });

      test('should handle alternating pattern correctly', () {
        var state = StaircaseEstimator.initialState(config);

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 0,
        );
        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 1,
        );
        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 2,
        );
        expect(state.currentLogMar, equals(0.4));

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: false,
          questionIndex: 3,
        );
        expect(state.currentLogMar, equals(0.5));
        expect(state.reversals.length, equals(1));

        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 4,
        );
        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 5,
        );
        state = StaircaseEstimator.applyAnswer(
          state: state,
          config: config,
          isCorrect: true,
          questionIndex: 6,
        );
        expect(state.currentLogMar, equals(0.4));
        expect(state.reversals.length, equals(2));
      });
    });
  });
}
