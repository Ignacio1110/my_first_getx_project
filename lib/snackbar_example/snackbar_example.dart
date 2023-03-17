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
            const GetSnackBar(
              message: "test",
              titleText: Center(
                child: Text(
                  'text',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              duration: Duration(seconds: 1),
            ).show();
          },
          child: const Text('snack bar'),
        ),
      ),
    );
  }
}
