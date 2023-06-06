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
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.view.FlutterMain
import java.util.*
import android.util.Log

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import com.clevertap.android.sdk.CTInboxListener
import com.clevertap.android.sdk.CTInboxStyleConfig
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    var cleverTapDefaultInstance: CleverTapAPI? = null

   override fun onCreate(savedInstanceState: Bundle?) {
       super.onCreate(savedInstanceState)
    //    CleverTapAPI.getDefaultInstance(this)?.apply {
            
    //         // ctNotificationInboxListener = this@MainActivity
            
    //         //Initialize the inbox and wait for callbacks on overridden methods
    //         // initializeInbox()
    //     }



    cleverTapDefaultInstance = CleverTapAPI.getDefaultInstance(applicationContext)
   }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // CleverTapAPI.getDefaultInstance(this)?.pushNotificationClickedEvent(intent!!.extras)
            cleverTapDefaultInstance?.pushNotificationClickedEvent(intent!!.extras)
        }
    }

    // override fun inboxDidInitialize() {
    //         val tabs: ArrayList<String> = ArrayList()
    //         tabs.add("Promotions")
    //         tabs.add("Offers") //We support upto 2 tabs only. Additional tabs will be ignored
    //         val styleConfig = CTInboxStyleConfig()
    //         styleConfig.firstTabTitle = "First Tab"
    //         styleConfig.tabs = tabs //Do not use this if you don't want to use tabs
    //         styleConfig.tabBackgroundColor = "#FF0000"
    //         styleConfig.selectedTabIndicatorColor = "#0000FF"
    //         styleConfig.selectedTabColor = "#0000FF"
    //         styleConfig.unselectedTabColor = "#FFFFFF"
    //         styleConfig.backButtonColor = "#FF0000"
    //         styleConfig.navBarTitleColor = "#FF0000"
    //         styleConfig.navBarTitle = "MY INBOX"
    //         styleConfig.navBarColor = "#FFFFFF"
    //         styleConfig.inboxBackgroundColor = "#ADD8E6"
    //         CleverTapAPI.getDefaultInstance(this)?.showAppInbox(styleConfig)
    // }

    // override fun inboxMessagesDidUpdate() {
    // }
}
