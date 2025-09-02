import 'package:equatable/equatable.dart';

class ChatItem extends Equatable {
  final String id;
  final String lastMessage;
  final DateTime updatedAt;
  final String otherUserName;

  const ChatItem({required this.id, required this.lastMessage, required this.updatedAt, required this.otherUserName});

  factory ChatItem.fromJson(Map<String, dynamic> json, String currentUserId) {
    final participants = json['participants'] as List? ?? [];
    final otherUser = participants.firstWhere(
          (p) => p['_id'] != currentUserId,
      orElse: () => {'name': 'Unknown'},
    );

    return ChatItem(
      id: json['_id']?.toString() ?? '',
      lastMessage: json['lastMessage']?.toString() ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      otherUserName: otherUser['name']?.toString() ?? 'Unknown',
    );
  }


  @override
  List<Object?> get props => [id, lastMessage, updatedAt, otherUserName];
}