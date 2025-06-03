import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/community_puppy_widget.dart';
import 'package:fingo/widget/feed_list.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ViewPostScreen extends StatelessWidget  {
  final bool isPersonal;
  final bool isNearby;
  const ViewPostScreen({super.key, this.isPersonal = false, this.isNearby=false});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(leading: GestureDetector(
      //   child: Icon(Icons.arrow_back_rounded),
      //   onTap: () {
      //     previousScreen(context);
      //   },
      //
      // ),title: Text("My posts"),),
      
      backgroundColor: AppTheme.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            CommunityPuppyWidget(width: _width),
            FeedList(isPersonal: isPersonal, isNearby: isNearby,),
          ],
        ),
      ),
    );
  }
}
