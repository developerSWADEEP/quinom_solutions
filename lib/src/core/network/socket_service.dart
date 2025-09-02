import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String baseUrl;
  IO.Socket? _socket;

  SocketService({required this.baseUrl});

  void connect({required String userId, String path = '/socket.io/'}) {
    _socket = IO.io(baseUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
      'path': path,
      'query': {'userId': userId},
    });
    _socket!.connect();
  }

  void on(String event, void Function(dynamic) handler) => _socket?.on(event, handler);

  void emit(String event, dynamic data) => _socket?.emit(event, data);

  void disconnect() => _socket?.disconnect();
}
