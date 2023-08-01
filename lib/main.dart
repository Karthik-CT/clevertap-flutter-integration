// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
// import 'package:intl/intl.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  late CleverTapPlugin _clevertapPlugin;
  TextEditingController nameController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  //push notification clicked callback in killed state
  void _handleKilledStateNotificationInteraction() async {
    CleverTapAppLaunchNotification appLaunchNotification =
        await CleverTapPlugin.getAppLaunchNotification();
    print(
        "_handleKilledStateNotificationInteraction => $appLaunchNotification");

    if (appLaunchNotification.didNotificationLaunchApp) {
      Map<String, dynamic> notificationPayload = appLaunchNotification.payload!;
      handleDeeplink(notificationPayload);
    }
  }

  @override
  void initState() {
    super.initState();
    CleverTapPlugin.setDebugLevel(3);
    initPlatformState();
    print("CTID: ${CleverTapPlugin.getCleverTapID().toString()}");
    //for killed state notification clicked callback
    _handleKilledStateNotificationInteraction();
    CleverTapPlugin.createNotificationChannel(
        "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);
    CleverTapPlugin.createNotificationChannelWithSound(
        "testkk123",
        "Test Notification Flutter",
        "Flutter Test",
        5,
        true,
        "notificationsound1.mp3");
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void flutterOnUserLogin() {
    CleverTapPlugin.onUserLogin({
      'Name': nameController.text,
      'Identity': identityController.text,
      'Email': emailController.text,
      'Phone': mobController.text,
      'MSG-email': true,
      'MSG-push': true,
      'MSG-sms': true,
      'MSG-whatsapp': true,
    });
  }

  void flutterPushProfile() {
    var stuff = ["bags", "shoes"];
    CleverTapPlugin.profileSet({
      'myStuff': stuff,
      'MSG-email': true,
      'MSG-push': true,
      'MSG-sms': true,
      'MSG-whatsapp': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/CTLogo.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: mobController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                    hintText: 'Mobile Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: identityController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Identity',
                    hintText: 'Identity'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Email ID'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: pwdController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    flutterOnUserLogin();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  child: Text(
                    'onUserLogin',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    flutterPushProfile();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  child: Text(
                    'pushProfile',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleDeeplink(Map<String, dynamic> notificationPayload) {
    var type = notificationPayload["type"];
    var title = notificationPayload["nt"];
    var message = notificationPayload["nm"];

    // if (type != null) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               DeepLinkPage(type: type, title: title, message: message)));
    // }

    print(
        "_handleKilledStateNotificationInteraction => Type: $type, Title: $title, Message: $message ");
  }
}
