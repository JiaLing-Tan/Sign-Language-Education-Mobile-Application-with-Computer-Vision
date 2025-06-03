import 'package:fingo/resource/auth_method.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fingo/model/student.dart';

class StudentController {
  final userDatabase = Supabase.instance.client.from("user");
  Authentication authentication = Authentication();

  Future createUser(Student user) async {
    await userDatabase.insert(user.toJson());
  }

  Future<Student> getUser(String id) async {
    try {
      final response = await userDatabase.select().eq("id", id).single();
      return Student.fromJson(response);
    } catch (e) {
      print(e);
      return Student(id: 'dfdf', createdAt: DateTime.now(), name: 'hasdfh',);
    }
  }

  Future<void> updateCoins(int newCoinAmount) async {
    await userDatabase.update({'coins': newCoinAmount}).eq(
        'id', authentication.getCurrentUserId()!);
  }

  Future<void> updateLevel(int newLevel) async {
    final response = await userDatabase.update({'level': newLevel}).eq(
        'id', authentication.getCurrentUserId()!);
  }

  Future<void> updateExp(int newExp) async {
    final response = await userDatabase
        .update({'exp': newExp}).eq('id', authentication.getCurrentUserId()!);
  }

  Future<void> updateStreak(int streak) async {
    final response = await userDatabase.update({'streak_day': streak}).eq(
        'id', authentication.getCurrentUserId()!);
  }

  Future<void> updateStreakDate() async {
    final response = await userDatabase
        .update({'last_claimed': DateTime.now().toIso8601String()}).eq(
            'id', authentication.getCurrentUserId()!);
  }

  Future<void> updateName(String name) async {
    final response = await userDatabase
        .update({'name': name}).eq('id', authentication.getCurrentUserId()!);
    // }
  }
}
