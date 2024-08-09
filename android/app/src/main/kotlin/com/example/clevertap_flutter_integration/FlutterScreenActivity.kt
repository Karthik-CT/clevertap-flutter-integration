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

class FlutterScreenActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun getDartEntrypointFunctionName(): String {
        return "main" // Make sure this matches the function in `ui2.dart`
    }

    //Intial route is used to navigate to the page
    override fun getInitialRoute(): String? {
        return "page1"
    }
}