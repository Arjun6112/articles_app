part of 'init_dependencies.dart';


final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecrets.SupabaseUrl, anonKey: AppSecrets.SupabaseAnonKey);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogBox'));

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
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

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
        serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(() =>
        BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()));
}