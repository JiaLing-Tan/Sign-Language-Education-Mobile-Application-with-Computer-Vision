import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/category_grid.dart';
import 'package:fingo/widget/category_widget.dart';
import 'package:fingo/widget/topic_of_the_day.dart';
import 'package:flutter/material.dart';

class ExamMenuScreen extends StatefulWidget {
  const ExamMenuScreen({super.key});

  @override
  State<ExamMenuScreen> createState() => _ExamMenuScreenState();
}

class _ExamMenuScreenState extends State<ExamMenuScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopicOfTheDay(
              isClass: false,
            ),
            CategoryGrid(
              isClass: false,
            )
          ],
        ),
      ),
    );
  }
}
