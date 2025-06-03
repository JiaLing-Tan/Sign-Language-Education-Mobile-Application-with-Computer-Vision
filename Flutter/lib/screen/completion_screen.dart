import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../model/lesson.dart';
import '../provider/class_provider.dart';
import '../provider/exam_provider.dart';
import '../provider/user_provider.dart';
import 'cv_menu.dart';
import 'home_screen.dart';


class CompletionScreen extends StatelessWidget {
  final bool isClass;
  final Lesson lesson;
  // final BuildContext alertContext;

  const CompletionScreen(
      {super.key, required this.isClass, required this.lesson});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    int _coins = isClass ? 100 : 150;
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    return Scaffold(
      body: Container(
        color: isClass
            ? AppTheme.mainOrange.withAlpha(50)
            : AppTheme.mainBlue.withAlpha(30),
        child: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            top: 120,
            child: Lottie.asset(
              "lib/image/confetti-colourful.json",
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Another day,\nanother slay!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 120,
              ),
              Center(
                child: Image.asset(
                  "lib/image/dog.png",
                  width: _width * 0.5,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: AppTheme.widgetDeco(),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "lib/image/paw.png",
                        width: _width * 0.1,
                      ),
                      Text("+ $_coins")
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CustomizedButton(
                func: () {
                  userProvider.updateState(lesson.id, isClass);
                  userProvider.updateCoins(_coins);

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                title: "Claim Reward!",
                color: isClass ? AppTheme.mainOrange : AppTheme.mainBlue,
              )
            ],
          )
        ]),
      ),
    );
  }
}
