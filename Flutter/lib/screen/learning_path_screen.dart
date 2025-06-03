import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/category_grid.dart';
import 'package:fingo/widget/chat_bubble_widget.dart';
import 'package:fingo/widget/learning_path_summary_widget.dart';
import 'package:flutter/material.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(forceMaterialTransparency: true,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              LearningPathSummaryWidget(),
              CategoryGrid(
                isPath: true,
              ),
            ],
          ),
        ));
  }
}
