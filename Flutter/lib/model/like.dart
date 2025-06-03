import 'package:http/http.dart';

class Like {
  final int id;
  final String userId;
  final String postId;
  final DateTime createdAt;

  Like(
      {required this.id,
      required this.userId,
      required this.createdAt,
      required this.postId});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        postId: json['post_id'] as String,
        userId: json['user_id'] as String,
        );
  }

  // Convert to JSON (for sending to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      // Note: id and created_at are handled by Supabase
    };
  }

  // Create a copy of the post with modified fields
  Like copyWith(
      {int? id,
      DateTime? createdAt,
      String? postId,
      String? userId}) {
    return Like(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId);
  }
}
