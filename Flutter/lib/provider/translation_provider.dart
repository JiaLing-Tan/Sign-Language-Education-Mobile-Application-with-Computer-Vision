import 'package:fingo/model/word.dart';
import 'package:flutter/material.dart';

class TranslationProvider extends ChangeNotifier {
  String _input = "";
  List<Word> _output = [];
  String _reply = "";

  String get input =>_input;
  List<Word> get output => _output;
  String get reply => _reply;



  void setInput(String input){
    _input = input;
    notifyListeners();
  }

  void setOutput(List<Word> output){
    _output = output;
    // notifyListeners();
  }

  void setReply(String reply){
    _reply = reply;
  }

  void clearReply(){
    _reply = "";
  }
  void addOutput(Word word){
    _output.add(word);
    // notifyListeners();
  }

  void clearOutput(){
    _output = [];
    // notifyListeners();
  }

}