import 'package:fingo/model/student.dart';
import 'package:fingo/resource/auth_method.dart';
import 'package:fingo/screen/community_hub_screen.dart';
import 'package:fingo/screen/completion_screen.dart';
import 'package:fingo/screen/cv_menu.dart';
import 'package:fingo/screen/home_screen.dart';

import 'package:fingo/screen/translation_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../resource/CRUD/student_controller.dart';
import '../screen/view_post_screen.dart';

class BottomLayout extends StatefulWidget {
  const BottomLayout({super.key});

  @override
  State<BottomLayout> createState() => _BottomLayoutState();
}

class _BottomLayoutState extends State<BottomLayout>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  late Authentication authService;

  bool _isLoading = false;

  @override
  void initState() {
    authService = Authentication();
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    StudentController studentController = StudentController();
    Authentication authentication = Authentication();
    Student user =
        await studentController.getUser(authentication.getCurrentUserId()!);
    userProvider.setUser(user);
    await userProvider.setProgress(authentication.getCurrentUserId()!);
    setState(() {
      _isLoading = false;
    });
  }

  static const List<Widget> _page = <Widget>[
    HomeScreen(key: PageStorageKey('home')),
    CvMenu(key: PageStorageKey('cv')),
    TranslationScreen(key: PageStorageKey('translation')),
    CommunityHubScreen(key: PageStorageKey('community')),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Stack(children: [
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    "lib/image/menu.png",
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                );
              })),
          // title: GestureDetector(
          //   child: Icon(Icons.icecream),
          //   onTap: () => navigateToScreen(context, CompletionScreen(isClass: true,)),
          // ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: _selectedIndex < 2
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        alignment: Alignment.centerLeft,
                        decoration: AppTheme.widgetDeco(),
                        width: 90,
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "lib/image/paw.png",
                              height: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${userProvider.user.coins}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    )
                  // : _selectedIndex == 3
                  //     ? GestureDetector(
                  //         onTap: () => navigateToScreen(context, ViewPostScreen()),
                  //         child: Text(
                  //           "View my post",
                  //           style:
                  //               TextStyle(decoration: TextDecoration.underline),
                  //         ),
                  //       )
                  : SizedBox(),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: IndexedStack(
          index: _selectedIndex,
          children: _page,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, -3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
            child: GNav(
              backgroundColor: Colors.transparent,
              activeColor: AppTheme.backgroundWhite,
              tabBackgroundColor: AppTheme.mainBlue,
              color: AppTheme.mainOrange,
              gap: 5,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              tabs: [
                GButton(
                  icon: Icons.home_filled,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.class_rounded,
                  text: "Class",
                ),
                GButton(
                  icon: Icons.library_books_rounded,
                  text: "Translate",
                ),
                GButton(
                  icon: Icons.people_alt_rounded,
                  text: "Community",
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      if (_isLoading)
        Container(
          color: AppTheme.backgroundWhite,
          width: double.maxFinite,
          height: double.maxFinite,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.mainOrange,
            ),
          ),
        ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
