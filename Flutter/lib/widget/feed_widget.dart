import 'dart:typed_data';

import 'package:fingo/model/comment.dart';
import 'package:fingo/model/post.dart';
import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/resource/CRUD/comment_controller.dart';
import 'package:fingo/resource/CRUD/like_controller.dart';
import 'package:fingo/resource/CRUD/post_controller.dart';
import 'package:fingo/resource/CRUD/student_controller.dart';
import 'package:fingo/screen/comment_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';

import 'package:fingo/widget/feed_reaction.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../model/like.dart';
import '../model/student.dart';
import '../utils/image.dart';

class FeedWidget extends StatefulWidget {
  final bool isComment;
  final Post post;
  final bool isPersonal;

  const FeedWidget({super.key,
    required this.post,
    this.isComment = false,
    this.isPersonal = false});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  bool _isLoading = false;
  late LikeController _likeController;
  late CommentController _commentController;
  late StudentController _studentController;
  late UserProvider _userProvider;
  late ScreenshotController _screenshotController;
  late PostController _postController;

  @override
  void initState() {
    super.initState();
    _likeController = LikeController();
    _commentController = CommentController();
    _studentController = StudentController();
    _screenshotController = ScreenshotController();
    _postController = PostController();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

  }

  Future<Student> getUser() async {

     Student user = await _studentController.getUser(widget.post.userId);
    return user;
  }

  void _like() async {
    final like = Like(
      id: 0,
      userId: _userProvider.user.id,
      postId: widget.post.id,
      createdAt: DateTime.now(),
    );
    try {
      await _likeController.createLike(like);
    } catch (e) {
      await _likeController.deleteLike(like);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
          decoration: AppTheme.widgetDeco(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:FutureBuilder<Student>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child:
                  CircularProgressIndicator(color: AppTheme.mainOrange),
                );
              } else {
                var user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: networkImage( user.profilePic!,
                                        40))),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  getTimeAgo(widget.post.createdAt),
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            )
                          ],
                        ),
                        widget.isPersonal
                            ? GestureDetector(
                            onTap: () =>
                                showBackDialog(
                                  context: context,
                                  question:
                                  "Are you sure you want to delete this post?\nThe likes and comments will be deleted as well.",
                                  function: () async {
                                    await _postController.deletePost(widget.post.id);
                                    showSnackBar("Post deleted", context);
                                  },),
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ))
                            : SizedBox()
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      widget.post.title,
                      style: TextStyle(
                          height: 1.2, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      widget.post.content,
                      style: TextStyle(height: 1.2, fontSize: 13.5),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        StreamBuilder<List<Like>>(
                            stream: _likeController.getLikes(widget.post.id),
                            builder: (context, likesSnapshot) {
                              final likes = likesSnapshot.data ?? [];
                              final isLiked = likes.any(
                                      (like) => like.userId == _userProvider.user.id);

                              return FeedReaction(
                                  stats: likes.length,
                                  isActive: isLiked,
                                  type: 1,
                                  onTap: _like);
                            }),
                        SizedBox(width: 10),
                        StreamBuilder<List<Comment>>(
                            stream: _commentController.getComments(widget.post.id),
                            builder: (context, snapshot) {
                              final comments = snapshot.data ?? [];
                              return FeedReaction(
                                  stats: comments.length,
                                  isActive: false,
                                  type: 2,
                                  onTap: () {
                                    if (!widget.isComment) {
                                      navigateToScreen(
                                          context,
                                          CommentScreen(
                                            post: widget.post,
                                            userProvider: _userProvider,
                                          ));
                                    }
                                  });
                            }),
                        SizedBox(width: 10),
                        FeedReaction(
                            isActive: false,
                            type: 3,
                            onTap: () {
                              _screenshotController
                                  .capture()
                                  .then((Uint8List? image) {
                                //Capture Done
                                shareImageFromUint8List(image!);
                              }).catchError((onError) {
                                print(onError);
                              });
                            }),
                      ],
                    )
                  ],
                );
              }
            },
          )
        ),
      ),
    );
  }
}
