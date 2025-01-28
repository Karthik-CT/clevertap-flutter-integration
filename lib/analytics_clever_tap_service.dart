import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mobile_super_app/core/dependency_injection/di_config.dart';
// import 'package:mobile_super_app/core/utils/url.dart';
import 'global.dart';

@pragma('vm:entry-point')
void onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
  print('onKilledStateNotificationClickedHandler called from headless task!');
  print('Notification Payload received: $map');
  // di.get<AnalyticsCleverTapService>().handleNotificationPayload(map);
}

class AnalyticsCleverTapService {
  late final CleverTapPlugin _clevertapPlugin;

  static const _channel = MethodChannel('cleverTapChannel');

  AnalyticsCleverTapService.init() {
    _clevertapPlugin = CleverTapPlugin();

    CleverTapPlugin.onKilledStateNotificationClicked(
      onKilledStateNotificationClickedHandler,
    );
    CleverTapPlugin.createNotificationChannel(
      'tradeling-channel',
      'tradeling',
      'tradeling notifications channel',
      5,
      true,
    );
    _channel.setMethodCallHandler(_handleMethodCall);

    print('CleverTapAnalytics init');

    Future.delayed(const Duration(seconds: 0), () {
      activateCleverTapFlutterPluginHandlers();
    });

    CleverTapPlugin.setDebugLevel(3);
    CleverTapPlugin.enableDeviceNetworkInfoReporting(true);
    CleverTapPlugin.pushNotificationClickedEvent({
      'pushNotificationClickedEvent': true,
    });
    CleverTapPlugin.pushNotificationViewedEvent({
      'pushNotificationViewedEvent': true,
    });

    if (Platform.isIOS) {
      CleverTapPlugin.registerForPush();
    }
    if (Platform.isAndroid) {
      _handleKilledStateNotificationInteraction();
      _setHuaweiPushToken();
    }

    ///suspendInAppNotifications until the splash screen is finished
    CleverTapPlugin.suspendInAppNotifications();
  }

  void activateCleverTapFlutterPluginHandlers() {
    print("CleverTapAnalytics setCleverTapPushClickedPayloadReceivedHandler called");
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
      pushClickedPayloadReceived,
    );
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'pushClickedResponse':
        final response = call.arguments as Map<String, dynamic>;
        print('pushClickedResponse : $response');
        handleNotificationPayload(response);
        break;
      default:
        log('Method ${call.method} not implemented.');
    }
  }

  void resumeInAppNotifications() => CleverTapPlugin.resumeInAppNotifications();

  ///App is launched from a notification click which was rendered by the CleverTap SDK.
  void _handleKilledStateNotificationInteraction() async {
    final CleverTapAppLaunchNotification appLaunchNotification =
    await CleverTapPlugin.getAppLaunchNotification();

    log('_handleKilledStateNotificationInteraction with CleverTap, payload ${appLaunchNotification.payload}');
    print(
        'CleverTapAnalytics _handleKilledStateNotificationInteraction with CleverTap, payload ${appLaunchNotification.payload}');

    if (appLaunchNotification.didNotificationLaunchApp) {
      final notificationPayload = appLaunchNotification.payload;
      if (notificationPayload != null) {
        print(
            'CleverTapAnalytics handleNotificationPayload ${appLaunchNotification.payload}');
        handleNotificationPayload(appLaunchNotification.payload!);
      }
    }
  }

  ///(Android) Only when the app is in the foreground or background states
  ///(IOS) foreground, background, or has been terminated (killed).
  void pushClickedPayloadReceived(Map<String, dynamic> notificationPayload) {
    log('pushClickedPayloadReceived called with notification payload: $notificationPayload');
    print(
        'CleverTapAnalytics pushClickedPayloadReceived called with notification payload: $notificationPayload');
    handleNotificationPayload(notificationPayload);
    displayAlert(
      title: "Notification Clicked",
      message: "Payload: ${jsonEncode(notificationPayload)}",
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

  void handleNotificationPayload(Map<String, dynamic> notificationPayload) {
    print('CleverTapAnalytics NotificationPayload : $notificationPayload');
    final notificationDeepLink = notificationPayload['wzrk_dl'];
    print('CleverTapAnalytics notificationDeepLink : $notificationDeepLink');
    if (notificationDeepLink == null) return;
    // UrlUtils.openUrl(null, notificationDeepLink);
  }

  Future<void> _setHuaweiPushToken() async {
    try {
      const MethodChannel hmsChannel = MethodChannel('huawei_push_channel');
      final String? huaweiToken =
      await hmsChannel.invokeMethod<String>('getHuaweiPushToken');

      if (huaweiToken != null) {
        CleverTapPlugin.setHuaweiPushToken(huaweiToken);
        log('Huawei Push Token set successfully: $huaweiToken');
      } else {
        log('Failed to retrieve Huawei Push Token.');
      }
    } on PlatformException catch (e) {
      log('Error retrieving Huawei Push Token: ${e.message}');
    }
  }
}
