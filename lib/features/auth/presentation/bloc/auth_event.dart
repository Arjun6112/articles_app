part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignup({required this.email, required this.password, required this.name});
}
