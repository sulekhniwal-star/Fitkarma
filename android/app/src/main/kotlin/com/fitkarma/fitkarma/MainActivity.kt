package com.fitkarma.fitkarma

import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// §P6-F Adaptive Computer Vision Loop — Android ADPF Thermal Bridge
// Registers MethodChannel('fitkarma.healthos/thermal') to expose
// PowerManager.getThermalHeadroom(10) to the Flutter ACVL engine.
class MainActivity : FlutterActivity() {
    private val thermalChannel = "fitkarma.healthos/thermal"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            thermalChannel
        ).setMethodCallHandler { call, result ->
            if (call.method == "getThermalHeadroom") {
                val powerManager = getSystemService(POWER_SERVICE) as PowerManager
                // Poll the thermal headroom projection 10 seconds into the future
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                    result.success(powerManager.getThermalHeadroom(10))
                } else {
                    result.success(0.0) // Fallback for pre-Android 11 devices
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
