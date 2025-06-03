import 'dart:math';

import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:fingo/widget/mcq_button.dart';
import 'package:fingo/widget/mcq_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/word.dart';
import '../provider/class_provider.dart';

class ClassMcqScreen extends StatefulWidget {
  final Word word;
  const ClassMcqScreen({super.key, required this.word});

  @override
  State<ClassMcqScreen> createState() => _ClassMcqScreenState();
}

class _ClassMcqScreenState extends State<ClassMcqScreen> {
  late List<Word> options;

  @override
  void initState() {
    super.initState();
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    List<Word> wordList = List.from(classProvider.classWord);
    wordList.removeWhere((element) => element.id == widget.word.id);
    wordList.shuffle();
    List<Word> wrongWord = wordList.take(3).toList();
    options = [...wrongWord, widget.word]..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Which of the below is \n ${widget.word.eng}",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 50),
        GridView.builder(
          padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.8,
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20),
          itemCount: 4,
          itemBuilder: (_, index) {
            Word option = options[index];
            return McqWidget(
              word: option,
              isAns: option.id == widget.word.id,
            );
          },
        ),
        SizedBox(height: 50),
        McqButton(word: widget.word),
        SizedBox(height: 50),
      ],
    );
  }
}
