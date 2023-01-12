import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogExample extends StatelessWidget {
  const DialogExample({Key? key}) : super(key: key);

  _showDefaultDialog() {
    Get.defaultDialog();
  }

  _showDialog() {
    Get.dialog(Material(
      child: CupertinoAlertDialog(
        title: Text("hi"),
        content: Text("hi"),
        actions: [
          Text('cancel'),
          Text('confirm'),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                _showDefaultDialog();
              },
              child: Text("show default dialog"),
            ),
            ElevatedButton(
              onPressed: () {
                _showDialog();
              },
              child: Text("show dialog"),
            ),
          ],
        ),
      ),
    );
  }
}
