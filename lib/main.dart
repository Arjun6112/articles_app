import 'package:articles_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:articles_app/core/theme/theme.dart';

import 'package:articles_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:articles_app/features/auth/presentation/pages/login_page.dart';
import 'package:articles_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:articles_app/features/blog/presentation/pages/blog_pages.dart';
import 'package:articles_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthUserLoginStatus());
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Articulate',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          return isLoggedIn ? const BlogPage() : const LoginPage();
        },
      ),
    );
  }
}
