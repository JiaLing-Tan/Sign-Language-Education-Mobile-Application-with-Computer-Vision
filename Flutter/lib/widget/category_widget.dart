import 'package:fingo/provider/class_provider.dart';
import 'package:fingo/provider/exam_provider.dart';
import 'package:fingo/provider/learning_path_provider.dart';
import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/screen/class_screen.dart';
import 'package:fingo/screen/exam_screen.dart';
import 'package:fingo/utils/image.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:fingo/widget/sign_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/lesson.dart';

class CategoryWidget extends StatefulWidget {
  final Lesson lesson;
  final bool isClass;
  final bool isPath;
  final bool isExpanded;

  const CategoryWidget(
      {super.key,
      required this.lesson,
      required this.isClass,
      this.isPath = false,
      this.isExpanded = false});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final learningPathProvider =
        Provider.of<LearningPathProvider>(context, listen: true);
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    int? selectedIndex = learningPathProvider.selectedId;
    bool _classComplete = userProvider.user.progress
            .where((progress) =>
                progress.classId == widget.lesson.id &&
                progress.classState == "completed")
            .toList()
            .length >
        0;

    bool _testComplete = userProvider.user.progress
            .where((progress) =>
                progress.classId == widget.lesson.id &&
                progress.examState == "completed")
            .toList()
            .length >
        0;

    navigateToExam() {
      examProvider.clearExamWord();
      examProvider.setIsLoading();
      examProvider.setExamWord(widget.lesson);
      navigateToScreen(context, const ExamScreen());
    }

    navigateToClass() {
      print("here");
      classProvider.setIsLoading();
      classProvider.clearClassWord();
      classProvider.setClassWord(widget.lesson);
      if (classProvider.classWord != []) {
        navigateToScreen(context, const ClassScreen(), "/classscreen");
      }
    }

    print("-----------------------------------------");
    print(_testComplete);
    print(_classComplete);
    print("-----------------------------------------");

    if (widget.isPath) {
      return GestureDetector(
        onTap: () {
          if (selectedIndex == null || selectedIndex != widget.lesson.id) {
            learningPathProvider.setSelectedId(widget.lesson);
          } else {
            learningPathProvider.setSelectedId(null);
          }
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: AppTheme.widgetDeco(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      networkImage(
                        widget.lesson.imageUrl,
                        _width / 5,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            widget.lesson.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.grayText),
                          ),
                          Row(
                            children: [
                              _classComplete
                                  ? Icon(Icons.star_rounded)
                                  : Icon(Icons.star_border_rounded),
                              _testComplete
                                  ? Icon(Icons.star_rounded)
                                  : Icon(Icons.star_border_rounded)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Icon(learningPathProvider.selectedId == widget.lesson.id
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded)
                ],
              ),
            ),
            if (learningPathProvider.selectedId == widget.lesson.id)
              Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Class",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.grayText,
                                  fontSize: 15),
                            ),
                            Text(
                              _classComplete ? "Completed" : "Uncompleted",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        CustomizedButton(
                          func: navigateToClass,
                          color: _classComplete
                              ? Colors.grey
                              : AppTheme.mainOrange,
                          title: _classComplete ? "Revisit" : "Go Complete",
                          // titleColor: _classComplete? AppTheme.grayText!: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Evaluation",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.grayText,
                                  fontSize: 15),
                            ),
                            Text(
                              _testComplete ? "Completed" : "Uncompleted",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        CustomizedButton(
                          func: navigateToExam,
                          color:
                              _testComplete ? Colors.grey : AppTheme.mainBlue,
                          title: _testComplete ? "Revisit" : "Go Complete",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Divider(color: Colors.black, height: 1, thickness: 0.5,),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Sign List",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.grayText,
                            fontSize: 20)),
                  ),
                  learningPathProvider.isLoading
                      ? CircularProgressIndicator(color: AppTheme.mainOrange,)
                      : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: learningPathProvider.classWord.length,
                            itemBuilder: (_, index) {
                              final word = learningPathProvider.classWord[index];
                              return SignWidget(word: word,index: index+1,);
                            },
                          ),
                      )
                ],
              )
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (widget.isClass) {
            navigateToClass();
          } else {
            navigateToExam();
          }
        },
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: AppTheme.widgetDeco(),
          child: Stack(
            children: [
              if ((widget.isClass && _classComplete) ||
                  (!widget.isClass && _testComplete))
                Positioned(
                    right: 10,
                    top: 10,
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    networkImage(
                      widget.lesson.imageUrl,
                      _width / 4,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.lesson.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.grayText),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
