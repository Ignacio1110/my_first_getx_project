// import 'package:flutter/material.dart';
//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_page.dart';
import 'chat_room_controller.dart';

//
class ChatAppExample extends StatelessWidget {
  const ChatAppExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatRoomController controller = Get.put(ChatRoomController("test_roomId"));

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App - List'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/waves.png',
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(.6),
          ),
          ListView(
            children: [
              ListTile(
                title: Text('item'),
                leading: CircleAvatar(
                  child: Icon(Icons.group),
                ),
                onTap: () {
                  Get.to(() => ChatPage());
                },
                subtitle: Text('latest message'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
