import 'package:articles_app/core/error/exceptions.dart';
import 'package:articles_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:articles_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithemailandPassword(
      {required String email, required String password}) async {
    return _getUser(() => authRemoteDataSource.loginWithemailandPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, User>> signUpwithEmailandPassword(
      {required String email,
      required String password,
      required String name}) async {
    return _getUser(() => authRemoteDataSource.signUpwithEmailandPassword(
        email: email, password: password, name: name));
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
