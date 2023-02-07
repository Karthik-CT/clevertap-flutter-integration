// // ignore_for_file:  unnecessary_this
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:clevertap_plugin/clevertap_plugin.dart';
// import 'package:flutter/services.dart';
// // import 'package:intl/intl.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// GlobalKey globalKey = GlobalKey();

// void main() async {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter SDK Integration'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var inboxInitialized = false;
//   late CleverTapPlugin _clevertapPlugin;
//   var optOut = false;
//   var offLine = false;
//   var enableDeviceNetworkingInfo = false;

//   //for killed state notification clicked
//   static const platform = MethodChannel("myChannel");

//   @override
//   void initState() {
//     // CleverTapPlugin.setDebugLevel(3);
//     // initPlatformState();
//     // activateCleverTapFlutterPluginHandlers();
//     // CleverTapPlugin.createNotificationChannel(
//     //     "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);
//     // var stuff = ["bags", "shoes"];
//     // CleverTapPlugin.onUserLogin({
//     //   'Name': 'Test 63',
//     //   'Identity': 'test63',
//     //   'Email': 'test63@test.com',
//     //   'Phone': '+14364532109',
//     //   'MSG-email': true,
//     //   'MSG-push': true,
//     //   'MSG-sms': true,
//     //   'MSG-whatsapp': true,
//     // });
//     //For Killed State Handler
//     // platform.setMethodCallHandler(nativeMethodCallHandler);

//     super.initState();
//     CleverTapPlugin.setDebugLevel(3);
//     initPlatformState();
//     activateCleverTapFlutterPluginHandlers();
//     CleverTapPlugin.createNotificationChannel(
//         "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);
//     var stuff = ["bags", "shoes"];
//     CleverTapPlugin.onUserLogin({
//       'Name': 'Test 63',
//       'Identity': 'test63',
//       'Email': 'test63@test.com',
//       'Phone': '+14364532109',
//       'MSG-email': true,
//       'MSG-push': true,
//       'MSG-sms': true,
//       'MSG-whatsapp': true,
//     });
//     platform.setMethodCallHandler(this.nativeMethodCallHandler);

//     // CleverTapPlugin.initializeInbox();
//   }

//   Future<void> initPlatformState() async {
//     if (!mounted) return;
//   }

//   void activateCleverTapFlutterPluginHandlers() {
//     _clevertapPlugin = CleverTapPlugin();

//     //Handler for receiving Push Clicked Payload in FG and BG state
//     _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
//         pushClickedPayloadReceived);
//     _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
//     // _clevertapPlugin
//     //     .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
//     _clevertapPlugin.setCleverTapDisplayUnitsLoadedHandler(avinash);

//     //InApp
//     _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
//         inAppNotificationButtonClicked);
//   }

//   //inApp
//   void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
//     debugPrint('[inAppNotificationButtonClicked]');

//     setState(() {
//       debugPrint('inAppNotificationButtonClicked called = ${map.toString()}');
//     });
//   }

//   //For Push Notification Clicked Payload in FG and BG state
//   void pushClickedPayloadReceived(Map<String, dynamic> map) {
//     debugPrint("pushClickedPayloadReceived called");
//     this.setState(() async {
//       var data = jsonEncode(map);
//       debugPrint("on Push Click Payload = $data");
//     });
//   }

//   //For Push Notification Clicked Payload in killed state
//   Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
//     debugPrint("killed state called!");
//     // switch (methodCall.method) {
//     //   case "onPushNotificationClicked":
//     //     debugPrint("onPushNotificationClicked in dart");
//     //     var killedPayload = methodCall.arguments;
//     //     debugPrint("Clicked Payload in Killed state: ${killedPayload}");
//     //     return "This is from android!!";
//     //   default:
//     //     return "Nothing";
//     // }
//   }

//   void inboxDidInitialize() {
//     this.setState(() {
//       debugPrint("inboxDidInitialize called");
//       inboxInitialized = true;
//     });
//   }

//   void avinash(List<dynamic>? displayUnits) {
//     this.setState(() async {
//       List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();
//       debugPrint("inboxDidInitialize called");
//       debugPrint("Display Units are $displayUnits");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: globalKey,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: const Text("Profile push"),
//                   subtitle: const Text("push your profile"),
//                   onTap: login,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: const Text("Push Event"),
//                   subtitle: const Text("Pushes/Records an event"),
//                   onTap: recordEvent,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: const Text("Notification Event"),
//                   subtitle: const Text("Pushes Notification"),
//                   onTap: pushNotification,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: const Text("InApp Event"),
//                   subtitle: const Text("Pushes InApp Notification"),
//                   onTap: inAppNotification,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: const Text("App Inbox Event"),
//                   subtitle: const Text("Pushes App Inbox Messages"),
//                   onTap: appInbox,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: Text("Show Inbox with sections"),
//                   subtitle: Text("Opens App Inbox with tabs"),
//                   onTap: appInboxWithSections,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.grey.shade300,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ListTile(
//                   title: const Text("Native Display"),
//                   subtitle: const Text("Returns all Display Units set"),
//                   onTap: nativeDisplay,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void login() {
//     var profile = {
//       'Photo':
//           "https://i.pinimg.com/originals/39/95/65/399565162c331db08fde4211da835551.jpg",
//     };
//     CleverTapPlugin.profileSet(profile);
//     showToast("Pushed profile " + profile.toString());
//   }

//   void recordEvent() {
//     var eventData = {
//       'Stuff': 'Shirt',
//     };
//     CleverTapPlugin.recordEvent("ProductF Event", eventData);
//     showToast("ProductF Event Clicked!", context: context);
//   }

//   void pushNotification() {
//     var eventData = {
//       '': '',
//     };
//     CleverTapPlugin.recordEvent("Karthik's Noti Event", eventData);
//     showToast("Karthik's Noti Event Clicked!", context: context);
//   }

//   void inAppNotification() {
//     var eventData = {
//       '': '',
//     };
//     CleverTapPlugin.recordEvent("Karthik's InApp Event", eventData);
//     showToast("Karthik's InApp Event Clicked!", context: context);
//   }

//   void appInbox() {
//     var eventData = {
//       '': '',
//     };
//     CleverTapPlugin.recordEvent("Karthik's App Inbox Event", eventData);
//     // showToast("Karthik's App Inbox Event Clicked!", context: context);
//     showInbox();
//   }

//   void appInboxWithSections() {
//     var eventData = {
//       '': '',
//     };
//     CleverTapPlugin.recordEvent("Karthik's App Inbox Event", eventData);
//     // showToast("Karthik's App Inbox Event Clicked!", context: context);
//     showInboxWithTabs();
//   }

//   void showInbox() {
//     CleverTapPlugin.initializeInbox();
//     var styleConfig = {
//       'noMessageTextColor': '#FF6600',
//       'noMessageText': 'No message(s) to show.',
//       'navBarTitle': 'App Inbox'
//     };
//     CleverTapPlugin.showInbox(styleConfig);
//   }

//   void showInboxWithTabs() {
//     // var arrTab = ["promos", "offers"];
//     // var styleConfig = {
//     //   'noMessageTextColor': '#FF6600',
//     //   'noMessageText': 'No message(s) to show.',
//     //   'navBarTitle': 'App Inbox KK',
//     //   'navBarTitleColor': '#101727',
//     //   'tabs': arrTab,
//     //   'navBarColor': '#EF4444'
//     // };
//     // CleverTapPlugin.showInbox(styleConfig);
//     CleverTapPlugin.initializeInbox();
//   }

//   void nativeDisplay() {
//     var eventData = {
//       '': '',
//     };
//     CleverTapPlugin.recordEvent("Karthik's Native Display Event", eventData);
//     getAdUnits();
//   }

//   void getAdUnits() async {
//     // var displayUnits = await CleverTapPlugin.getAllDisplayUnits();
//     // var a = "";
//     // for (var i in displayUnits) {
//     //   a = i;
//     // }
//     // var decodedJson = json.decode(a);
//     // var jsonValue = json.decode(decodedJson['content']);
//     // debugPrint("value = " + jsonValue['message']);
//     // for (var i = 0; i < displayUnits.length; i++) {
//     //   var units = displayUnits[i];
//     //   displayText(units);
//     //   // debugPrint("units= " + units.toString());
//     // }
//     // for (var element in displayUnits) {
//     //   debugPrint("units= " + element[1].toString());
//     // }
//   }

//   void displayText(units) {
//     for (var i = 0; i < units.length; i++) {
//       debugPrint("title= " + units[i].toString());
//       // debugPrint("message= " + item.message.toString());

//     }
//   }
// }

//sadar code

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

String ADDTOCARTBOXNAME = "add_to_cart";
String ADDTOWISHLISTBOXNAME = "add_to_wislist";

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

    CleverTapPlugin.setDebugLevel(3);
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.createNotificationChannel(
        "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);

    //For Killed State Handler

    //Remove this method to stop OneSignal Debugging
//     OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
//     OneSignal.shared.setAppId("34ba8493-c8ae-44a3-bd8c-afbe7cacb57a");
// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//     OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
//       print("Accepted permission: $accepted");
//     });
    if (Platform.isIOS) {
      CleverTapPlugin.registerForPush();
    } //only for iOS
    //   //var initialUrl = CleverTapPlugin.getInitialUrl();
    WidgetsFlutterBinding.ensureInitialized();
    platform.setMethodCallHandler(nativeMethodCallHandler);
  }

  @override
  void dispose() {
    // _sub?.cancel();
    super.dispose();
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
    debugPrint("I am Verbose Log With Default TAG");
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
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
