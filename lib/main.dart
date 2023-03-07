import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_getx_project/refresh_example/refresh_example.dart';
import 'package:my_first_getx_project/sliver_example/sliver_example.dart';
import 'package:my_first_getx_project/sliver_example/sliver_example_theme.dart';
import 'package:my_first_getx_project/snackbar_example/snackbar_example.dart';

import 'dialog_example/dialog_example.dart';
import 'image_picker_example/image_picker_example.dart';
import 'local_notification_example/notification_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: SliverExampleTheme.lightTheme,
      home: Scaffold(
          appBar: AppBar(
            title: Text("My Examples"),
          ),
          body: Center(
            child: SizedBox(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Get.to(() => SliverExample()),
                    child: Text("sliver"),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.to(() => ImagePickerExample()),
                    child: Text("photo picker"),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.to(() => QQChatList()),
                    child: Text("refresh"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
