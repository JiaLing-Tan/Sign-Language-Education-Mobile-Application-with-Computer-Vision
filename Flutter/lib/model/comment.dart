class Comment {
  final int id;
  final String userId;
  final String postId;
  final DateTime createdAt;
  final String content;

  Comment(
      {required this.id,
        required this.userId,
        required this.createdAt,
        required this.postId,
      required this.content});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String
    );
  }

  // Convert to JSON (for sending to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'content': content
      // Note: id and created_at are handled by Supabase
    };
  }

  // Create a copy of the post with modified fields
  Comment copyWith(
      {int? id,
        DateTime? createdAt,
        String? postId,
        String? userId,
      String? content}) {
    return Comment(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
    content: content ?? this.content);
  }
}
