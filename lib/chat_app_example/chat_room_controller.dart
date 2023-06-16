import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:my_first_getx_project/chat_app_example/repository/message_repository.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import 'const.dart';

class ChatRoomController extends GetxController {
  final MessageRepository repository = MessageRepository();
  String roomId;

  //message index 0 為日期最新的
  RxList<types.Message> messages = RxList<types.Message>([]);

  ChatRoomController(this.roomId);

  //取得最新訊息
  types.Message? get latestMessage =>
      messages.isNotEmpty ? messages.first : null;

  //讀取更舊的資料
  Future<void> fetchPrevMessages() async {
    if (messages.isEmpty) {
      List<types.Message> newMessages =
          await repository.fetchPrevMessage(roomId);
      messages.addAll(newMessages);
    } else {
      List<types.Message> newMessages =
          await repository.fetchPrevMessage(roomId, messages.last);
      messages.addAll(newMessages);
    }
  }

  //讀取更新的資料
  Future<void> fetchNextMessages() async {
    if (messages.isEmpty) {
      List<types.Message> newMessages =
          await repository.fetchPrevMessage(roomId);
      messages.addAll(newMessages);
    } else {
      List<types.Message> newMessages =
          await repository.fetchNextMessage(roomId, messages.first);
      messages.insertAll(0, newMessages);
    }
  }

  //？監聽最新消息？ TODO

  void addMessage(types.Message message) {
    messages.insert(0, message);
    messages.refresh();
  }

  void addRandomMessage() {
    Map<String, String> map = authors[Random().nextInt(authors.length)];
    String textMessage = textSample[Random().nextInt(textSample.length)];
    int? createAt = DateTime.now().millisecondsSinceEpoch;

    messages.insert(
        0,
        types.TextMessage(
          id: Uuid().v4(),
          text: textMessage,
          author: types.User(
            id: map['id'] as String,
            firstName: map['firstName'] as String,
          ),
          createdAt: createAt,
        ));
    messages.refresh();
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: ownUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      addMessage(message);
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: ownUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    addMessage(textMessage);
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    messages[index] = updatedMessage;
    messages.refresh();
  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          messages[index] = updatedMessage;
          messages.refresh();
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          messages[index] = updatedMessage;
          messages.refresh();
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  Timer? timer;
  @override
  void onInit() {
    super.onInit();
    fetchPrevMessages();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      addRandomMessage();
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
    timer = null;
  }
}
