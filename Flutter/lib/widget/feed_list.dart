import 'package:fingo/resource/CRUD/post_controller.dart';
import 'package:fingo/utils/location.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/feed_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../model/post.dart';
import '../provider/user_provider.dart';
import '../utils/theme.dart';

class FeedList extends StatefulWidget {
  final bool isPersonal;
  final bool isNearby;

  const FeedList({super.key, this.isPersonal = false, this.isNearby = false});

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList>
    with AutomaticKeepAliveClientMixin {
  Future<List> getLocation() async {
    return await getCurrentLocation();
  }

  Widget buildPostList(List<Post> postList) {
    postList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Column(
      children: [
        ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: postList.length,
          itemBuilder: (_, index) {
            final post = postList[index];
            return FeedWidget(
              post: post,
              isPersonal: widget.isPersonal,
            );
          },
        ),
        SizedBox(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  postList.isEmpty
                      ? widget.isNearby
                          ? "No content nearby. \nTry to check your location service."
                          : "Post your first post now!"
                      : "End of the ${widget.isPersonal ? "posts" : "feed"}!",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                if (postList.isEmpty && widget.isNearby)
                  GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Text(
                        "Reload",
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                      ))
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    PostController _postController = PostController();
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return StreamBuilder<List<Post>>(
      stream: widget.isPersonal
          ? _postController.getPostStreamByUser(userProvider.user.id)
          : _postController.getPostStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CircularProgressIndicator(
                color: AppTheme.mainOrange,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          List<Post> postList = snapshot.data!;
          if (widget.isNearby) {
            return FutureBuilder<List>(
              future: getLocation(),
              builder: (context, locationSnapshot) {
                if (locationSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.mainOrange),
                  );
                } else if (locationSnapshot.hasData &&
                    locationSnapshot.data!.length > 1) {
                  var location = locationSnapshot.data!;
                  var filteredPosts = postList
                      .where((element) =>
                          element.latitude != null &&
                          element.longitude != null &&
                          Geolocator.distanceBetween(
                                  element.latitude ?? 0,
                                  element.longitude ?? 0,
                                  location.elementAt(0),
                                  location.elementAt(1)) <
                              25000)
                      .toList();

                  return buildPostList(filteredPosts);
                } else {
                  // showSnackBar("Location services are disabled!", context);
                  // Handle case where location could not be retrieved
                  return buildPostList([]);
                }
              },
            );
          } else {
            // If not nearby, just display all posts
            return buildPostList(postList);
          }
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
              child: Column(
            children: [
              Text("Urghhh, I'm trying to get the content, try reload!"),
              GestureDetector(
                onTap: () {setState(() {

                });},
                child: Text(
                  "Reload",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
