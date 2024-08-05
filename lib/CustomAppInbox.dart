import 'dart:io';
import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'Page1.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleverTap App Inbox',
      home: InboxScreen(),
    );
  }
}

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<Map<String, dynamic>> inboxMessages = [];
  static const platform = MethodChannel('com.example.app/launchURL');

  @override
  void initState() {
    super.initState();
    CleverTapPlugin.initializeInbox();
    getAllInboxMessages();
  }

  Future<void> getAllInboxMessages() async {
    // Assuming getAllInboxMessages() fetches the messages from CleverTap
    List? messages = await CleverTapPlugin.getAllInboxMessages();
    print("Messages: $messages");
    // Parse the messages
    List<Map<String, dynamic>> parsedMessages = messages!.map((msg) {
      var content = msg['msg']['content'][0];
      return {
        'title': content['title']['text'],
        'message': content['message']['text'],
        'imageUrl': content['media']['url'],
        'deepLinkAndroid': content['action']['url']['android']['text'],
        'deepLinkIOS': content['action']['url']['ios']['text'],
        'wzrk_id': msg['wzrk_id'],
        'message_id': msg['messageId'] // Fetching the wzrk_id from the payload
      };
    }).toList();

    setState(() {
      inboxMessages = parsedMessages;
    });

    var msg_id = await getMessageIDForInbox();
    await CleverTapPlugin.pushInboxNotificationViewedEventForId(msg_id);
  }

  Future<String> getMessageIDForInbox() async {
    var messageList = await CleverTapPlugin.getAllInboxMessages();
    print("inside getFirstInboxMessageId");
    Map<dynamic, dynamic> itemFirst = messageList?[0];
    print("itemFirst.toString(): $itemFirst");
    var msg_id = "";
    if (Platform.isAndroid){
      msg_id = itemFirst["id"];
      print("msg_id_getMessageIDForInbox_Android: $msg_id");
    } else if (Platform.isIOS) {
      msg_id = itemFirst["_id"];
      print("msg_id_getMessageIDForInbox_IOS: $msg_id");
    }
    return msg_id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom App Inbox'),
      ),
      body: ListView.builder(
        itemCount: inboxMessages.length,
        itemBuilder: (context, index) {
          var message = inboxMessages[index];
          return GestureDetector(
            onTap: () async {
              _handleDeepLink(
                  message['deepLinkAndroid'], message['deepLinkIOS']);
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      message['message'],
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(message['imageUrl']),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleDeepLink(String deepLinkAndroid, String deepLinkIOS) async {
    var msg_id = await getMessageIDForInbox();
    await CleverTapPlugin.pushInboxNotificationClickedEventForId(msg_id);

    if (Theme.of(context).platform == TargetPlatform.android) {
      // Handle Android deep link
      print('Android Deep Link: $deepLinkAndroid');
      String deepLinkSplit = deepLinkAndroid.split('/').last;
      print("App Inbox -> $deepLinkSplit ");
      if (deepLinkSplit == "page1") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Page1()),
        ).then((_) {
          print("App Inbox -> Navigation complete");
          showToast("App Inbox -> Navigated");
        });
      } else {
        _launchExternalURL(deepLinkAndroid);
      }
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      // Handle iOS deep link
      print('iOS Deep Link: $deepLinkIOS');
      String deepLinkSplit = deepLinkIOS.split('/').last;
      print("App Inbox -> $deepLinkSplit ");
      if (deepLinkSplit == "pag1") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Page1()),
        ).then((_) {
          print("App Inbox -> Navigation complete");
          showToast("App Inbox -> Navigated");
        });
      } else {
        _launchExternalURL(deepLinkIOS);
      }
    }
  }

  Future<void> _launchExternalURL(String url) async {
    try {
      final bool result = await platform.invokeMethod('launchURL', {'url': url});
      if (!result) {
        print('Could not launch $url');
      }
    } on PlatformException catch (e) {
      print("Failed to launch URL: '${e.message}'.");
    }
  }
}
