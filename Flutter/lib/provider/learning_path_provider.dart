import 'package:flutter/cupertino.dart';

import '../model/lesson.dart';
import '../model/word.dart';
import '../resource/CRUD/word_controller.dart';

class LearningPathProvider extends ChangeNotifier {
  final WordController _wordController = WordController();
  int? _selectedId;
  List<Word> _classWord = [];
  bool _isLoading = false;

  int? get selectedId => _selectedId;

  List<Word> get classWord => _classWord;

  bool get isLoading => _isLoading;

  Future<void> setSelectedWord(Lesson lesson) async {
    _classWord = await _wordController.getWordList(lesson.id);
    print(classWord);
  }

  setSelectedId(Lesson? lesson) async {
    if (lesson != null) {
      _selectedId = lesson.id;
      setIsLoading();
      await setSelectedWord(lesson);
      setIsLoading();
    } else {
      _selectedId = null;
      notifyListeners();
    }
  }

  setIsLoading() {
    print("isLoading = $isLoading");
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
