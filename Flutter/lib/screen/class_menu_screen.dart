import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/category_grid.dart';
import 'package:fingo/widget/topic_of_the_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/class_provider.dart';

class ClassMenuScreen extends StatefulWidget {
  const ClassMenuScreen({super.key});

  @override
  State<ClassMenuScreen> createState() => _ClassMenuScreenState();
}

class _ClassMenuScreenState extends State<ClassMenuScreen>  {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopicOfTheDay(),
            CategoryGrid(
              isClass: true,
            )
          ],
        ),
      ),
    );
  }

}
