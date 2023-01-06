import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// The service used to display notifications and handle callbacks when the user taps on the notification.
///
/// This is a singleton. Just call NotificationService() to get the singleton.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin plugin;

  NotificationService._internal() {
    print("NotificationService initialize");
    final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings(
            '@mipmap/ic_launcher'), //@mipmap/ic_launcher  or  @drawable/icon_white_bg.png
        iOS: IOSInitializationSettings());

    plugin = FlutterLocalNotificationsPlugin();
    plugin.initialize(initializationSettings);
  }

  Future<void> newNotification(String msg, bool vibration,
      {String? tag}) async {
    // Define vibration pattern
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    AndroidNotificationDetails androidNotificationDetails;

    //不同的channel name 可以對應到不同的通知設定，【https://developer.android.com/guide/topics/ui/notifiers/notifications.html#ManageChannels】
    final channelNameMessage = 'mygetx';

    androidNotificationDetails = AndroidNotificationDetails(
        channelNameMessage, channelNameMessage,
        channelDescription: channelNameMessage,
        importance: Importance.max,
        priority: Priority.high,
        vibrationPattern: vibration ? vibrationPattern : null,
        enableVibration: vibration,
        icon: '@mipmap/icon', //this line to change icon, 如果使用白色背景圖片，會導致顯示灰色icon
        color: const Color(0xffffff00), //這個顏色會像濾鏡，把所有有顏色的地方變為此顏色
        playSound: true,
        sound: const RawResourceAndroidNotificationSound(
            'typical_trap_loop'), //在android/app/.../res/raw 放置音樂檔案即可呼叫
        tag: tag ?? msg);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSPlatformChannelSpecifics);

    try {
      await plugin.show(0, msg, msg, notificationDetails);
    } catch (ex) {
      print(ex);
    }
  }
}
