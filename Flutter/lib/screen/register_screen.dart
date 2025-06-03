import 'dart:math';

import 'package:fingo/model/student.dart';
import 'package:fingo/resource/CRUD/lesson_controller.dart';
import 'package:fingo/resource/CRUD/progress_controller.dart';
import 'package:fingo/resource/CRUD/student_controller.dart';
import 'package:fingo/resource/auth_method.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:fingo/widget/customized_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authService = Authentication();
  final userController = StudentController();
  final progressController = ProgressController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
  }

  bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }

    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$",
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  void signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmedPassword = _confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar("Please fill in all the information to continue!", context);
      return;
    }

    if (!isValidEmail(email)) {
      showSnackBar("Please use a valid email!", context);
      return;
    }

    if (name.length < 4) {
      showSnackBar("Name should not be less than 4 characters!", context);
      return;
    }

    if (password.length < 8) {
      showSnackBar("Password should not be less than 8 characters!", context);
      return;
    }

    if (password != confirmedPassword) {
      showSnackBar("Passwords don't match!", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? userId =
          await authService.signUpWithEmailPassword(email, password);

      if (userId != null) {
        Student user = Student(
            id: userId,
            createdAt: DateTime.now(),
            name: name,
            profilePic: profileUrl[Random().nextInt(profileUrl.length)]);

        await userController.createUser(user);
        await progressController.createProgress(userId);

        await authService.completeSignUp(email, password);
        showSnackBar("Welcome to Fingo!", context, duration: 2);
        Navigator.pop(context);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      if (e is AuthException) {
        if (e.message == "User already registered") {
          showSnackBar("This email address has already been taken!", context,
              duration: 2);
        } else {
          showSnackBar((e).message, context, duration: 2);
        }
      } else {
        print("huh");

        showSnackBar("Error: $e", context, duration: 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Text("Sign up",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27)),
            SizedBox(
              height: 10,
            ),
            Text("Sign up now and start learning with Fingo!",
                style: TextStyle(fontSize: 14)),
            Image.asset(
              "lib/image/register_logo.png",
              width: _width / 1.5,
            ),
            CustomizedTextField(
                controller: _nameController,
                hintText: "Your name",
                textInputType: TextInputType.text),
            SizedBox(
              height: 15,
            ),
            CustomizedTextField(
                controller: _emailController,
                hintText: "Email",
                textInputType: TextInputType.text),
            SizedBox(
              height: 15,
            ),
            CustomizedTextField(
                controller: _passwordController,
                hintText: "Password",
                // isPassword: true,
                textInputType: TextInputType.text),
            SizedBox(
              height: 15,
            ),
            CustomizedTextField(
                controller: _confirmController,
                hintText: "Confirm password",
                // isPassword: true,
                textInputType: TextInputType.text),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: CustomizedButton(
                isLoading: _isLoading,
                func: signUp,
                color: AppTheme.mainBlue,
                width: double.infinity,
                title: _isLoading ? "Creating Account..." : "Sign Up",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Click here to login!",
                    style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
