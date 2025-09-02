import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/chat.dart';
import '../../../data/repositories/chat_repository.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository repo;
  ChatsBloc(this.repo) : super(ChatsInitial()) {
    on<FetchChats>(_onFetch);
  }

  Future<void> _onFetch(FetchChats event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading());
    try {
      final chats = await repo.getUserChats(event.userId);
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatsFailure(e.toString()));
    }
  }
}