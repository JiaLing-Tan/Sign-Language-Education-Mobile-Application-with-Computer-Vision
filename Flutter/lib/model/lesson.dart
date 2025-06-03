import 'package:fingo/model/word.dart';

class Lesson {
  final int id;
  final DateTime createdAt;
  final String name;
  final String imageUrl;

  Lesson(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.imageUrl});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: json['name'] as String,
      imageUrl: json['class_image'] as String
    );
  }
}
