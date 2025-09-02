import '../../core/network/api_client.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiClient _api;
  AuthRepository(this._api);

  Future<AppUser> login({required String email, required String password, required String role}) async {
    final res = await _api.post('/user/login', data: {
      'email': email,
      'password': password,
      'role': role,
    });
    final data = res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : (res.data as dynamic);
    final user = AppUser.fromJson(data);
    _api.setToken(user.token);
    return user;
  }
}