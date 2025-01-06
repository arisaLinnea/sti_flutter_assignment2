part of 'auth_bloc.dart';

enum RegStatus { ok, loading }

enum AuthStatus { unauthorized, loading, authenticated }

abstract class AuthState extends Equatable {
  late final AuthStatus status;
  late final Owner user;

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthFailedState extends AuthState {
  final String message;

  AuthFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthAuthenticatedState extends AuthState {
  // final Owner user;

  AuthAuthenticatedState({required newUser}) {
    user = newUser;
  }

  @override
  List<Object?> get props => [user];
}

class AuthUnauthorizedState extends AuthState {}

class AuthRegistrationState extends AuthState {
  // final RegStatus status;

  AuthRegistrationState({required newStatus}) {
    status = newStatus;
  }

  @override
  List<Object?> get props => [status];
}
