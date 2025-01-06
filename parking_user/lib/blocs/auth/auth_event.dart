part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String ssn;
  final String username;
  final String password;

  AuthRegisterEvent({
    required this.name,
    required this.ssn,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [name, ssn, username, password];
}

class AuthLogoutEvent extends AuthEvent {}
