import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpwithEmailandPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, User>> loginWithemailandPassword({
    required String email,
    required String password,
  });
}
