// ignore_for_file:  unnecessary_this
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
// import 'package:intl/intl.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

GlobalKey globalKey = GlobalKey();

void main() async {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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

  TextEditingController pushEventController = TextEditingController();

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
    var stuff = ["bags", "shoes"];
    // var date = "";
    // if (Platform.isAndroid) {
    //   date = '01-01-2000'; //dd-MM-yyyy
    // } else if (Platform.isIOS) {
    //   DateTime userDOB = DateFormat('dd-MM-yyyy').parse("01-01-2000");
    //   date = '\$D_${userDOB.millisecondsSinceEpoch}';
    // }
    var profile = {
      'stuff': stuff,
      // "DOB": date,
      'dob': CleverTapPlugin.getCleverTapDate(DateTime.now()),
    };
    CleverTapPlugin.profileSet(profile);

    super.initState();
    CleverTapPlugin.setDebugLevel(3);
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
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

    // CleverTapPlugin.initializeInbox();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = CleverTapPlugin();

    //Handler for receiving Push Clicked Payload in FG and BG state
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        _pushClickedPayloadReceived);
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
  _pushClickedPayloadReceived(Map<String, dynamic> map) {
    debugPrint("pushClickedPayloadReceived called");
    this.setState(() async {
      var data = jsonEncode(map);
      debugPrint("on Push Click Payload = $data");
    });
  }

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
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 5, bottom: 0),
              child: TextField(
                controller: pushEventController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Push Event',
                    hintText: 'Push Event'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10),
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    recordEvent();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  child: Text(
                    'Push Event',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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

  void recordEvent() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent(pushEventController.text, eventData);
    showToast("push Event Clicked!", context: context);
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
