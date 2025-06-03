class Post {
  final String id;
  final DateTime createdAt;
  final String content;
  final String userId;
  final String title;
  final double? latitude;
  final double? longitude;

  Post({
    required this.id,
    required this.createdAt,
    required this.content,
    required this.userId,
    required this.title,
    this.latitude,
    this.longitude,
  });

  // Convert from JSON (Supabase response)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      content: json['content'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?
    );
  }

  // Convert to JSON (for sending to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'user_id': userId,
      'title': title,
      'latitude': latitude,
      'longitude': longitude
      // Note: id and created_at are handled by Supabase
    };
  }

  // Create a copy of the post with modified fields
  Post copyWith(
      {String? id,
      DateTime? createdAt,
      String? content,
      String? userId,
      String? title,
      double? latitude,
      double? longitude}) {
    return Post(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude
    );
  }
}
