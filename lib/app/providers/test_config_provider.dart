import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vision/domain/vision_enums.dart';
import '../../vision/domain/vision_models.dart';

class TestConfigState {
  final double testDistanceMm;
  final EyeSide eyeSide;
  final TestMode testMode;
  final InputMode inputMode;
  final double startLogMar;
  final bool isValid;

  const TestConfigState({
    this.testDistanceMm = 5000.0,
    this.eyeSide = EyeSide.both,
    this.testMode = TestMode.isolated,
    this.inputMode = InputMode.touchButtons,
    this.startLogMar = 0.5,
    this.isValid = true,
  });

  TestConfigState copyWith({
    double? testDistanceMm,
    EyeSide? eyeSide,
    TestMode? testMode,
    InputMode? inputMode,
    double? startLogMar,
    bool? isValid,
  }) {
    return TestConfigState(
      testDistanceMm: testDistanceMm ?? this.testDistanceMm,
      eyeSide: eyeSide ?? this.eyeSide,
      testMode: testMode ?? this.testMode,
      inputMode: inputMode ?? this.inputMode,
      startLogMar: startLogMar ?? this.startLogMar,
      isValid: isValid ?? this.isValid,
    );
  }

  TestConfig toTestConfig() {
    return TestConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eyeSide: eyeSide,
      testMode: testMode,
      inputMode: inputMode,
      testDistanceMm: testDistanceMm,
      startLogMar: startLogMar,
      minLogMar: -0.3,
      maxLogMar: 1.0,
      stepLogMar: 0.1,
      requiredCorrectForStepDown: 3,
      allowedWrongForStepUp: 1,
      requiredReversalCount: 3,
      maxQuestionCount: 30,
      answerTimeLimitMs: 10000,
      minCriticalDetailPx: 2.0,
      enableEnvironmentCheck: true,
      enablePixelLimitProtection: true,
    );
  }
}

class TestConfigNotifier extends StateNotifier<TestConfigState> {
  TestConfigNotifier() : super(const TestConfigState());

  void setTestDistance(double distanceMm) {
    final isValid = distanceMm >= 1000 && distanceMm <= 10000;
    state = state.copyWith(
      testDistanceMm: distanceMm,
      isValid: isValid,
    );
  }

  void setEyeSide(EyeSide eyeSide) {
    state = state.copyWith(eyeSide: eyeSide);
  }

  void setTestMode(TestMode testMode) {
    state = state.copyWith(testMode: testMode);
  }

  void setInputMode(InputMode inputMode) {
    state = state.copyWith(inputMode: inputMode);
  }

  void setStartLogMar(double logMar) {
    state = state.copyWith(startLogMar: logMar);
  }

  void reset() {
    state = const TestConfigState();
  }
}

final testConfigProvider =
    StateNotifierProvider<TestConfigNotifier, TestConfigState>(
  (ref) => TestConfigNotifier(),
);
