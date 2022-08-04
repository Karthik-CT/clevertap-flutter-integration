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

class MainActivity : FlutterActivity() {

//    var channel: MethodChannel? = null
//    private val CHANNEL = "myChannel"
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        val flutterEngine = FlutterEngine(this)
//        channel = MethodChannel(flutterEngine.getDartExecutor(), "myChannel")
//
//
//
//
////        val cleverTapAPI = CleverTapAPI.getDefaultInstance(applicationContext)
////        cleverTapAPI!!.ctPushNotificationListener = CTPushNotificationListener { payload ->
////            Log.d("worked", payload.toString())
////            GetMethodChannel(this, payload!!)
////        }
////        Log.d("CTpushListener", cleverTapAPI!!.ctPushNotificationListener.toString())
//    }
//
//    fun GetMethodChannel(context: Context, r: Map<String, Any>) {
//        FlutterMain.startInitialization(context)
//        FlutterMain.ensureInitializationComplete(context, arrayOfNulls(0))
//        val engine = FlutterEngine(context.applicationContext)
//        val entrypoint = DartExecutor.DartEntrypoint("lib/main.dart", "main")
//        engine.dartExecutor.executeDartEntrypoint(entrypoint)
//
//        MethodChannel(
//            engine.dartExecutor.binaryMessenger,
//            CHANNEL
//        ).invokeMethod("onPushNotificationClicked", r,
//            object : MethodChannel.Result {
//                override fun success(o: Any?) {
//                    Log.d("Results", o.toString())
//                }
//
//                override fun error(s: String, s1: String?, o: Any?) {
//                    Log.d("No result as error", o.toString())
//                }
//
//                override fun notImplemented() {
//
//                    Log.d("No result as error", "cant find ")
//                }
//            })
//    }
}
