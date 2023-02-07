// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  late CleverTapPlugin _clevertapPlugin;
  //for killed state notification clicked
  static const platform = MethodChannel("myChannel");
  var inboxInitialized = false;
  var optOut = false;
  var offLine = false;
  var enableDeviceNetworkingInfo = false;

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen())));

    CleverTapPlugin.setDebugLevel(3);
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.createNotificationChannel(
        "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);
    platform.setMethodCallHandler(nativeMethodCallHandler);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = CleverTapPlugin();

    //Handler for receiving Push Clicked Payload in FG and BG state
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
  }

  //For Push Notification Clicked Payload in FG and BG state
  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    debugPrint("pushClickedPayloadReceived called");
    this.setState(() async {
      var data = jsonEncode(map);
      debugPrint("on Push Click Payload = $data");
    });
  }

  //For Push Notification Clicked Payload in killed state
  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    // Future.delayed(Duration(seconds: 20), () {
    //   get_Toast("message", Colors.red, TOAST_LONG, 12);
    // });
    debugPrint("I am Verbose Log With Default TAG Home");
    // debugPrint("killed state called!");
    // switch (methodCall.method) {
    //   case "onPushNotificationClicked":
    //     debugPrint("onPushNotificationClicked in dart");
    //     var killedPayload = methodCall.arguments;
    //     debugPrint("Clicked Payload in Killed state: ${killedPayload}");
    //     return "This is from android!!";
    //   default:
    //     return "Nothing";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Test")),
      body: const Center(
          child: Text(
        "Home page",
        textScaleFactor: 2,
      )),
    );
  }
}
