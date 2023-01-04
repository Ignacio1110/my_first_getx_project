import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class SnackBarExample extends StatelessWidget {
  const SnackBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
            GetSnackBar(
              // title: "title",
              message: "test",
              titleText: Center(
                child: Text(
                  'text',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ).show();
          },
          child: const Text('snack bar'),
        ),
      ),
    );
  }
}
