class ClassWordMap {
  final int id;
  final int  classId;
  final int wordId;

  ClassWordMap({
    required this.id,
    required this.classId,
    required this.wordId,
  });

  // Convert from JSON (Supabase response)
  factory ClassWordMap.fromJson(Map<String, dynamic> json) {
    return ClassWordMap(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      wordId: json['word_id'] as int,
    );
  }

  ClassWordMap copyWith({
    int? id,
    int? classId,
    int? wordId,
  }) {
    return ClassWordMap(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      wordId: wordId ?? this.wordId,
    );
  }
}