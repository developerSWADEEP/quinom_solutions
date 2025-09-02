import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/socket_service.dart';
import '../../../data/models/message.dart';
import '../../../data/repositories/chat_repository.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepository repo;
  final SocketService socket;

  MessagesBloc(this.repo, this.socket) : super(MessagesInitial()) {
    on<FetchMessages>(_onFetch);
    on<SendMessageEvent>(_onSend);
    on<SubscribeChatStream>(_onSubscribe);
    on<IncomingSocketMessage>(_onIncoming);
  }

  Future<void> _onFetch(FetchMessages event, Emitter<MessagesState> emit) async {
    emit(MessagesLoading());
    try {
      final msgs = await repo.getChatMessages(event.chatId);
      emit(MessagesLoaded(messages: msgs));
    } catch (e) {
      emit(MessagesFailure(e.toString()));
    }
  }

  Future<void> _onSend(SendMessageEvent event, Emitter<MessagesState> emit) async {
    try {
      if (state is MessagesLoaded) {
        final current = List<Message>.from((state as MessagesLoaded).messages);
        final temp = Message(
          id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
          chatId: event.message.chatId,
          senderId: event.message.senderId,
          content: event.message.content,
          messageType: event.message.messageType,
          fileUrl: event.message.fileUrl,
          status: 'sent',
          sentAt: DateTime.now(),
          deliveredAt: null,
          seenAt: null,
          seenBy: [],
          reactions: [],
        );
        current.add(temp);
        emit(MessagesLoaded(messages: current));
      }

      final sent = await repo.sendMessage(event.message);
      socket.emit('send-message', sent.toSendPayload());
    } catch (e) {
      emit(MessagesFailure(e.toString()));
    }
  }


  Future<void> _onSubscribe(SubscribeChatStream event, Emitter<MessagesState> emit) async {
    socket.on('new-message', (data) {
      add(IncomingSocketMessage(Message.fromJson(data)));
    });
  }

  Future<void> _onIncoming(IncomingSocketMessage event, Emitter<MessagesState> emit) async {
    if (state is MessagesLoaded) {
      final current = List<Message>.from((state as MessagesLoaded).messages);
      current.add(event.message);
      emit(MessagesLoaded(messages: current));
    }
  }
}
