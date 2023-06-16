import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import '../const.dart';
import 'dart:math' show Random;

class MessageRepository {
  //

  Future<List<types.Message>> _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final List<types.Message> messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    return messages;
  }

  Future<List<types.Message>> fetchPrevMessage(String roomId,
      [types.Message? startMessage]) async {
    if (startMessage == null) {
      return await _loadMessages();
    } else {
      Map<String, String> map = authors[Random().nextInt(authors.length)];
      String textMessage = textSample[Random().nextInt(textSample.length)];
      int? createAt = startMessage.createdAt;
      if (createAt != null) {
        createAt = createAt - 1000;
      }
      return [
        types.TextMessage(
          id: Uuid().v4(),
          text: textMessage,
          author: types.User(
            id: map['id'] as String,
            firstName: map['firstName'] as String,
          ),
          createdAt: createAt,
        )
      ];
    }
  }

  fetchNextMessage(String roomId, [types.Message? startMessage]) async {
    if (startMessage == null) {
      return await _loadMessages();
    } else {
      Map<String, String> map = authors[Random().nextInt(authors.length)];
      String textMessage = textSample[Random().nextInt(textSample.length)];
      int? createAt = startMessage.createdAt;
      if (createAt != null) {
        createAt = createAt + 1000;
      }
      return [
        types.TextMessage(
          id: Uuid().v4(),
          text: textMessage,
          author: types.User(
            id: map['id'] as String,
            firstName: map['firstName'] as String,
          ),
          createdAt: createAt,
        )
      ];
    }
  }
}
