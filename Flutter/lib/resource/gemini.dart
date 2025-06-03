import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

import '../model/word.dart';
import '../provider/translation_provider.dart';
import '../utils/utils.dart';
import 'CRUD/word_controller.dart';

class Gemini{
  final model = GenerativeModel(
      model: 'gemini-2.5-pro-exp-03-25',
      apiKey: "",
      generationConfig: GenerationConfig(temperature: 0));
  final WordController _wordController = WordController();

  callGeminiModel(BuildContext context, TextEditingController controller) async {
    final translationProvider =
    Provider.of<TranslationProvider>(context, listen: false);
    translationProvider.clearReply();
    translationProvider.clearOutput();
    final chatSession = model.startChat();
    Content messageParts;

    try {
      final input = controller.text.trim();
      final wordList = await _wordController.getIdEngMalayMap();
      final prompt =
      """You are an adorable and helpful puppy companion, acting as a smart translator.
      Your task is to translate a given word input which could be in any language,
      and you must return at least one word id within this given dictionary: ${wordList.toString()}.
      Find at least 1 closest translation, but return all the similar meaning word ids which can be more than 1.

      do not let user know the word is from a list, pretend like you are a smart translator.
      Your response must strictly be in JSON format:
      
      {
        "reply": "String (your response as a cute and friendly puppy, do not mentioned the ID in this reply)",
        "original": "String (the given word)",
        "translate word id": ["List of String (the ID of the translated word)"]
      }
      
      Do not include any extra text, explanations, or formatting like Markdown.
      Respond in a playful and cheerful tone, as if a cute puppy is talking.
      
      The given input is : '$input'.
      """;

      messageParts = Content.multi([TextPart(prompt)]);
      print(messageParts);
      final responseChat = await chatSession.sendMessage(messageParts);
      final responseMap = parseJsonString(responseChat.text!);
      print(responseMap);
      for (var responseId in responseMap['translate word id']) {
        Word? word = await _wordController.getWordById(int.parse(responseId));
        translationProvider.addOutput(word);
      }
      translationProvider.setReply(responseMap["reply"]);
      controller.clear();
    } catch (e) {
      print('Error: $e');
    }
  }
}