// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'analytics_clever_tap_service.dart';
import 'global.dart';

const int TEST_RUN_APP_DELAY = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AnalyticsCleverTapService.init();

  Future.delayed(const Duration(seconds: TEST_RUN_APP_DELAY), () async {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(title: Text('My Flutter App')),
        body: Center(
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24), // Optional: Adjust text style
          ),
        ),
      ),
    );
  }
}