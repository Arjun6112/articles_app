import 'dart:math';

import 'package:articles_app/core/theme/app_pallete.dart';
import 'package:articles_app/core/theme/blur_animated_background.dart';
import 'package:articles_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:articles_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:articles_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static route() => MaterialPageRoute(builder: (context) => const SignupPage());

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const BlurAnimationBG(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      AuthField(hintText: "Name", controller: _nameController),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: "Email",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: "Password",
                        controller: _passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(height: 40),
                      AuthGradientButton(
                          buttonText: "Sign up",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthSignup(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  name: _nameController.text.trim()));
                            }
                          }),
                      const SizedBox(height: 60),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(fontSize: 16)),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppPallete.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
