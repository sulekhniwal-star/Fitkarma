package com.sulekhniwal.fitkarma

import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "fitkarma.healthos/thermal"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getThermalHeadroom") {
                val powerManager = getSystemService(POWER_SERVICE) as PowerManager
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                    result.success(powerManager.getThermalHeadroom(10))
                } else {
                    result.success(0.0)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

