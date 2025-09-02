import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/chats_screen.dart';
import '../screens/chat_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, st) => const LoginScreen(),
      ),
      GoRoute(
        path: '/chats',
        builder: (ctx, st) => const ChatsScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (ctx, st) => ChatDetailScreen(chatId: st.pathParameters['id']!),
      ),
    ],
  );
}