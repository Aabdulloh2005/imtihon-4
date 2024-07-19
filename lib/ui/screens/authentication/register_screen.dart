import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro_app/controllers/user_controller.dart';
import 'package:tadbiro_app/ui/widgets/custom_textfornfield.dart';
import 'package:tadbiro_app/utils/app_color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  const Gap(20),
                  const Text(
                    "Ro'yxatdan O'tish",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    controller: _usernameController,
                    labelText: 'Username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    obscureText: false,
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
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: _validatePassword,
                    obscureText: true,
                  ),
                  CustomTextFormField(
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    validator: _validateConfirmPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.orange),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        UserController().registerUser(
                          _emailController.text,
                          _passwordController.text,
                          _usernameController.text,
                          context,
                        );
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
