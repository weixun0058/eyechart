import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FullscreenState {
  windowed,
  fullscreen,
  transitioning,
}

class FullscreenService {
  FullscreenState _state = FullscreenState.windowed;
  bool _isStable = true;

  FullscreenState get state => _state;
  bool get isFullscreen => _state == FullscreenState.fullscreen;
  bool get isStable => _isStable;

  Future<bool> enterFullscreen() async {
    if (_state == FullscreenState.fullscreen) {
      return true;
    }

    if (_state == FullscreenState.transitioning) {
      return false;
    }

    _state = FullscreenState.transitioning;
    _isStable = false;

    try {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        await SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
          if (systemOverlaysAreVisible == true && _state == FullscreenState.fullscreen) {
            await _reapplyFullscreen();
          }
        });
      }

      _state = FullscreenState.fullscreen;
      _isStable = true;
      return true;
    } catch (e) {
      _state = FullscreenState.windowed;
      _isStable = true;
      return false;
    }
  }

  Future<bool> exitFullscreen() async {
    if (_state == FullscreenState.windowed) {
      return true;
    }

    if (_state == FullscreenState.transitioning) {
      return false;
    }

    _state = FullscreenState.transitioning;
    _isStable = false;

    try {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      await SystemChrome.setSystemUIChangeCallback(null);

      _state = FullscreenState.windowed;
      _isStable = true;
      return true;
    } catch (e) {
      _state = FullscreenState.fullscreen;
      _isStable = true;
      return false;
    }
  }

  Future<bool> toggleFullscreen() async {
    if (_state == FullscreenState.fullscreen) {
      return await exitFullscreen();
    } else {
      return await enterFullscreen();
    }
  }

  Future<void> _reapplyFullscreen() async {
    if (_state != FullscreenState.fullscreen) return;

    try {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );
    } catch (e) {
      // Ignore errors during reapplication
    }
  }

  Future<void> ensureFullscreenState(bool shouldBeFullscreen) async {
    if (shouldBeFullscreen && _state != FullscreenState.fullscreen) {
      await enterFullscreen();
    } else if (!shouldBeFullscreen && _state == FullscreenState.fullscreen) {
      await exitFullscreen();
    }
  }

  void dispose() {
    SystemChrome.setSystemUIChangeCallback(null);
    _state = FullscreenState.windowed;
    _isStable = true;
  }
}

final fullscreenServiceProvider = Provider<FullscreenService>((ref) {
  final service = FullscreenService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isFullscreenProvider = StateProvider<bool>((ref) {
  return false;
});
