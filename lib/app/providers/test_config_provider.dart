import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vision/domain/vision_enums.dart';
import '../../vision/domain/vision_models.dart';

class TestConfigState {
  final double testDistanceMm;
  final EyeSide eyeSide;
  final TestMode testMode;
  final InputMode inputMode;
  final double startLogMar;
  final double minCriticalDetailPx;
  final bool isValid;

  const TestConfigState({
    this.testDistanceMm = 400.0,
    this.eyeSide = EyeSide.both,
    this.testMode = TestMode.isolated,
    this.inputMode = InputMode.touchButtons,
    this.startLogMar = 0.5,
    this.minCriticalDetailPx = 1.0,
    this.isValid = true,
  });

  TestConfigState copyWith({
    double? testDistanceMm,
    EyeSide? eyeSide,
    TestMode? testMode,
    InputMode? inputMode,
    double? startLogMar,
    double? minCriticalDetailPx,
    bool? isValid,
  }) {
    return TestConfigState(
      testDistanceMm: testDistanceMm ?? this.testDistanceMm,
      eyeSide: eyeSide ?? this.eyeSide,
      testMode: testMode ?? this.testMode,
      inputMode: inputMode ?? this.inputMode,
      startLogMar: startLogMar ?? this.startLogMar,
      minCriticalDetailPx: minCriticalDetailPx ?? this.minCriticalDetailPx,
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
      // 新版测试参数
      optotypesPerLine: 5,
      consecutiveCorrectToPass: 3,  // 前3题全对快速通过
      consecutiveWrongToFail: 2,    // 连续2错快速失败
      maxErrorsPerLine: 1,          // 完整测试时错误数≤1通过
      requiredLineReversals: 3,     // 3次下行→上行反转终止
      maxQuestionCount: 999,        // 不设上限
      answerTimeLimitMs: 3000,
      minCriticalDetailPx: minCriticalDetailPx,
      enableEnvironmentCheck: true,
      enablePixelLimitProtection: true,
    );
  }
}

class TestConfigNotifier extends StateNotifier<TestConfigState> {
  TestConfigNotifier() : super(const TestConfigState());

  void setTestDistance(double distanceMm) {
    final isValid = distanceMm >= 200 && distanceMm <= 1000;
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

  void setMinCriticalDetailPx(double minCriticalDetailPx) {
    state = state.copyWith(minCriticalDetailPx: minCriticalDetailPx);
  }

  void reset() {
    state = const TestConfigState();
  }
}

final testConfigProvider =
    StateNotifierProvider<TestConfigNotifier, TestConfigState>(
  (ref) => TestConfigNotifier(),
);
