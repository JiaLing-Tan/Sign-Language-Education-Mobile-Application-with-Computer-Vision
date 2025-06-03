import 'package:fingo/provider/user_provider.dart';
import 'package:fingo/resource/CRUD/comment_controller.dart';
import 'package:fingo/widget/feed_widget.dart';
import 'package:flutter/material.dart';

import '../model/comment.dart';
import '../model/post.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import '../widget/comment_widget.dart';
import '../widget/customized_button.dart';
import '../widget/customized_text_field.dart';

class CommentScreen extends StatefulWidget {
  final Post post;

  final UserProvider userProvider;

  const CommentScreen(
      {super.key, required this.post, required this.userProvider});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool _isShowingDialog = false;
  @override
  Widget build(BuildContext context) {
    CommentController commentController = CommentController();
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_rounded),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppTheme.backgroundWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeedWidget(
                  post: widget.post,
                  isComment: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 22),
                  child: Text(
                    "Comment",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                ),
                StreamBuilder<List<Comment>>(
                  stream: commentController.getComments(widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.mainOrange,
                        ),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data!.isNotEmpty) {
                      final commentList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          bottom: 70,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: commentList.length,
                        itemBuilder: (_, index) {
                          final comment = commentList[index];
                          return CommentWidget(comment: comment);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Be the first to comment!',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomizedTextField(
                      horizontalPadding: 10,
                      controller: textEditingController,
                      hintText: "Write a comment...",
                      textInputType: TextInputType.text,
                    ),
                  ),
                  SizedBox(width: 10),
                  CustomizedButton(
                    isRoundButton: true,
                    icon: Icons.send,
                    color: AppTheme.mainOrange,
                    func: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (textEditingController.text.trim().isEmpty) {
                        print("ho");
                        showSnackBar("Can't send an empty comment!", context);
                        return;
                      };

                      final comment = Comment(
                        id: 0,
                        userId: widget.userProvider.user.id,
                        postId: widget.post.id,
                        createdAt: DateTime.now(),
                        content: textEditingController.text.trim(),
                      );

                      await commentController.createComment(comment);
                      showSnackBar("Comment created!!", context);
                      textEditingController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
