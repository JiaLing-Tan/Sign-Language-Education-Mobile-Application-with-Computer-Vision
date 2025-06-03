import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/comment.dart';

class CommentController {
  final commentController = Supabase.instance.client.from("comment");

  Future createComment(Comment comment) async {
    await commentController.insert(comment.toJson());
  }

  Stream<List<Comment>> getComments(String postId) {
    return commentController.stream(primaryKey: ['id']).map(
          (data) => data
          .map((item) => Comment.fromJson(item))
          .where((comment) => comment.postId == postId)
          .toList(),
    );
  }
}