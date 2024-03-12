import 'package:articles_app/core/error/app_secrets.dart';
import 'package:articles_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:articles_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:articles_app/features/auth/domain/repository/auth_repository.dart';
import 'package:articles_app/features/auth/domain/usecases/user_login.dart';
import 'package:articles_app/features/auth/domain/usecases/user_signup.dart';
import 'package:articles_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
      url: AppSecrets.SupabaseUrl, anonKey: AppSecrets.SupabaseAnonKey);
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()));

  serviceLocator.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignup(serviceLocator()));
  serviceLocator.registerFactory(() => UserLogin(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignup: serviceLocator(),
        userLogin: serviceLocator(),
      ));
}
