// ignore_for_file: prefer_const_constructors

// import 'dart:convert';
//
// import 'package:clevertap_flutter_integration/Page1.dart';
// import 'package:clevertap_plugin/clevertap_plugin.dart';
// import 'package:flutter/material.dart';
// import 'AppGroupManager.dart';
// import 'HomePage.dart';
// import 'Page1.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// final int TEST_RUN_APP_DELAY = 0;
// final int CLEVERTAP_LISTENER_ATTACH_DELAY = 0;
//
// @pragma('vm:entry-point')
// void onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
//   print("onKilledStateNotificationClickedHandler called from headless task!");
//   print("Notification Payload received: " + map.toString());
// }
//
// void main() {
//   print("CleverTapPlugin main pre ensure");
//   WidgetsFlutterBinding.ensureInitialized();
//   CleverTapPlugin.onKilledStateNotificationClicked(
//       onKilledStateNotificationClickedHandler);
//
//   print("CleverTapPlugin main pre runapp");
//
//   Future.delayed(Duration(seconds: TEST_RUN_APP_DELAY), () {
//     runApp(MaterialApp(
//       navigatorKey: navigatorKey,
//       title: 'Loginn Page',
//       home: MyApp(),
//     ));
//     print("CleverTapPlugin main POSTTT runapp");
//   });
//   // runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       onGenerateRoute: _onGenerateRoute,
//     );
//   }
//
//   //Create Routes of your app
//   Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
//     print("Route: " + settings.toString());
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (context) => LoginDemo());
//       case 'page1':
//         return MaterialPageRoute(builder: (context) => Page1());
//       case 'karthikdl://page1?isinbox=true':
//         return MaterialPageRoute(builder: (context) => Page1());
//       case 'karthikdl://page1':
//         return MaterialPageRoute(builder: (context) => Page1());
//       default:
//         return MaterialPageRoute(
//             builder: (context) => MyHomePage(title: 'Flutter SDK Integration'));
//     }
//   }
// }

import 'dart:convert';
import 'package:clevertap_flutter_integration/Page1.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'AppGroupManager.dart';
import 'HomePage.dart';
import 'Page1.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final int TEST_RUN_APP_DELAY = 0;
final int CLEVERTAP_LISTENER_ATTACH_DELAY = 0;

@pragma('vm:entry-point')
void onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
  print("onKilledStateNotificationClickedHandler called from headless task!");
  print("Notification Payload received: " + map.toString());

  // Display alert in the app
  displayAlert(
    title: "Notification Clicked",
    message: "Payload: ${jsonEncode(map)}",
  );
}

void displayAlert({required String title, required String message}) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    print("Unable to show alert. Context is null.");
  }
}

void main() async {
  print("CleverTapPlugin main pre ensure");
  WidgetsFlutterBinding.ensureInitialized();
  CleverTapPlugin.onKilledStateNotificationClicked(onKilledStateNotificationClickedHandler);

  print("CleverTapPlugin main pre runapp");

  Future.delayed(Duration(seconds: TEST_RUN_APP_DELAY), () {
    runApp(MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Loginn Page',
      home: MyApp(),
    ));
    print("CleverTapPlugin main POSTTT runapp");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    print("Route: " + settings.toString());
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => LoginDemo());
      case 'page1':
        return MaterialPageRoute(builder: (context) => Page1());
      case 'karthikdl://page1?isinbox=true':
        return MaterialPageRoute(builder: (context) => Page1());
      case 'karthikdl://page1':
        return MaterialPageRoute(builder: (context) => Page1());
      default:
        return MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Flutter SDK Integration'));
    }
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
    activateCleverTapFlutterPluginHandlers();
    print("CTID: ${CleverTapPlugin.getCleverTapID().toString()}");
    //for killed state notification clicked callback
    _handleKilledStateNotificationInteraction();
  }

  void activateCleverTapFlutterPluginHandlers() {
    print("Activate Flutter is called");
    _clevertapPlugin = CleverTapPlugin();

    //Handler for receiving Push Clicked Payload in FG and BG state
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
  }

  //For Push Notification Clicked Payload in FG and BG state
  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    print("pushClickedPayloadReceived called");
    this.setState(() async {
      var data = jsonEncode(map);
      print("on Push Click Payload = $data");
      displayAlert(
        title: "Notification Clicked",
        message: "Payload: ${jsonEncode(map)}",
      );
      CleverTapPlugin.recordEvent("on_push_click_payload_event", map);
    });
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

    AppGroupManager.saveUserInfo(
      name: nameController.text,
      email: emailController.text,
      mobile: mobController.text,
      identity: identityController.text,
    );
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
                child: TextButton(
                  onPressed: () {
                    flutterOnUserLogin();
                    Navigator.pushNamed(context, '/homepage');
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
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
                child: TextButton(
                  onPressed: () {
                    flutterPushProfile();
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

    print(
        "_handleKilledStateNotificationInteraction => Type: $type, Title: $title, Message: $message ");
  }
}