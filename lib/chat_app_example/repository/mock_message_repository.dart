import 'dart:convert';
import 'dart:math';

import 'package:flutter_chat_types/src/message.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../const.dart';
import 'message_repository.dart';

class MockMessageRepository implements MessageRepository {
  RxBool isLoading = false.obs;
  List<types.Message> remoteMessages = [];

  init() async {
    isLoading.value = true;
    remoteMessages = await _loadMessages();
    List<types.Message> messages = _generateMessages();
    remoteMessages.addAll(messages);
    isLoading.value = false;
  }

  @override
  Future<List<types.Message>> fetchNewerMessage(String roomId, int limit,
      [Message? startMessage]) async {
    if (startMessage == null) {
      return remoteMessages.take(limit).toList();
    } else {
      //以下模擬提取訊息
      List<types.Message> messages = remoteMessages.reversed
          .skipWhile((value) => value.id != startMessage.id)
          .take(limit + 1)
          .toList()
          .reversed
          .toList();
      return messages.isEmpty ? [] : messages.skip(1).toList();
    }
  }

  @override
  Future<List<Message>> fetchOlderMessage(String roomId, int limit,
      [Message? startMessage]) async {
    if (startMessage == null) {
      return remoteMessages.take(limit).toList();
    } else {
      List<types.Message> messages = remoteMessages.skipWhile((value) {
        final bool b = value.id != startMessage.id;
        return b;
      }).toList();

      messages = messages.take(limit + 1).toList();

      return messages.isEmpty ? [] : messages.skip(1).toList();
    }
  }

  Future<List<types.Message>> _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final List<types.Message> messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    return messages;
  }

  List<types.TextMessage> _generateMessages() {
    const start = 1655624460000;
    List<types.TextMessage> result = [];
    for (int i = 1; i < 100; i++) {
      types.TextMessage msg = _generateMessage(start - i * 1000 * 60 * 60);
      result.add(msg);
    }
    return result;
  }

  types.TextMessage _generateMessage(int? createAt) {
    Map<String, String> map = authors[Random().nextInt(authors.length)];
    String textMessage = textSample[Random().nextInt(textSample.length)];

    return types.TextMessage(
      id: "${messageUUID.first}-$createAt",
      text: textMessage,
      author: types.User(
        id: map['id'] as String,
        firstName: map['firstName'] as String,
      ),
      createdAt: createAt,
    );
  }
}
