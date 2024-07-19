import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro_app/controllers/user_controller.dart';
import 'package:tadbiro_app/ui/screens/authentication/register_screen.dart';
import 'package:tadbiro_app/ui/widgets/custom_textfornfield.dart';
import 'package:tadbiro_app/utils/app_color.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _showForgotPasswordDialog() {
    final forgotPasswordEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Forgot Password',
            style: TextStyle(color: AppColor.orange),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: forgotPasswordEmailController,
                labelText: 'Email',
                validator: _validateEmail,
                obscureText: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
              onPressed: () {
                if (_validateEmail(forgotPasswordEmailController.text) ==
                    null) {
                  UserController()
                      .resetPasswordUser(forgotPasswordEmailController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Reset Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png"),
                  Text(
                    "Tadbiro",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.orange,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(30),
                  const Text(
                    "Tizimga Kirish",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextFormField(
                    icon: Icons.email,
                    controller: _emailController,
                    labelText: 'Email',
                    validator: _validateEmail,
                    obscureText: false,
                  ),
                  CustomTextFormField(
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: _validatePassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.orange),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        UserController().logInUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.orange,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
