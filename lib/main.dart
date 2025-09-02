import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'src/core/network/api_client.dart';
import 'src/core/network/socket_service.dart';
import 'src/data/repositories/auth_repository.dart';
import 'src/data/repositories/chat_repository.dart';
import 'src/presentation/bloc/auth/auth_bloc.dart';
import 'src/presentation/bloc/chats/chats_bloc.dart';
import 'src/presentation/bloc/messages/messages_bloc.dart';
import 'src/presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(dir.path),
  );

  final apiClient = ApiClient();
  final socketService = SocketService(baseUrl: ApiClient.baseUrl);

  final authRepo = AuthRepository(apiClient);
  final chatRepo = ChatRepository(apiClient);

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: authRepo),
      RepositoryProvider.value(value: chatRepo),
      RepositoryProvider.value(value: socketService),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo)..add(AuthAppStarted())),
        BlocProvider(create: (_) => ChatsBloc(chatRepo)),
        BlocProvider(create: (_) => MessagesBloc(chatRepo, socketService)),
      ],
      child: const ChatApp(),
    ),
  ));
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat App (BLoC + MVVM)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
