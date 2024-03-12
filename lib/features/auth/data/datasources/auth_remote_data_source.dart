import 'package:articles_app/core/error/exceptions.dart';
import 'package:articles_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpwithEmailandPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> loginWithemailandPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithemailandPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw ServerException(message: "Error logging in");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpwithEmailandPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {'name': name});

      if (response.user == null) {
        throw ServerException(message: "User not created");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
