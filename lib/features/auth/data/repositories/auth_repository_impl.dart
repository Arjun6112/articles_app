import 'package:articles_app/core/error/exceptions.dart';
import 'package:articles_app/core/network/connection_checker.dart';
import 'package:articles_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:articles_app/core/common/entities/user.dart';
import 'package:articles_app/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.authRemoteDataSource, this.connectionChecker);

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
      if (!await connectionChecker.hasConnection) {
        return left(Failure("No internet connection"));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    try {
      if (!await connectionChecker.hasConnection) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure("User not found"));
        }
        return right(UserModel(
            id: session.user.id, email: session.user.email ?? '', name: ''));
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User not found"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
