package com.example.clevertap_flutter_integration

import android.annotation.SuppressLint
import android.app.NotificationManager
import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.os.Bundle
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.pushnotification.CTPushNotificationListener
//import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.PluginRegistry
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
//import io.flutter.view.FlutterMain
import java.util.*
import android.util.Log
import com.clevertap.android.sdk.inapp.CTLocalInApp
import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import com.clevertap.android.pushtemplates.PTConstants
import com.clevertap.android.sdk.CTInboxListener
import com.clevertap.android.sdk.CTInboxStyleConfig
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    var cleverTapDefaultInstance: CleverTapAPI? = null
    private val CHANNEL = "customAppInbox"
    private val ANDROID_SP_CHANNEL = "android_shared_preferences"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        cleverTapDefaultInstance = CleverTapAPI.getDefaultInstance(applicationContext)

//        val preferences = applicationContext.getSharedPreferences("WizRocket", MODE_PRIVATE)
//        val allEntries = preferences.all
//        for ((key, value) in allEntries) {
//            Log.d("SharedPreferences", "$key: $value")
//        }



    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // CleverTapAPI.getDefaultInstance(this)?.pushNotificationClickedEvent(intent!!.extras)
            cleverTapDefaultInstance?.pushNotificationClickedEvent(intent!!.extras)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            NotificationUtils.dismissNotification(intent, applicationContext)
        }
    }

    @SuppressLint("LongLogTag")
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "launchURL") {
                val url = call.argument<String>("url")
                if (url != null) {
                    try {
                        val intent = Intent(Intent.ACTION_VIEW).setClassName(
                            packageName,
                            "com.example.clevertap_flutter_integration.MainActivity"
                        )
                        intent.data = Uri.parse(url)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                } else {
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }

        val preferences = applicationContext.getSharedPreferences("WizRocket", MODE_PRIVATE)
        val editor = preferences.edit()
        editor.putString("sample_key", "sample_value")
        editor.putInt("sample_int", 42)
        editor.apply()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ANDROID_SP_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getPreferences") {
                val preferences = applicationContext.getSharedPreferences("WizRocket", MODE_PRIVATE)
                val allEntries: Map<String, *> = preferences.all

                // Log the entries to confirm they exist
                for ((key, value) in allEntries) {
                    Log.d("SharedPreferences Android:", "$key: $value")
                }

                // Pass data to Flutter
                val prefsMap = HashMap<String, Any?>()
                for ((key, value) in allEntries) {
                    prefsMap[key] = value
                }
                result.success(prefsMap)
            } else {
                result.notImplemented()
            }
        }

    }

    override fun onResume() {
        super.onResume()

//        val builder = CTLocalInApp.builder()
//            .setInAppType(CTLocalInApp.InAppType.ALERT)
//            .setTitleText("Get Notified")
//            .setMessageText("Enable Notification permission")
//            .followDeviceOrientation(true)
//            .setPositiveBtnText("Allow")
//            .setNegativeBtnText("Cancel")
//            .build()
//        cleverTapDefaultInstance?.promptPushPrimer(builder)
    }
}

object NotificationUtils {

    //Require to close notification on action button click
    fun dismissNotification(intent: Intent?, applicationContext: Context) {
        intent?.extras?.apply {
            var autoCancel = true
            var notificationId = -1

            getString("actionId")?.let {
                Log.d("ACTION_ID", it)
                autoCancel = getBoolean("autoCancel", true)
                notificationId = getInt("notificationId", -1)
            }
            /**
             * If using InputBox template, add ptDismissOnClick flag to not dismiss notification
             * if pt_dismiss_on_click is false in InputBox template payload. Alternatively if normal
             * notification is raised then we dismiss notification.
             */
            val ptDismissOnClick =
                intent.extras!!.getString(PTConstants.PT_DISMISS_ON_CLICK, "")

            if (autoCancel && notificationId > -1 && ptDismissOnClick.isNullOrEmpty()) {
                val notifyMgr: NotificationManager =
                    applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notifyMgr.cancel(notificationId)
            }
        }
    }
}
