import 'package:fingo/provider/exam_provider.dart';
import 'package:fingo/widget/evaluate_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/word.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import 'class_display_screen.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool _isShowingDialog = false;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context, listen: true);
    List<Word> examWord = examProvider.examWord;
    examProvider.setContext(context);
    examProvider.setPageController(_pageController);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) {
        if (_isShowingDialog || examProvider.isInCompletionScreen) return;

        _isShowingDialog = true;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            showBackDialog(
                function: () {
                  Navigator.of(context).pop();
                },
                context: context,
                question:
                    "Are you sure you want to leave? \nAll progress will be discarded!");
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(
          actions: [
            GestureDetector(
              child: Icon(Icons.skip_next),
              onTap: () {
                examProvider.nextPage();
              },
            )
          ],
        ),
        body: examProvider.examWord.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mainBlue,
                ),
              )
            : PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                controller: examProvider.pageController,
                itemBuilder: (context, index) {
                  _isShowingDialog = false;
                  final wordIndex = index ~/ 2;
                  final isEvaluatePage = index % 2 == 0;

                  if (isEvaluatePage) {
                    return EvaluateWidget(
                      targetSign: examWord
                          .elementAt(wordIndex)
                          .eng
                          .toLowerCase()
                          .trim(),
                    );
                  } else {
                    return ClassDisplayScreen(
                      word: examWord.elementAt(wordIndex),
                      isExam: true,
                    );
                  }
                }),
      ),
    );
  }
}
