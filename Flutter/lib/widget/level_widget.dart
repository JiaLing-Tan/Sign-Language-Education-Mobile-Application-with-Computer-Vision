import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../model/student.dart';

class LevelWidget extends StatefulWidget {
  const LevelWidget({super.key});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(15),
      height: 110,
      decoration: AppTheme.widgetDeco(color: AppTheme.mainBlue),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30, right: 5, top: 43),

            decoration: AppTheme.widgetDeco(),
            height: 20,
            width: double.infinity,
            child: GFProgressBar(
              percentage:
                  userProvider.user.exp / (userProvider.user.level * 80),
              lineHeight: 20,
              alignment: MainAxisAlignment.spaceBetween,
              // leading  : Icon( Icons.sentiment_dissatisfied, color: Colors.red),
              // trailing: Icon( Icons.sentiment_satisfied, color: Colors.green),
              // animation: true,
              // animationDuration: 5000,
              // animateFromLastPercentage: true ,
              backgroundColor: Colors.white,
              progressBarColor: AppTheme.mainOrange,
              child: Text(
                "${userProvider.user.exp}/${userProvider.user.level * 80} exp",
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            // child: Text("${userProvider.user.exp}/${userProvider.user.level*80} exp"),
          ),
          Image.asset(
            "lib/image/heart.png",
            width: 75,
          ),
          Positioned(
            bottom: 35,
            left: 85.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level ${userProvider.user.level}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5 ),
                ),
                Text(
                  "${levelToRole[userProvider.user.level ~/ 5]} !",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
