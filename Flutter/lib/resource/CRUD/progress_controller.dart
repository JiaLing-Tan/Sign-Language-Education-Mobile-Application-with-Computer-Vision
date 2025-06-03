import 'package:fingo/model/progress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lesson_controller.dart';


class ProgressController{

  final progressDatabase = Supabase.instance.client.from("progress");
  
  Future<List<Progress>> getProgress(String userId) async {
    List<Progress> progress =[];
    final response = await progressDatabase.select().eq("user_id", userId);
    for (var element in response) {
      progress.add(Progress.fromJson(element));
    }
    return progress;
  }

  Future<void> createProgress(String userId) async{
    LessonController lessonController = LessonController();
    int classNum = await lessonController.getClassCount();
    for (int i = 1; i <= classNum; i++){
      Progress progress = Progress(classId: i, classState: "locked", examState: "locked", userId: userId);
      await progressDatabase.insert(progress.toJson());
    }
  }

  Future<void> updateState(String userId, int classId, bool isClass) async {
    await progressDatabase.update({isClass?'class_state':'exam_state': "completed"}).eq(
        'user_id', userId).eq('class_id', classId);

  }

}