import 'dart:ffi';
import 'dart:ui';
import 'package:ffi/ffi.dart';
import 'platform_display.dart';

final class RECT extends Struct {
  @Int32()
  external int left;
  @Int32()
  external int top;
  @Int32()
  external int right;
  @Int32()
  external int bottom;
}

final class MONITORINFOEX extends Struct {
  @Uint32()
  external int cbSize;
  external RECT rcMonitor;
  external RECT rcWork;
  @Uint32()
  external int dwFlags;
  @Array(32)
  external Array<Uint8> szDevice;
}

typedef GetDpiForMonitorNative = Int32 Function(
  IntPtr hmonitor, Int32 dpiType, Pointer<Uint32> dpiX, Pointer<Uint32> dpiY);
typedef GetDpiForMonitorDart = int Function(
    int hmonitor, int dpiType, Pointer<Uint32> dpiX, Pointer<Uint32> dpiY);

typedef MonitorFromWindowNative = IntPtr Function(IntPtr hwnd, Int32 dwFlags);
typedef MonitorFromWindowDart = int Function(int hwnd, int dwFlags);

typedef GetWindowDpiNative = Uint32 Function(IntPtr hwnd);
typedef GetWindowDpiDart = int Function(int hwnd);

typedef GetDCNative = IntPtr Function(IntPtr hwnd);
typedef GetDCDart = int Function(int hwnd);

typedef ReleaseDCNative = Int32 Function(IntPtr hwnd, IntPtr hdc);
typedef ReleaseDCDart = int Function(int hwnd, int hdc);

typedef GetDeviceCapsNative = Int32 Function(IntPtr hdc, Int32 nIndex);
typedef GetDeviceCapsDart = int Function(int hdc, int nIndex);

class WindowsDisplayService implements PlatformDisplayService {
  double _physicalWidth = 0;
  double _physicalHeight = 0;
  double _devicePixelRatio = 1.0;
  double _systemScaleFactor = 1.0;
  double _rawDpi = 96.0;
  bool _initialized = false;
  DisplayInfo? _displayInfo;

  static const int mdtEffectiveDpi = 0;
  static const int mdtAngularDpi = 1;
  static const int mdtRawDpi = 2;
  static const int monitorDefaultToNearest = 2;
  static const int logPixelsX = 88;
  static const int logPixelsY = 90;

  DynamicLibrary? _user32;
  DynamicLibrary? _gdi32;
  GetDpiForMonitorDart? _getDpiForMonitor;
  MonitorFromWindowDart? _monitorFromWindow;
  GetWindowDpiDart? _getWindowDpi;
  GetDCDart? _getDC;
  ReleaseDCDart? _releaseDC;
  GetDeviceCapsDart? _getDeviceCaps;

  void _loadLibraries() {
    _user32 ??= DynamicLibrary.open('user32.dll');
    _gdi32 ??= DynamicLibrary.open('gdi32.dll');

    _getDpiForMonitor ??= _user32!.lookupFunction<GetDpiForMonitorNative, GetDpiForMonitorDart>(
        'GetDpiForMonitor');
    _monitorFromWindow ??= _user32!.lookupFunction<MonitorFromWindowNative, MonitorFromWindowDart>(
        'MonitorFromWindow');
    _getWindowDpi ??= _user32!.lookupFunction<GetWindowDpiNative, GetWindowDpiDart>(
        'GetWindowDpi');
    _getDC ??= _user32!.lookupFunction<GetDCNative, GetDCDart>('GetDC');
    _releaseDC ??= _user32!.lookupFunction<ReleaseDCNative, ReleaseDCDart>('ReleaseDC');
    _getDeviceCaps ??= _gdi32!.lookupFunction<GetDeviceCapsNative, GetDeviceCapsDart>(
        'GetDeviceCaps');
  }

  @override
  double get physicalWidth => _physicalWidth;

  @override
  double get physicalHeight => _physicalHeight;

  @override
  double get logicalWidth => _physicalWidth / _devicePixelRatio;

  @override
  double get logicalHeight => _physicalHeight / _devicePixelRatio;

  @override
  double get devicePixelRatio => _devicePixelRatio;

  @override
  double get systemScaleFactor => _systemScaleFactor;

  @override
  double get dpi => _rawDpi * _systemScaleFactor;

  @override
  double get rawDpi => _rawDpi;

  @override
  bool get isHighDpi => _devicePixelRatio > 1.5 || _systemScaleFactor > 1.25;

  @override
  DisplayInfo get displayInfo => _displayInfo ?? const DisplayInfo(
        physicalWidthMm: 0,
        physicalHeightMm: 0,
        diagonalInches: 0,
      );

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    _loadLibraries();

    final dispatcher = PlatformDispatcher.instance;
    final display = dispatcher.displays.first;
    
    _devicePixelRatio = display.devicePixelRatio;
    
    final size = display.size;
    _physicalWidth = size.width * _devicePixelRatio;
    _physicalHeight = size.height * _devicePixelRatio;

    _initializeDpi();

    _initialized = true;
  }

  void _initializeDpi() {
    try {
      final hwnd = _getWindowHandle();
      if (hwnd != 0) {
        final monitor = _monitorFromWindow!(hwnd, monitorDefaultToNearest);
        
        final dpiX = calloc<Uint32>();
        final dpiY = calloc<Uint32>();
        
        try {
          final result = _getDpiForMonitor!(monitor, mdtEffectiveDpi, dpiX, dpiY);
          if (result == 0) {
            final effectiveDpi = dpiX.value.toDouble();
            _systemScaleFactor = effectiveDpi / 96.0;
          }

          final rawResult = _getDpiForMonitor!(monitor, mdtRawDpi, dpiX, dpiY);
          if (rawResult == 0) {
            _rawDpi = dpiX.value.toDouble();
          }
        } finally {
          calloc.free(dpiX);
          calloc.free(dpiY);
        }
      } else {
        _initializeDpiFallback();
      }
    } catch (e) {
      _initializeDpiFallback();
    }
  }

  void _initializeDpiFallback() {
    try {
      final hdc = _getDC!(0);
      if (hdc != 0) {
        final dpiX = _getDeviceCaps!(hdc, logPixelsX);
        _getDeviceCaps!(hdc, logPixelsY);
        _rawDpi = dpiX.toDouble();
        _systemScaleFactor = _rawDpi / 96.0;
        _releaseDC!(0, hdc);
      }
    } catch (e) {
      _rawDpi = 96.0;
      _systemScaleFactor = 1.0;
    }
  }

  int _getWindowHandle() {
    try {
      final hwnd = _getWindowDpi!(0);
      return hwnd;
    } catch (e) {
      return 0;
    }
  }

  @override
  void dispose() {
    _initialized = false;
    _displayInfo = null;
  }

  double getCorrectedPixelRatio() {
    return _devicePixelRatio * _systemScaleFactor;
  }

  double pixelsToPhysical(double logicalPixels) {
    return logicalPixels * getCorrectedPixelRatio();
  }

  double physicalToPixels(double physicalPixels) {
    return physicalPixels / getCorrectedPixelRatio();
  }
}
