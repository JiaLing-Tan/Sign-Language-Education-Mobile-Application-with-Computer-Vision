import 'package:fingo/model/student.dart';
import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/resource/CRUD/lesson_controller.dart';
import 'package:fingo/resource/CRUD/progress_controller.dart';
import 'package:fingo/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/lesson.dart';
import '../provider/class_provider.dart';
import '../provider/exam_provider.dart';
import '../resource/CRUD/student_controller.dart';
import '../resource/auth_method.dart';
import '../screen/class_screen.dart';
import '../screen/exam_screen.dart';
import '../utils/image.dart';
import '../utils/utils.dart';

class TopicOfTheDay extends StatefulWidget {
  final bool isClass;

  const TopicOfTheDay({super.key, this.isClass = true});

  @override
  State<TopicOfTheDay> createState() => _TopicOfTheDayState();
}

class _TopicOfTheDayState extends State<TopicOfTheDay> {
  bool _isLoading = true;
  Lesson? _lesson;
  String _topic = "";
  String _subTopic = "";

  @override
  void initState() {
    super.initState();
    loadTopic();
  }

  loadTopic() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      LessonController lessonController = LessonController();

      _lesson = await lessonController.getClass(userProvider.user.nextTopic);

      final RegExp regex = RegExp(r'^(.*?) \((.*?)\)$');
      final match = regex.firstMatch(_lesson!.name);

      _topic = match!.group(1)!;
      _subTopic = match.group(2)!;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading topic: $e');

        setState(() {
          _isLoading = false;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          if (_lesson != null) {
            if (widget.isClass) {
              classProvider.clearClassWord();
              classProvider.setIsLoading();

              classProvider.setClassWord(_lesson!);
              navigateToScreen(context, const ClassScreen());
            } else {
              examProvider.clearExamWord();
              examProvider.setIsLoading();
              examProvider.setExamWord(_lesson!);
              navigateToScreen(context, ExamScreen());
            }
          }
        },
        child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: AppTheme.widgetDeco(
                color:
                    widget.isClass ? AppTheme.mainOrange : AppTheme.mainBlue),
            child: Row(
              children: _isLoading || _lesson == null
                  ? [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    ]
                  : [
                      networkImage(
                        _lesson!.imageUrl,
                         _width / 3.5,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isClass
                                ? "Lesson of the Day"
                                : "Evaluation time!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "$_topic\n$_subTopic",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      )
                    ],
            )),
      ),
    );
  }
}
