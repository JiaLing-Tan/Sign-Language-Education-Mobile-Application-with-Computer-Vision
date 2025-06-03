import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CustomizedTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomizedTextBox({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(

        width: _width * 0.90,
        height: _height - 370,
        decoration: BoxDecoration(

          color: AppTheme.mainBlue.withAlpha(15),
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:  10, horizontal: 15),
          child: TextField(
            maxLines: null,
            expands: true,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
