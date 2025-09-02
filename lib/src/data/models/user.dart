import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String role;
  final String token;

  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return AppUser(
      id: data['user']?['_id']?.toString() ?? '',
      email: data['user']?['email']?.toString() ?? '',
      role: data['user']?['role']?.toString() ?? '',
      token: data['token']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role,
    'token': token,
  };

  @override
  List<Object?> get props => [id, email, role, token];
}
