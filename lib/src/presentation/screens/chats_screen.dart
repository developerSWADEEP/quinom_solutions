import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/chats/chats_bloc.dart';
import '../router/app_router.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    context.read<ChatsBloc>().add(FetchChats(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chats'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                context.go('/');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoading) return const Center(child: CircularProgressIndicator());
          if (state is ChatsFailure) return Center(child: Text('Error: ${state.message}'));
          if (state is ChatsLoaded) {
            if (state.chats.isEmpty) return const Center(child: Text('No chats found'));
            return ListView.separated(
              itemCount: state.chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = state.chats[i];
                return ListTile(
                  title: Text(c.otherUserName, style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(c.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(TimeOfDay.fromDateTime(c.updatedAt.toLocal()).format(context)),
                  onTap: () => context.push('/chat/${c.id}'),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}