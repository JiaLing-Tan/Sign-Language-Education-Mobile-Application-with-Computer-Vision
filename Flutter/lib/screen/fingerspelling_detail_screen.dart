import 'package:flutter/material.dart';

import '../model/word.dart';
import '../resource/CRUD/word_controller.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import 'class_display_screen.dart';

class FingerspellingDetailScreen extends StatefulWidget {
  final int currentIndex;

  const FingerspellingDetailScreen({super.key, required this.currentIndex});

  @override
  State<FingerspellingDetailScreen> createState() =>
      _FingerspellingDetailScreenState();
}

class _FingerspellingDetailScreenState
    extends State<FingerspellingDetailScreen> {
  WordController _wordController = WordController();
  Word? _word;
  bool _isLoading = true;

  Future<void> getWord(int currentIndex) async {
    setState(() {
      _isLoading = true;
    });

    final alphabet = alphabetMap.keys.elementAt(currentIndex);

    Word fetchedWord =
        await _wordController.getWordById(alphabetMap[alphabet]!);
    setState(() {
      _word = fetchedWord;
      _isLoading = false;
    });
  }

  void navigateToAlphabet(int newIndex) {
    if (newIndex < 0) {
      newIndex = alphabetMap.length - 1;
    } else if (newIndex >= alphabetMap.length) {
      newIndex = 0;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FingerspellingDetailScreen(
          currentIndex: newIndex,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getWord(widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mainBlue,
                ),
              )
            : Center(
                child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: _width / 1.2,),
                    child: Container(
                      height: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.chevron_left_rounded, size: 36),
                            ),
                            onTap: () {
                              navigateToAlphabet(widget.currentIndex - 1);
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.chevron_right_rounded, size: 36),
                            ),
                            onTap: () {
                              navigateToAlphabet(widget.currentIndex + 1);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: ClassDisplayScreen(
                      word: _word!,
                      isDisplay: true,
                    ),
                  ),

                ],
              )));
  }
}
