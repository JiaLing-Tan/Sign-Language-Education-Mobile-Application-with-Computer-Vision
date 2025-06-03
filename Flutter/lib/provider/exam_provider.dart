import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../model/lesson.dart';
import '../model/word.dart';
import '../resource/CRUD/word_controller.dart';
import '../screen/completion_screen.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class ExamProvider extends ChangeNotifier {
  late PageController _pageController;
  final WordController _wordController = WordController();
  int _activePage = 0;
  List<Word> _examWord = [];
  bool _isLoading = false;
  bool _isCorrect = false;
  String _feedback = "";
  late BuildContext _context;
  String _detected = "";
  late Lesson _lesson;
  bool _isInCompletionScreen = false;

  bool get isInCompletionScreen => _isInCompletionScreen;

  List<Word> get examWord => _examWord;

  PageController get pageController => _pageController;

  int get activePage => _activePage;

  bool get isLoading => _isLoading;

  bool get isCorrect => _isCorrect;

  String get detected => _detected;

  String get feedback => _feedback;

  setContext(BuildContext context) {
    _context = context;
  }

  setPageController(PageController pageController) {
    _pageController = pageController;
  }


  Future<void> setExamWord(Lesson lesson) async {
    _lesson = lesson;
    _examWord = await _wordController.getWordList(lesson.id);
    _isInCompletionScreen = false;
    setIsLoading();
  }

  setIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  setFeedback(String feedback){
    _feedback = feedback;
  }

  setIsCorrect(bool isCorrect) {
    _isCorrect = isCorrect;
    notifyListeners();
  }

  setDetected(String detected) {
    _detected = detected;
    notifyListeners();
  }

  clearExamWord() {
    _activePage = 0;
    _examWord = [];
    notifyListeners();
  }

  void previousPage() {
    _activePage -= 1;
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

  void nextPage() {
    if (_activePage == 9) {
      _activePage = 0;
      clearExamWord();
      if (!_isInCompletionScreen) {
        _isInCompletionScreen = true;
        navigateToScreen(
            _context,
            CompletionScreen(
              isClass: false,
              lesson: _lesson,
            ));
      }
    } else {
      _activePage += 1;
      if(_activePage%2 == 1) {
        Flushbar(
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: AppTheme.mainBlue,
          messageText: Text(
            feedback,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          // message:  "Not enough coins!",
          duration: Duration(seconds: 1),
        )..show(_context);
      }
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    notifyListeners();
  }


}
