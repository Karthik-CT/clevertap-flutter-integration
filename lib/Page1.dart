import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Page1 extends StatelessWidget {
  // const Page1({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          return true;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Page1'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pop(context, 'fromPage1');
              SystemNavigator.pop();
            },
          ),
        ),
        body: Center(
          child: Text('This is Page1 Karthik'),
        ),
      ),
    );
  }
}