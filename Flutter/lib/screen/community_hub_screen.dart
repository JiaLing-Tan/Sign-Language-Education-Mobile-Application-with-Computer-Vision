import 'package:fingo/screen/post_screen.dart';
import 'package:fingo/screen/view_post_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/community_puppy_widget.dart';
import 'package:fingo/widget/feed_list.dart';
import 'package:fingo/widget/feed_widget.dart';
import 'package:flutter/material.dart';

class CommunityHubScreen extends StatelessWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(

              indicatorColor: AppTheme.mainOrange,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.symmetric(vertical: 8),
              tabs: [
                Text(
                  "Nearby",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppTheme.grayText),
                ),
                Text(
                  "All",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppTheme.grayText),
                ),
                Text(
                  "My Post",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppTheme.grayText),
                )
              ]),
        ),
        backgroundColor: AppTheme.backgroundWhite,
        body: TabBarView(children: [
          ViewPostScreen(
            isNearby: true,
          ),
          ViewPostScreen(),
          ViewPostScreen(
            isPersonal: true,
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
          splashColor: Colors.white.withAlpha(50),
          onPressed: () {
            navigateToScreen(context, PostScreen());
          },
          foregroundColor: Colors.white,
          backgroundColor: AppTheme.mainOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          icon: const Icon(Icons.add),
          label: const Text(
            "Post",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
