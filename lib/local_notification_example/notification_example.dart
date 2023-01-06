import 'package:flutter/material.dart';
import 'package:my_first_getx_project/local_notification_example/notification_service.dart';

class NotificationExample extends StatelessWidget {
  const NotificationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  NotificationService().newNotification("msg", true);
                },
                child: const Text("show notification"))
          ],
        ),
      ),
    );
  }
}
