import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  // const Page1({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          return true; // Prevent the default back navigation
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Page1'),
        ),
        body: Center(
          child: Text('This is Page1 Karthik'),
        ),
      ),
    );
  }
}

