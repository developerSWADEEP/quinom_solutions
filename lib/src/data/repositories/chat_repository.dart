import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatRepository {
  final ApiClient _api;
  ChatRepository(this._api);

  Future<List<ChatItem>> getUserChats(String userId) async {
    final Response res = await _api.get('/chats/user-chats/$userId');
    final list = (res.data as List)
        .map((e) => ChatItem.fromJson(e, userId))
        .toList();
    return list;
  }

  Future<List<Message>> getChatMessages(String chatId) async {
    final Response res = await _api.get('/messages/get-messagesformobile/$chatId');
    final list = (res.data as List).map((e) => Message.fromJson(e)).toList();
    return list;
  }

  Future<Message> sendMessage(Message msg) async {
    final Response res = await _api.post('/messages/sendMessage', data: msg.toSendPayload());
    final data = res.data as Map<String, dynamic>;
    return Message.fromJson(data);
  }
}