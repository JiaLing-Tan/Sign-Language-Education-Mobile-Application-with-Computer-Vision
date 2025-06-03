import 'package:fingo/screen/Fingerspelling_screen.dart';
import 'package:fingo/screen/class_menu_screen.dart';
import 'package:fingo/screen/exam_menu_screen.dart';
import 'package:fingo/screen/learning_path_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';

class CvMenu extends StatefulWidget {
  const CvMenu({super.key});

  @override
  State<CvMenu> createState() => _CvMenuState();
}

class _CvMenuState extends State<CvMenu> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: DefaultTabController(
        initialIndex: 1,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              bottom: TabBar(
                  indicatorColor: AppTheme.mainBlue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicatorPadding: EdgeInsets.symmetric(vertical: 10),
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  tabs: [

                    Text(
                      "Evaluation",
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.grayText),
                    ),
                    Text(
                      "Class",
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.grayText),
                    ),
                    Text(
                      "Fingerspelling",
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.grayText),
                    )
                  ]),
            ),
            body: TabBarView(children: [ExamMenuScreen(), ClassMenuScreen(), FingerspellingScreen()]),
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.route_rounded),
          foregroundColor: Colors.white,
          backgroundColor: AppTheme.mainOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          heroTag: "learningPathButton",
          onPressed: () {
            navigateToScreen(context, LearningPathScreen(),"/learningPath");
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
