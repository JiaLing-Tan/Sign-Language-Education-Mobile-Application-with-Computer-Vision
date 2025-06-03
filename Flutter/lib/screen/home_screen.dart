import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/resource/CRUD/student_controller.dart';
import 'package:fingo/resource/auth_method.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/food_menu.dart';
import 'package:fingo/widget/level_widget.dart';
import 'package:fingo/widget/streak_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../model/student.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: true);
    if(_userProvider.controller == null){
      _userProvider.setAnimationController(AnimationController(vsync: this, duration: const Duration(seconds: 2),));
    }



    return Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mainOrange,
                ),
              )
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Image.asset("lib/image/home_bg.png"),
                    if (_userProvider.showAnimation)
                      Lottie.asset(
                        'lib/image/love.json',
                        controller: _userProvider.controller,
                        onLoaded: (composition) {
                          _userProvider.controller?.duration = composition.duration;
                          _userProvider.controller?.forward(from: 0);
                        },
                      ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: _width / 2 - 5),
                        child: Image.asset(
                          "lib/image/dog.png",
                          width: _width / 2,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: _width - 85,
                      child: FoodMenu(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: _width - 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: AppTheme.widgetDeco(),
                        child: Column(
                          spacing: 18,
                          children: [LevelWidget(), StreakWidget()],
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
