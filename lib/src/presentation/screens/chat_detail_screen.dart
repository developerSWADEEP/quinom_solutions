import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/messages/messages_bloc.dart';
import '../../data/models/message.dart';
import '../../core/network/socket_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state as AuthAuthenticated;
    context.read<MessagesBloc>().add(FetchMessages(widget.chatId));

    final socket = context.read<SocketService>();
    socket.connect(userId: auth.user.id);
    context.read<MessagesBloc>().add(SubscribeChatStream(widget.chatId));
  }

  @override
  void dispose() {
    context.read<SocketService>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = (context.watch<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                if (state is MessagesLoading) return const Center(child: CircularProgressIndicator());
                if (state is MessagesFailure) return Center(child: Text('Error: ${state.message}'));
                if (state is MessagesLoaded) {
                  final msgs = state.messages;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    itemCount: msgs.length,
                    itemBuilder: (context, i) {
                      final m = msgs[i];
                      final isMine = m.senderId == auth.id;
                      return Align(
                        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMine ? Colors.indigo.shade100 : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(m.content),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    final msg = Message(
                      id: '',
                      chatId: widget.chatId,
                      senderId: auth.id,
                      content: text,
                      messageType: 'text',
                      fileUrl: '',
                      status: 'sent',
                      sentAt: DateTime.now(),
                      deliveredAt: null,
                      seenAt: null,
                      seenBy: [],
                      reactions: [],
                    );
                    context.read<MessagesBloc>().add(SendMessageEvent(msg));
                    _controller.clear();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}