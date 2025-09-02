part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  AuthLoginRequested({required this.email, required this.password, required this.role});
}

class AuthLogoutRequested extends AuthEvent {}