import 'package:articles_app/core/theme/app_pallete.dart';
import 'package:articles_app/core/theme/blur_animated_background.dart';
import 'package:articles_app/features/auth/presentation/pages/signup_page.dart';
import 'package:articles_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:articles_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Login',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 50),
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
                      AuthGradientButton(buttonText: "Login", onPressed: () {}),
                      const SizedBox(height: 60),
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, SignupPage.route()),
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "Dont't have an account? ",
                              style: TextStyle(fontSize: 16)),
                          TextSpan(
                            text: "Sign up",
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
