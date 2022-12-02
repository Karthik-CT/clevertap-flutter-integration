package com.example.integration_sdk_test

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.os.Bundle
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.pushnotification.CTPushNotificationListener
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.view.FlutterMain
import java.util.*
import android.util.Log

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity

class MainActivity : FlutterActivity() {
//
   override fun onCreate(savedInstanceState: Bundle?) {
       super.onCreate(savedInstanceState)
   }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            CleverTapAPI.getDefaultInstance(this)?.pushNotificationClickedEvent(intent!!.extras)
        }

    }
}
