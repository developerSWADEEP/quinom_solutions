part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MessagesInitial extends MessagesState {}
class MessagesLoading extends MessagesState {}
class MessagesLoaded extends MessagesState {
  final List<Message> messages;
  MessagesLoaded({required this.messages});
  @override
  List<Object?> get props => [messages];
}
class MessagesFailure extends MessagesState {
  final String message;
  MessagesFailure(this.message);
  @override
  List<Object?> get props => [message];
}