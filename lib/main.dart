// ignore_for_file:  unnecessary_this
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

GlobalKey globalKey = GlobalKey();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SDK Integration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var inboxInitialized = false;
  late CleverTapPlugin _clevertapPlugin;
  var optOut = false;
  var offLine = false;
  var enableDeviceNetworkingInfo = false;

  //for killed state notification clicked
  // static const platform = MethodChannel("myChannel");

  //for iOS
  // static const notificationTapChannel = MethodChannel("notificationTapChannel");

  @override
  void initState() {
    // CleverTapPlugin.setDebugLevel(3);
    // initPlatformState();
    // activateCleverTapFlutterPluginHandlers();
    // CleverTapPlugin.createNotificationChannel(
    //     "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);
    // var stuff = ["bags", "shoes"];
    // CleverTapPlugin.onUserLogin({
    //   'Name': 'Test 63',
    //   'Identity': 'test63',
    //   'Email': 'test63@test.com',
    //   'Phone': '+14364532109',
    //   'MSG-email': true,
    //   'MSG-push': true,
    //   'MSG-sms': true,
    //   'MSG-whatsapp': true,
    // });
    //For Killed State Handler
    // platform.setMethodCallHandler(nativeMethodCallHandler);

    super.initState();
    CleverTapPlugin.setDebugLevel(3);
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.createNotificationChannel(
        "testkk123", "Test Notification Flutter", "Flutter Test", 5, true);
    CleverTapPlugin.createNotificationChannelWithSound(
        "testkk123",
        "Test Notification Flutter",
        "Flutter Test",
        5,
        true,
        "notificationsound1.mp3");

    // var stuff = ["bags", "shoes"];
    // CleverTapPlugin.onUserLogin({
    //   'Name': 'Test 63',
    //   'Identity': 'test63',
    //   'Email': 'test63@test.com',
    //   'Phone': '+14364532109',
    //   'MSG-email': true,
    //   'MSG-push': true,
    //   'MSG-sms': true,
    //   'MSG-whatsapp': true,
    // });

    // var stuff = ["bags", "shoes"];
    // var profile = {
    //   'Name': 'John Wick',
    //   'Identity': '100',
    //   'DOB': '22-04-2000',
    //   'Email': 'john@gmail.com',
    //   'Phone': '14155551234',
    //   'props': 'property1',
    //   'stuff': stuff
    // };
    // CleverTapPlugin.profileSet(profile);

    // platform.setMethodCallHandler(this.nativeMethodCallHandler);

    // notificationTapChannel.setMethodCallHandler(this.notificationTapCallback);

    // CleverTapPlugin.initializeInbox();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = CleverTapPlugin();

    //Handler for receiving Push Clicked Payload in FG and BG state
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
    _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
    // _clevertapPlugin
    //     .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
    _clevertapPlugin.setCleverTapDisplayUnitsLoadedHandler(natDisp);

    //InApp
    _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
        inAppNotificationButtonClicked);
  }

  //inApp
  void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
    debugPrint('[inAppNotificationButtonClicked]');

    setState(() {
      debugPrint('inAppNotificationButtonClicked called = ${map.toString()}');
    });
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
  // Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
  //   debugPrint("killed state called!");
  //   switch (methodCall.method) {
  //     case "onPushNotificationClicked":
  //       debugPrint("onPushNotificationClicked in dart");
  //       var killedPayload = methodCall.arguments;
  //       debugPrint("Clicked Payload in Killed state: ${killedPayload}");
  //       return "This is from android!!";
  //     default:
  //       return "Nothing";
  //   }
  // }

  //for Push Notification Clicked Payload in killed state iOS
  // Future<dynamic> notificationTapCallback(MethodCall methodCall) async {
  //   debugPrint("Killed state iOS");
  //   switch (methodCall.method) {
  //     case "iosPushNotificationClicked":
  //       debugPrint("iosPushNotificationClicked in dart");
  //       var killedPayload = methodCall.arguments;
  //       debugPrint("iOS Clicked Payload in Killed state: ${killedPayload}");
  //       return "This is from android!!";
  //     default:
  //       return "Nothing";
  //   }
  // }

  void inboxDidInitialize() {
    this.setState(() {
      debugPrint("inboxDidInitialize called");
      inboxInitialized = true;
    });
  }

  void natDisp(List<dynamic>? displayUnits) {
    this.setState(() async {
      print("Debug Test");
      List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();

      debugPrint("inboxDidInitialize called");
      debugPrint("Display Units are $displayUnits");

      displayUnits?.forEach((element) {
        var unitId = element["wzrk_id"];
        CleverTapPlugin.pushDisplayUnitViewedEvent(unitId);
        CleverTapPlugin.pushDisplayUnitClickedEvent(unitId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("On User Login"),
                  subtitle: const Text("calls onUserLogin"),
                  onTap: login,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Push Event"),
                  subtitle: const Text("Pushes/Records an event"),
                  onTap: recordEvent,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Notification Event"),
                  subtitle: const Text("Pushes Notification"),
                  onTap: pushNotification,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("InApp Event"),
                  subtitle: const Text("Pushes InApp Notification"),
                  onTap: inAppNotification,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("App Inbox Event"),
                  subtitle: const Text("Pushes App Inbox Messages"),
                  onTap: appInbox,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text("Show Inbox with sections"),
                  subtitle: Text("Opens App Inbox with tabs"),
                  onTap: appInboxWithSections,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Native Display"),
                  subtitle: const Text("Returns all Display Units set"),
                  onTap: cleverTapND,
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void login() {
    // var profile = {
    //   'Photo':
    //       "https://i.pinimg.com/originals/39/95/65/399565162c331db08fde4211da835551.jpg",
    // };
    // CleverTapPlugin.profileSet(profile);
    // showToast("Pushed profile " + profile.toString());

    CleverTapPlugin.onUserLogin({
      'Name': 'Flutter KK 3',
      'Identity': 'flutterkk3',
      'Email': 'flutterkk3@test.com',
      'Phone': '+14364532109',
      'MSG-email': true,
      'MSG-push': true,
      'MSG-sms': true,
      'MSG-whatsapp': true,
    });
    showToast("On User Login Clicked", context: context);
  }

  void recordEvent() {
    var eventData = {
      'Stuff': 'Shirt',
    };
    CleverTapPlugin.recordEvent("ProductF Event", eventData);
    showToast("ProductF Event Clicked!", context: context);
  }

  void pushNotification() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Karthik's Noti Event", eventData);
    showToast("Karthik's Noti Event Clicked!", context: context);
  }

  void inAppNotification() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Karthik's InApp Event", eventData);
    showToast("Karthik's InApp Event Clicked!", context: context);
  }

  void appInbox() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Karthik's App Inbox Event", eventData);
    // showToast("Karthik's App Inbox Event Clicked!", context: context);
    showInbox();
  }

  void appInboxWithSections() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Karthik's App Inbox Event", eventData);
    // showToast("Karthik's App Inbox Event Clicked!", context: context);
    showInboxWithTabs();
  }

  void showInbox() {
    CleverTapPlugin.initializeInbox();
    var styleConfig = {
      'noMessageTextColor': '#FF6600',
      'noMessageText': 'No message(s) to show.',
      'navBarTitle': 'App Inbox'
    };
    CleverTapPlugin.showInbox(styleConfig);
  }

  void showInboxWithTabs() {
    var arrTab = ["promos", "offers"];
    var styleConfig = {
      'noMessageTextColor': '#FF6600',
      'noMessageText': 'No message(s) to show.',
      'navBarTitle': 'App Inbox KK',
      'navBarTitleColor': '#101727',
      'tabs': arrTab,
      'navBarColor': '#EF4444'
    };
    CleverTapPlugin.showInbox(styleConfig);
    CleverTapPlugin.initializeInbox();
  }

  void nativeDisplay() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Karthik's Native Display Event", eventData);
    cleverTapND();
  }

  void onDisplayUnitsLoaded(List<dynamic> displayUnits) {
    this.setState(() async {
      List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();
      debugPrint("Display Units = $displayUnits");
    });
  }

  void cleverTapND() {
    print("Debug Test");
    this.setState(() async {
      List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();

      debugPrint("inboxDidInitialize called");
      debugPrint("Display Units Lenth is ${displayUnits?.length}");
      debugPrint("Display Units are ${displayUnits}");

      displayUnits?.forEach((element) {
        var unitId = element["wzrk_id"];
        CleverTapPlugin.pushDisplayUnitViewedEvent(unitId);
        CleverTapPlugin.pushDisplayUnitClickedEvent(unitId);
      });
    });
  }
}
