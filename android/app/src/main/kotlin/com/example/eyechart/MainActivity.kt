package com.example.eyechart

import android.os.Build
import android.util.DisplayMetrics
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.sqrt

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "eyechart/device_info"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceInfo" -> {
                    result.success(
                        mapOf(
                            "deviceName" to buildDeviceName(),
                            "screenDiagonalInches" to calculateScreenDiagonalInches()
                        )
                    )
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun buildDeviceName(): String {
        val manufacturer = Build.MANUFACTURER.trim()
        val model = Build.MODEL.trim()

        if (model.startsWith(manufacturer, ignoreCase = true)) {
            return model
        }

        return "$manufacturer $model".trim()
    }

    private fun calculateScreenDiagonalInches(): Double {
        val metrics = DisplayMetrics()
        @Suppress("DEPRECATION")
        windowManager.defaultDisplay.getRealMetrics(metrics)

        if (metrics.xdpi <= 0 || metrics.ydpi <= 0) {
            return 0.0
        }

        val widthInches = metrics.widthPixels / metrics.xdpi.toDouble()
        val heightInches = metrics.heightPixels / metrics.ydpi.toDouble()

        if (widthInches <= 0 || heightInches <= 0) {
            return 0.0
        }

        return sqrt(widthInches * widthInches + heightInches * heightInches)
    }
}
