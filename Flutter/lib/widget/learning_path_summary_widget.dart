import 'package:fingo/model/progress.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/chat_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class LearningPathSummaryWidget extends StatefulWidget {
  const LearningPathSummaryWidget({super.key});

  @override
  State<LearningPathSummaryWidget> createState() =>
      _LearningPathSummaryWidgetState();
}

class _LearningPathSummaryWidgetState extends State<LearningPathSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    List<Progress> progress = userProvider.user.progress;
    int completedClass = progress
        .where((element) => element.classState == "completed")
        .toList()
        .length;
    int completedTest = progress
        .where((element) => element.examState == "completed")
        .toList()
        .length;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: _width / 2 - _width / 3.5),
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: _width / 3.3),
                  decoration: AppTheme.widgetDeco(color: AppTheme.mainOrange),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total star collected",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                              "${completedClass + completedTest}/${progress.length * 2}")
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        decoration: AppTheme.widgetDeco(),
                        height: 20,
                        width: double.infinity,
                        child: GFProgressBar(
                          percentage: (completedClass + completedTest) /
                              (progress.length * 2),
                          lineHeight: 20,
                          alignment: MainAxisAlignment.spaceBetween,
                          backgroundColor: Colors.grey.withAlpha(20),
                          progressBarColor: completedClass + completedTest == 0
                              ? Colors.grey.withAlpha(0)
                              : AppTheme.mainBlue,
                        ),
                        // child: Text("${userProvider.user.exp}/${userProvider.user.level*80} exp"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Class star collected",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text("$completedClass/${progress.length}")
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        decoration: AppTheme.widgetDeco(),
                        height: 20,
                        width: double.infinity,
                        child: GFProgressBar(
                          percentage: completedClass / progress.length,
                          lineHeight: 20,
                          alignment: MainAxisAlignment.spaceBetween,
                          backgroundColor: Colors.grey.withAlpha(20),
                          progressBarColor: completedClass == 0
                              ? Colors.grey.withAlpha(0)
                              : AppTheme.mainBlue,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Evaluation star collected",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text("$completedTest/${progress.length}")
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        decoration: AppTheme.widgetDeco(),
                        height: 20,
                        width: double.infinity,
                        child: GFProgressBar(
                          percentage: completedTest / progress.length,
                          lineHeight: 20,
                          alignment: MainAxisAlignment.spaceBetween,
                          backgroundColor: Colors.grey.withAlpha(20),
                          progressBarColor: completedTest == 0
                              ? Colors.grey.withAlpha(0)
                              : AppTheme.mainBlue,
                        ),
                        // child: Text("${userProvider.user.exp}/${userProvider.user.level*80} exp"),
                      ),
                      SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                ),
              ),
              Image.asset(
                "lib/image/learning_path_bg.png",
                width: _width / 2,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ChatBubbleWidget(
              width: _width,
              reply: completedTest + completedClass == 0
                  ? "Start learning today!"
                  : "Keep it up! You are the BEST! or maybe I should say you are GOATED!"),
        ],
      ),
    );
  }
}
