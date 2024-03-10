import 'package:fpdart/fpdart.dart';

import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/core/usecase/usecase.dart';
import 'package:articles_app/features/auth/domain/repository/auth_repository.dart';

class UserSignup implements Usecase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRepository.signUpwithEmailandPassword(
        email: params.email, password: params.password, name: params.name);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams(
      {required this.email, required this.password, required this.name});
}
