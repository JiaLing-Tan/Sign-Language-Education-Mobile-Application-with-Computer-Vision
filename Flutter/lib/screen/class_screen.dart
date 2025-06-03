import 'package:fingo/provider/class_provider.dart';
import 'package:fingo/screen/class_fitb_screen.dart';
import 'package:fingo/screen/class_mcq_screen.dart';
import 'package:fingo/screen/completion_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'class_display_screen.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  bool _isShowingDialog = false;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context, listen: true);
    List classWord = classProvider.classWord;
    classProvider.setContext(context);
    classProvider.setPageController(_pageController);


    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) {
        if (_isShowingDialog || classProvider.isInCompletionScreen) return;
        _isShowingDialog = true;
        showBackDialog(
            function: () {
              Navigator.of(context).pop();
            },
            context: context,
            question:
                "Are you sure you want to leave? \nAll progress will be discarded!");
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(
          actions: [
            GestureDetector(
              child: Icon(Icons.skip_next),
              onTap: () {
                classProvider.nextPage();
              },
            )
          ],
        ),
        body: classProvider.classWord.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mainOrange,
                ),
              )
            : PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 15,
                controller: classProvider.pageController,
                itemBuilder: (context, index) {
                  _isShowingDialog = false;
                  List<Widget> _classStructure = [
                    ClassDisplayScreen(word: classWord.elementAt(0)),
                    ClassMcqScreen(word: classWord.elementAt(0)),
                    ClassDisplayScreen(word: classWord.elementAt(1)),
                    ClassMcqScreen(word: classWord.elementAt(1)),
                    ClassDisplayScreen(word: classWord.elementAt(2)),
                    ClassFitbScreen(word: classWord.elementAt(0)),
                    ClassMcqScreen(word: classWord.elementAt(2)),
                    ClassDisplayScreen(word: classWord.elementAt(3)),
                    ClassFitbScreen(word: classWord.elementAt(1)),
                    ClassMcqScreen(word: classWord.elementAt(3)),
                    ClassDisplayScreen(word: classWord.elementAt(4)),
                    ClassMcqScreen(word: classWord.elementAt(4)),
                    ClassFitbScreen(word: classWord.elementAt(2)),
                    ClassFitbScreen(word: classWord.elementAt(3)),
                    ClassFitbScreen(word: classWord.elementAt(4)),
                  ];
                  return _classStructure.elementAt(index);
                }),
      ),
    );
  }
}
