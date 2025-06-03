import 'package:fingo/provider/class_provider.dart';
import 'package:fingo/provider/exam_provider.dart';
import 'package:fingo/provider/learning_path_provider.dart';
import 'package:fingo/provider/translation_provider.dart';
import 'package:fingo/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider<TranslationProvider>(
      create: (_) => TranslationProvider(),
    ),
    ChangeNotifierProvider<ClassProvider>(
      create: (_) => ClassProvider(),
    ),
    ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
    ),
    ChangeNotifierProvider<ExamProvider>(
      create: (_) => ExamProvider(),
    ),
    ChangeNotifierProvider<LearningPathProvider>(
      create: (_) => LearningPathProvider(),
    ),
  ].toList();
}