package com.example.integration_sdk_test

import android.content.Context
import android.util.Log
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
import android.annotation.SuppressLint
import android.app.Application
import android.app.NotificationManager
import android.content.Intent
import android.os.Build

class MainApplication : Application(), CTPushNotificationListener {

    var channel: MethodChannel? = null
    private val CHANNEL = "myChannel"

    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        super.onCreate()

        // CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.DEBUG);
        CleverTapAPI.setDebugLevel(3);
        CleverTapAPI.createNotificationChannelGroup(this, "YourGroupId", "YourGroupName")
        CleverTapAPI.createNotificationChannel(
            applicationContext,
            "testkk123",
            "test",
            "test",
            NotificationManager.IMPORTANCE_MAX,
            true
        )
        val cleverTapAPI = CleverTapAPI.getDefaultInstance(applicationContext)
        cleverTapAPI!!.ctPushNotificationListener = this
    }

    fun GetMethodChannel(context: Context, r: Map<String, Any>) {
        FlutterMain.startInitialization(context)
        FlutterMain.ensureInitializationComplete(context, arrayOfNulls(0))
        val engine = FlutterEngine(context.applicationContext)
        val entrypoint = DartExecutor.DartEntrypoint("lib/main.dart", "main")
        engine.dartExecutor.executeDartEntrypoint(entrypoint)

        MethodChannel(
            engine.dartExecutor.binaryMessenger,
            CHANNEL
        ).invokeMethod("onPushNotificationClicked", r,
            object : MethodChannel.Result {
                override fun success(o: Any?) {
                    Log.d("Results", o.toString())
                }

                override fun error(s: String, s1: String?, o: Any?) {
                    Log.d("No result as error", o.toString())
                }

                override fun notImplemented() {
                    Log.d("No result as error", "cant find ")
                }
            })
    }

    override fun onNotificationClickedPayloadReceived(payload: HashMap<String, Any>?) {
        Log.d("worked", payload.toString())
        GetMethodChannel(this, payload!!)
    }

}