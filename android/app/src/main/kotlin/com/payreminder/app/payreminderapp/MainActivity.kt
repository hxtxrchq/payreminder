package com.payreminder.app.payreminderapp

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity: FlutterActivity() {
	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "payreminder/timezone")
			.setMethodCallHandler { call, result ->
				if (call.method == "getLocalTimezone") {
					try {
						val tzId = TimeZone.getDefault().id
						result.success(tzId)
					} catch (e: Exception) {
						result.error("TZ_ERROR", e.message, null)
					}
				} else {
					result.notImplemented()
				}
			}
	}
}
