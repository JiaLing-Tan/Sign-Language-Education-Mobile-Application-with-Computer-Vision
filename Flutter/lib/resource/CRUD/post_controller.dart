import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/post.dart';

class PostController {
  final postDatabase = Supabase.instance.client.from("post");

  Stream<List<Post>> getPostStream() {
    return postDatabase.stream(primaryKey: ['id']).map(
            (data) => data.map((item) => Post.fromJson(item)).toList());
  }

  Future createPost(Post post) async {
    await postDatabase.insert(post.toJson());
  }

  Stream<List<Post>> getPostStreamByUser(String userId) {
    return postDatabase.stream(primaryKey: ['id']).map(
          (data) => data
          .map((item) => Post.fromJson(item))
          .where((post) => post.userId == userId)
          .toList(),
    );
  }

  Future<void> deletePost(String postId) async {
    final response = await postDatabase
        .delete()
        .eq('id', postId); // Filter by postId

  }





}