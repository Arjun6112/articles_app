import 'package:articles_app/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  AuthBloc({
    required UserSignup userSignup,
  })  : _userSignup = userSignup,
        super(AuthInitial()) {
    on<AuthSignup>((event, emit) async {
      final response = await _userSignup(UserSignUpParams(
          email: event.email, password: event.password, name: event.name));
      response.fold((failure) {
        

        emit(AuthFailure(message: failure.message));
      }, (message) {
        emit(AuthSuccess(message: message));
      });
    });
  }
}
