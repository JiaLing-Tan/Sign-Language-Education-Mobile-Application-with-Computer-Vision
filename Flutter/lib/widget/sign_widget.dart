import 'package:fingo/model/word.dart';
import 'package:fingo/screen/class_display_screen.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class SignWidget extends StatelessWidget {
  final Word word;
  final int index;

  const SignWidget({super.key, required this.word, required this.index});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: _width/12,
              width: _width/12,
              decoration: BoxDecoration(

                color: AppTheme.mainBlue,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(index.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 14)),
              ),
            ),
            SizedBox(width: 15,),
            Container(
              width:  _width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(word.eng,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.grayText,
                          fontSize: 15)),
                  Text(word.my,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.grayText?.withAlpha(100),
                          fontSize: 13))
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            navigateToScreen(
                context,
                Scaffold(
                    appBar: AppBar(),
                    body: Center(
                        child: ClassDisplayScreen(
                      word: word,
                      isDisplay: true,
                    ))));
          },
          child: Text(
            "View",
            style: TextStyle(
                color: AppTheme.grayText?.withAlpha(100),
                fontSize: 15,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
