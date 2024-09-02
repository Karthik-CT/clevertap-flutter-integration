package com.example.clevertap_flutter_integration

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.clevertap.android.sdk.CleverTapAPI
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.android.awaitFrame
import android.net.Uri

class FlutterScreenActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("FlutterScreenActivity is called")
    }

    override fun getDartEntrypointFunctionName(): String {
        return "main" // Make sure this matches the function in `ui2.dart`
    }

    //Intial route is used to navigate to the page
    override fun getInitialRoute(): String? {
        val action = intent.action
        val data: Uri? = intent.data

        if (intent.hasExtra("wzrk_pn")) {
            return "$data"
        } else {
            return "$data?isinbox=true"
        }
//        return "page1"
    }
}