import 'package:fingo/model/classWordMap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/lesson.dart';

class LessonController {
  final lessonDatabase = Supabase.instance.client.from("class");


  Stream<List<Lesson>> getClassStream() {
    return lessonDatabase
        .stream(primaryKey: ['id']).map((data) => data.map((item) =>Lesson.fromJson(item)).toList());
  }

  Future<Lesson> getClass(int id) async {
    final response = await lessonDatabase.select().eq("id", id).single();
    return Lesson.fromJson(response);
  }

  Future<int> getClassCount() {
    return lessonDatabase.count();
  }


}
