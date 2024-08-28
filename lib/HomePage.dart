// ignore_for_file:  unnecessary_this
import 'dart:convert';
import 'package:clevertap_flutter_integration/CustomAppInbox.dart';
import 'package:clevertap_flutter_integration/Page1.dart';
import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

// import 'package:intl/intl.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool navigatingFromInbox = false;

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

  static const notificationTapChannel = MethodChannel("notificationTapChannel");
  static const androidSharedPrefs = MethodChannel("android_shared_preferences");

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
    notificationTapChannel.setMethodCallHandler(this.notificationTapCallback);
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

    CleverTapPlugin.initializeInbox();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    print("Activate Flutter is called");
    _clevertapPlugin = CleverTapPlugin();

    //Handler for receiving Push Clicked Payload in FG and BG state
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
    _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
    // _clevertapPlugin
    //     .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);

    //App Inbox Clicked callback
    _clevertapPlugin.setCleverTapInboxNotificationMessageClickedHandler(
        inboxNotificationMessageClicked);

    _clevertapPlugin.setCleverTapDisplayUnitsLoadedHandler(natDisp);

    //InApp
    _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
        inAppNotificationButtonClicked);
  }

  void inboxNotificationMessageClicked(
      Map<String, dynamic>? data, int contentPageIndex, int buttonIndex) {
    this.setState(() async {
      print("App Inbox -> "
              "inboxNotificationMessageClicked called = InboxItemClicked at page-index "
              "$contentPageIndex with button-index $buttonIndex" +
          data.toString());

      var deepLink = "";
      var content = data?['msg']['content'][0];
      var action = content['action'];
      var dl_url = action['url'];
      if (dl_url != null) {
        if (Platform.isAndroid) {
          if (dl_url['android'] != null && dl_url['android']['text'] != null) {
            deepLink = dl_url['android']['text'];
          }
        } else {
          if (dl_url['ios'] != null && dl_url['ios']['text'] != null) {
            deepLink = dl_url['ios']['text'];
          }
        }
      }
      print("App Inbox -> $deepLink ");

      String deepLinkSplit = deepLink.split('/').last;
      print("App Inbox -> $deepLinkSplit ");

      // Using URL_LAUNCHER dependency of flutter to navigate to the project
      if (deepLinkSplit == "page1") {
        if (await canLaunchUrl(Uri.parse(deepLink))) {
          print("canLaunchURL is called");
          launchUrl(Uri.parse(deepLink), mode: LaunchMode.inAppWebView);
        } else
          print("Can't launch");
      }

      if (Platform.isAndroid) {
        Fluttertoast.showToast(
            msg: "Android Says: App Inbox Clicked",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (Platform.isIOS) {
        Fluttertoast.showToast(
            msg: "iOS Says: App Inbox Clicked",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  //inApp
  void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
    debugPrint('[inAppNotificationButtonClicked]');

    setState(() {
      debugPrint('inAppNotificationButtonClicked called = ${map.toString()}');
    });
  }

  //for Push Notification Clicked Payload via MethodChannel
  Future<dynamic> notificationTapCallback(MethodCall methodCall) async {
    debugPrint("Killed state iOS");
    switch (methodCall.method) {
      case "iosPushNotificationClicked":
        debugPrint("iosPushNotificationClicked in dart");
        var killedPayload = methodCall.arguments;
        debugPrint("iOS Clicked Payload via MethodChannel: ${killedPayload}");
        return "Success";
      default:
        return "Nothing";
    }
  }

  //For Push Notification Clicked Payload in FG and BG state
  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    print("pushClickedPayloadReceived called");
    this.setState(() async {
      var data = jsonEncode(map);
      print("on Push Click Payload = $data");
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

  Future<void> getPreferences() async {
    try {
      // Call the method and await the result
      final Map<dynamic, dynamic> prefs = await androidSharedPrefs.invokeMethod('getPreferences');
      print("******* PREFS *******: $prefs");
      prefs.forEach((key, value) {
        print('$key: $value');
      });
    } on PlatformException catch (e) {
      print("Failed to get preferences: '${e.message}'.");
    }
  }


  @override
  Widget build(BuildContext context) {
    getPreferences();
    return Scaffold(
      // key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle the bell icon press action here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InboxScreen()),
              );
            },
          ),
        ],
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
                child: TextButton(
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
                  onTap: getPreferences,
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

    print(
        "_handleKilledStateNotificationInteraction => Type: $type, Title: $title, Message: $message ");
  }
}
