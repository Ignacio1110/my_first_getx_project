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
import 'repository/message_repository.dart';
import 'repository/mock_message_repository.dart';

//
class ChatAppExample extends StatefulWidget {
  ChatAppExample({Key? key}) : super(key: key);

  @override
  State<ChatAppExample> createState() => _ChatAppExampleState();
}

class _ChatAppExampleState extends State<ChatAppExample> {
  final List<String> roomIds = [
    'roomId1',
    'roomId2',
    'roomId3',
    'roomId4',
    'roomId5',
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MessageRepository mockMessageRepository =
        Get.put(MockMessageRepository()..init());
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App - List'),
      ),
      body: Obx(
        () => (mockMessageRepository as MockMessageRepository).isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/waves.png',
                    fit: BoxFit.cover,
                    opacity: AlwaysStoppedAnimation(.6),
                  ),
                  ListView.builder(
                    itemCount: roomIds.length,
                    itemBuilder: (BuildContext context, int index) {
                      roomIds[index];
                      ChatRoomController controller = Get.put(
                          ChatRoomController(roomIds[index]),
                          tag: roomIds[index]);
                      return Obx(
                        () => ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.group),
                          ),
                          title: Text(controller.roomId),
                          subtitle: Text(
                            controller.latestMessageString,
                          ),
                          onTap: () {
                            Get.to(() => ChatPage(
                                  chatKey: controller.chatKey,
                                  id: controller.roomId,
                                ));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
