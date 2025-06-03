import 'package:fingo/model/like.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LikeController {
  final likeDatabase = Supabase.instance.client.from("like");

  Future createLike(Like like) async {
    await likeDatabase.insert(like.toJson());
  }

  Stream<List<Like>> getLikes(String postId) {
    return likeDatabase.stream(primaryKey: ['id']).map(
      (data) => data
          .map((item) => Like.fromJson(item))
          .where((like) => like.postId == postId)
          .toList(),
    );
  }

  Future<void> deleteLike(Like like) async {
    final response =
        await likeDatabase.delete().match({'user_id': like.userId, 'post_id': like.postId});
  }

  Future<bool> isLikeExists(Like like) async {
    final response = await likeDatabase
        .select()
        .eq('user_id', like.userId)
        .eq('post_id', like.postId)
        .maybeSingle(); // Returns `null` if no match is found

    return response != null;
  }
}
