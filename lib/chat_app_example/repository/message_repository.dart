import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../const.dart';
import 'dart:math' show Random;

abstract class MessageRepository {
  //

  Future<List<types.Message>> fetchOlderMessage(String roomId, int limit,
      [types.Message? startMessage]);

  Future<List<types.Message>> fetchNewerMessage(String roomId, int limit,
      [types.Message? startMessage]);
}
