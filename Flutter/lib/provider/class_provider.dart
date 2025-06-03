import 'package:fingo/resource/CRUD/lesson_controller.dart';
import 'package:fingo/resource/CRUD/word_controller.dart';
import 'package:fingo/screen/class_display_screen.dart';
import 'package:fingo/screen/completion_screen.dart';
import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';

import '../model/lesson.dart';
import '../model/word.dart';

class ClassProvider extends ChangeNotifier {
  late PageController _pageController;
  final WordController _wordController = WordController();
  int _activePage = 0;
  List<Word> _classWord = [];
  bool _isLoading = false;
  int _selectedId = 404;
  late Lesson _lesson;
  late BuildContext _context;
  bool _isInCompletionScreen = false;


  bool get isInCompletionScreen => _isInCompletionScreen;

  List<Word> get classWord => _classWord;

  PageController get pageController => _pageController;

  int get activePage => _activePage;

  bool get isLoading => _isLoading;

  int get selectedId => _selectedId;

  Lesson get lesson => _lesson;

  setSelectedId(int id) {
    _selectedId = id;
    notifyListeners();
  }

  setContext(BuildContext context) {
    _context = context;
  }

  setPageController(PageController pageController) {
    _pageController = pageController;
  }

  Future<void> setClassWord(Lesson lesson) async {
    _isInCompletionScreen = false;
    _lesson = lesson;
    _classWord = await _wordController.getWordList(lesson.id);
    print(classWord);
    setIsLoading();
  }

  setIsLoading() {
    print("isLoading = $isLoading");
    _isLoading = !_isLoading;
    notifyListeners();
  }

  clearClassWord() {
    _classWord = [];
    _activePage = 0;
    _selectedId = 404;
    // notifyListeners();
  }

  void nextPage() {
    if (_activePage == 14) {
      _activePage = 0;
      clearClassWord();
      if (!_isInCompletionScreen) {
        _isInCompletionScreen = true;
        navigateToScreen(
            _context,
            CompletionScreen(
              isClass: true,
              lesson: _lesson,
            ));
      }
    } else {
      _activePage += 1;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    notifyListeners();
  }
}
