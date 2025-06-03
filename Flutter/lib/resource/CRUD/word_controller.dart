import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/classWordMap.dart';
import '../../model/word.dart';

class WordController {
  final wordDatabase = Supabase.instance.client.from("word");
  final classWordMapDatabase = Supabase.instance.client.from("class_word_map");

  Future<List<Map<String, String>>> getIdEngMalayMap() async {
    try {
      final response = await wordDatabase
          .select('id, eng, my');

      List<Map<String, String>> idEngMalayMaps =
          response.map<Map<String, String>>((item) {
        return {
          'id': item['id'].toString(),
          'English': item['eng'] as String,
          'Malay': item['my'] as String,
        };
      }).toList();

      return idEngMalayMaps;
    } catch (e) {
      print('Error fetching id-eng-malay maps: $e');
      return [];
    }
  }

  Future<Word> getWordById(int id) async {
    final response = await wordDatabase.select().eq('id', id).single();
    return Word.fromJson(response);
  }

  Future<List<Word>> getWordList(int classId) async {
    List<Word> wordList = [];
    print("classid: $classId");
    final response =
        await classWordMapDatabase.select().eq("class_id", classId);
    print(response);
    for (var element in response) {
      ClassWordMap wordMap = ClassWordMap.fromJson(element);
      print(wordMap.wordId);
      Word? word = await getWordById(wordMap.wordId);
      wordList.add(word);
    }
    return wordList;
  }
}
