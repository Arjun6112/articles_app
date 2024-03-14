import 'package:articles_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:articles_app/core/usecase/usecase.dart';
import 'package:articles_app/core/common/entities/user.dart';
import 'package:articles_app/features/auth/domain/usecases/current_user.dart';
import 'package:articles_app/features/auth/domain/usecases/user_login.dart';
import 'package:articles_app/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserLogin userLogin,
    required UserSignup userSignup,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignup = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignup>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthUserLoginStatus>(_onAuthUserLoginStatus);
  }

  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
    final response = await _userSignup(UserSignUpParams(
        email: event.email, password: event.password, name: event.name));
    response.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (user) {
      emitAuthSuccess(user, emit);
    });
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final response = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    response.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (user) {
      emitAuthSuccess(user, emit);
    });
  }

  void _onAuthUserLoginStatus(
      AuthUserLoginStatus event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
        (l) => emit(AuthFailure(l.message)), (r) => emitAuthSuccess(r, emit));
  }

  void emitAuthSuccess(User user, Emitter<AuthState> emit) {
    emit(AuthSuccess(user));
    _appUserCubit.updateUser(user);
  }
}
