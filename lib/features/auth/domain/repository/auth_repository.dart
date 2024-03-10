import 'package:articles_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpwithEmailandPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, String>> loginWithemailandPassword({
    required String email,
    required String password,
  });
}
