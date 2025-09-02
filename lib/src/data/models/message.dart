import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl;
  final String status;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? seenAt;
  final List<String> seenBy;
  final List<String> reactions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.fileUrl,
    required this.status,
    required this.sentAt,
    required this.deliveredAt,
    required this.seenAt,
    required this.seenBy,
    required this.reactions,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id']?.toString() ?? '',
      chatId: json['chatId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      messageType: json['messageType']?.toString() ?? 'text',
      fileUrl: json['fileUrl']?.toString() ?? '',
      status: json['status']?.toString() ?? 'sent',
      sentAt: DateTime.tryParse(json['sentAt']?.toString() ?? ''),
      deliveredAt: DateTime.tryParse(json['deliveredAt']?.toString() ?? ''),
      seenAt: DateTime.tryParse(json['seenAt']?.toString() ?? ''),
      seenBy: (json['seenBy'] as List?)?.map((e) => e.toString()).toList() ?? [],
      reactions: (json['reactions'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toSendPayload() => {
    'chatId': chatId,
    'senderId': senderId,
    'content': content,
    'messageType': messageType,
    'fileUrl': fileUrl,
  };

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    content,
    messageType,
    fileUrl,
    status,
    sentAt,
    deliveredAt,
    seenAt,
    seenBy,
    reactions,
    createdAt,
    updatedAt,
  ];
}
