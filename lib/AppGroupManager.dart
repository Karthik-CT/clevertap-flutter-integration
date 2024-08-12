import 'package:flutter/services.dart';

class AppGroupManager {
  static const MethodChannel _channel = MethodChannel('storeValuesInAppGroups');

  static Future<void> saveUserInfo({
    required String name,
    required String email,
    required String mobile,
    required String identity,
  }) async {
    try {
      await _channel.invokeMethod('saveUserInfo', {
        'userName': name,
        'userEmail': email,
        'userMobile': mobile,
        'userIdentity': identity,
      });
    } on PlatformException catch (e) {
      print("Failed to save user info: ${e.message}");
    }
  }
}
