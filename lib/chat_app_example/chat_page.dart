import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_getx_project/chat_app_example/chat_room_controller.dart';
import 'package:my_first_getx_project/chat_app_example/const.dart';
import 'package:my_first_getx_project/chat_app_example/repository/message_repository.dart';
import 'package:uuid/uuid.dart';

import 'repository/mock_message_repository.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.id, required this.chatKey});
  final String id;
  final GlobalKey<ChatState> chatKey;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      ChatRoomController controller =
          Get.put(ChatRoomController(widget.id), tag: widget.id);
      controller.scrollToUnread();
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.put(ChatRoomController("test_roomId"))
                      .handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );
  //
  //     _addMessage(message);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ChatRoomController controller =
        Get.put(ChatRoomController(widget.id), tag: widget.id);
    return Scaffold(
      body: Obx(() {
        controller.messages.toList();
        return Chat(
          key: widget.chatKey,
          scrollToUnreadOptions: ScrollToUnreadOptions(
            lastReadMessageId:
                (Get.find<MessageRepository>() as MockMessageRepository)
                    .remoteMessages[30]
                    .id,
            scrollDelay: Duration(seconds: 2),
            scrollDuration: Duration(seconds: 2),
          ),
          messages: controller.messages.toList(),
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: controller.handleMessageTap,
          onPreviewDataFetched: controller.handlePreviewDataFetched,
          onSendPressed: controller.handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: ownUser,
          onEndReached: controller.handleEndReached,
        );
      }),
    );
  }
}
