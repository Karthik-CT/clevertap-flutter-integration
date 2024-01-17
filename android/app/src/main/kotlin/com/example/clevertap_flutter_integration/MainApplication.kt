package com.example.clevertap_flutter_integration

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import android.content.Context
import android.util.Log
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.pushnotification.CTPushNotificationListener
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.view.FlutterMain
import java.util.*
import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.app.NotificationManager
import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.clevertap.android.pushtemplates.PTConstants
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import com.clevertap.android.pushtemplates.PushTemplateNotificationHandler
import com.clevertap.android.sdk.interfaces.NotificationHandler

// class MainApplication : Application(), CTPushNotificationListener{
class MainApplication : Application(), Application.ActivityLifecycleCallbacks {

    var channel: MethodChannel? = null
    private val CHANNEL = "myChannel"
    private lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        registerActivityLifecycleCallbacks(this)
        super.onCreate()

        //Tentative solution to solve killed state issue for notification click callback.
        // flutterEngine = FlutterEngine(this)
        // flutterEngine.dartExecutor.executeDartEntrypoint(
        //     DartEntrypoint.createDefault()
        // )


        // CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.DEBUG);
        CleverTapAPI.setDebugLevel(3);
//        CleverTapAPI.createNotificationChannelGroup(this, "YourGroupId", "YourGroupName")
        CleverTapAPI.createNotificationChannel(
            applicationContext,
            "testkk123",
            "test",
            "test",
            NotificationManager.IMPORTANCE_MAX,
            true,
            "notificationsound1.mp3"
        )

        CleverTapAPI.setNotificationHandler(PushTemplateNotificationHandler() as NotificationHandler);
        
        // val cleverTapAPI = CleverTapAPI.getDefaultInstance(applicationContext)
        // cleverTapAPI!!.ctPushNotificationListener = this
    }

    fun GetMethodChannel(context: Context, r: Map<String, Any>) {
        FlutterMain.startInitialization(context)
        FlutterMain.ensureInitializationComplete(context, arrayOfNulls(0))
        val engine = FlutterEngine(context.applicationContext)
        val entrypoint = DartExecutor.DartEntrypoint("lib/home.dart", "main")
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

    override fun onActivityCreated(p0: Activity, p1: Bundle?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val intent = p0.intent
            NotificationUtils.dismissNotification(intent, applicationContext)
        }
    }

    override fun onActivityStarted(p0: Activity) {
    }

    override fun onActivityResumed(p0: Activity) {
    }

    override fun onActivityPaused(p0: Activity) {
    }

    override fun onActivityStopped(p0: Activity) {
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
    }

    override fun onActivityDestroyed(p0: Activity) {
    }

    // override fun onNotificationClickedPayloadReceived(payload: HashMap<String, Any>?) {
    //     Log.d("workedLLLL", payload.toString())
    //     GetMethodChannel(this, payload!!)
    // }

}

