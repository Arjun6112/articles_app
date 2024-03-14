import 'package:articles_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:articles_app/core/error/app_secrets.dart';
import 'package:articles_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:articles_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:articles_app/features/auth/domain/repository/auth_repository.dart';
import 'package:articles_app/features/auth/domain/usecases/current_user.dart';
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

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    ..registerFactory(() => UserSignup(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(() => AuthBloc(
          currentUser: serviceLocator(),
          userSignup: serviceLocator(),
          userLogin: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}
