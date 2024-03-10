import 'package:articles_app/core/error/exceptions.dart';
import 'package:articles_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, String>> loginWithemailandPassword(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpwithEmailandPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final userId = await authRemoteDataSource.signUpwithEmailandPassword(
          email: email, password: password, name: name);

      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
