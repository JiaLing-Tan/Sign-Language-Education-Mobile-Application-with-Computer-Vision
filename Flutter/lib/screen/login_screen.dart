import 'package:fingo/layout/layout.dart';
import 'package:fingo/resource/auth_method.dart';
import 'package:fingo/screen/register_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:fingo/widget/customized_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authService = Authentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await authService.signInWithEmailPassword(email, password);
      } else {
        showSnackBar("Please fill in both email and password!", context,
            duration: 2);
      }
    } catch (e) {
        showSnackBar("Please try again with valid credentials!", context,
            duration: 2);

    }
    setState(() {
      _isLoading = false;
    });
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
            Text("Login",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27)),
            SizedBox(
              height: 10,
            ),
            Text("Welcome back!", style: TextStyle(fontSize: 14)),
            Image.asset(
              "lib/image/register_logo.png",
              width: _width / 1.5,
            ),
            CustomizedTextField(
                controller: _emailController,
                hintText: "Email",
                textInputType: TextInputType.text), // email field
            SizedBox(
              height: 15,
            ),
            CustomizedTextField(
                controller: _passwordController,
                hintText: "Password",
                isPassword: true,
                textInputType: TextInputType.text), // password field
            SizedBox(
              height: 15,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: CustomizedButton(
                func: login,
                color: AppTheme.mainBlue,
                width: double.infinity,
                title: "Login",
                isLoading: _isLoading,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New user?"),
                  GestureDetector(
                    onTap: () {
                      navigateToScreen(context, const RegisterScreen());
                    },
                    child: Text(
                      "Click here to sign up!",
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
