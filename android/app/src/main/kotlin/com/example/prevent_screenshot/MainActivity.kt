/*
 * android/app/src/main/kotlin/com/example/prevent_screenshot/MainActivity.kt
 */

package com.example.prevent_screenshot

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // Define the method channel name
    private val methodChannelName = "com.example.prevent_screenshot/screenshot"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up the method channel to handle method calls
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableSecure" -> {
                        enableSecure()
                        result.success(null)
                    }
                    "disableSecure" -> {
                        disableSecure()
                        result.success(null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    /**
     * Enable screenshot protection by setting FLAG_SECURE on the window.
     */
    private fun enableSecure() {
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }

    /**
     * Disable screenshot protection by clearing FLAG_SECURE from the window.
     */
    private fun disableSecure() {
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
