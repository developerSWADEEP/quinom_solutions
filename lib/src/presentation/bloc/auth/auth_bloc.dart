import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  AuthBloc(this.repo) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthAppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) async {}

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repo.login(email: event.email, password: event.password, role: event.role);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['status'] == 'authed') {
        return AuthAuthenticated(AppUser(
          id: json['user']['id'],
          email: json['user']['email'],
          role: json['user']['role'],
          token: json['user']['token'],
        ));
      }
      return AuthInitial();
    } catch (_) {
      return AuthInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthAuthenticated) {
      return {
        'status': 'authed',
        'user': state.user.toJson(),
      };
    }
    return {'status': 'unauthed'};
  }
}
