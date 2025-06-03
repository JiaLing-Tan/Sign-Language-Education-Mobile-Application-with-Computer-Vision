import 'package:fingo/model/student.dart';
import 'package:fingo/resource/CRUD/progress_controller.dart';
import 'package:fingo/resource/CRUD/student_controller.dart';
import 'package:fingo/utils/location.dart';
import 'package:flutter/material.dart';

import '../model/progress.dart';

class UserProvider extends ChangeNotifier {
  Student _user = Student(id: "", createdAt: DateTime.timestamp(), name: "");
  final StudentController _studentController = StudentController();
  final ProgressController _progressController = ProgressController();
  List _currentLocation = [];
  int _animationPlayTime = 0;
  bool _showAnimation = false;
  AnimationController? _controller;

  Student get user => _user;

  List get currentLocation => _currentLocation;

  bool get showAnimation => _showAnimation;

  int get animationPlayTime => _animationPlayTime;

  AnimationController? get controller => _controller;

  startAnimation() {
    _showAnimation = true;
    _animationPlayTime = 0;
    _controller?.forward(from: 0);
    print("play");
    notifyListeners();
  }

  endAnimation() {
    _showAnimation = false;
    notifyListeners();
  }

  setAnimationPlayTime() {
    _animationPlayTime += 1;
  }

  setAnimationController(AnimationController controller) {
    _controller = controller;
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setAnimationPlayTime();
        if (_animationPlayTime < 3) {
          print(_animationPlayTime);
          _controller?.forward(from: 0); // Replay animation
        } else {
          endAnimation();
        }
      }
    });
  }

  setUser(Student user) {
    _user = user;
    notifyListeners();
  }

  setProgress(String userId) async {
    _user.progress = await _progressController.getProgress(userId);

    notifyListeners();
    print("here here");
  }

  updateCoins(int coins) {
    _user.coins += coins;
    _studentController.updateCoins(_user.coins);
    notifyListeners();
  }

  updateLevel(int exp) {
    int currentLevel = _user.level;
    int currentLevelExp = currentLevel * 80;

    _user.exp += exp;
    if (_user.exp >= _user.level * 80) {
      _user.exp = _user.exp - currentLevelExp;
      _user.level += 1;
    }
    _studentController.updateExp(_user.exp);
    _studentController.updateLevel(_user.level);

    notifyListeners();
  }

  claimStreak() {
    _user.streakDay += 1;
    _studentController.updateStreak(_user.streakDay);
    _user.lastClaimed = DateTime.now();
    _studentController.updateStreakDate();
    notifyListeners();
  }

  updateName(String name) {
    _user.name = name;
    _studentController.updateName(_user.name);
    notifyListeners();
  }

  updateState(int classId, bool isClass) {
    int index =
        _user.progress.indexWhere((element) => element.classId == classId);

    if (index != -1) {
      if (isClass) {
        _user.progress[index] =
            _user.progress[index].copyWith(classState: "completed");
      } else {
        _user.progress[index] =
            _user.progress[index].copyWith(examState: "completed");
      }
    }
    _progressController.updateState(user.id, classId, isClass);
    notifyListeners();
  }
}
