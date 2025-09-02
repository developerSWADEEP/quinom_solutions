part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMessages extends MessagesEvent {
  final String chatId;
  FetchMessages(this.chatId);
}

class SendMessageEvent extends MessagesEvent {
  final Message message;
  SendMessageEvent(this.message);
}

class SubscribeChatStream extends MessagesEvent {
  final String chatId;
  SubscribeChatStream(this.chatId);
}

class IncomingSocketMessage extends MessagesEvent {
  final Message message;
  IncomingSocketMessage(this.message);
}
