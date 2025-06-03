class Progress {
  int id;
  final String userId;
  final int classId;
  final String classState;
  final String examState;

  Progress(
      {this.id = 0,
      required this.classId,
      required this.classState,
      required this.examState,
      required this.userId});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
        id: json['id'] as int,
        userId: json['user_id'] as String,
        classId: json['class_id'] as int,
        classState: json['class_state'] as String,
        examState: json['exam_state'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_state': classState,
      'exam_state': examState,
      'user_id': userId
      // Note: id and created_at are handled by Supabase
    };
  }

  Progress copyWith(
      {int? id,
      int? classId,
      String? userId,
      String? examState,
      String? classState}) {
    return Progress(
        id: id ?? this.id,
        classId: classId ?? this.classId,
        userId: userId ?? this.userId,
        examState: examState ?? this.examState,
        classState: classState ?? this.classState);
  }
}
