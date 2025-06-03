import 'package:fingo/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomizedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType textInputType;
  final double height;
  final double horizontalPadding;

  const CustomizedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    this.isPassword = false,
    this.height = 50,
    this.horizontalPadding = 30
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: height,
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: controller,
          obscureText: isPassword,
          keyboardType: textInputType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.mainBlue),
              borderRadius: BorderRadius.circular(20.0),
            ),
            fillColor: AppTheme.mainBlue.withAlpha(15),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),
      ),
    );
  }
}