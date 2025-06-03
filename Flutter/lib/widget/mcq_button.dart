import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/word.dart';
import '../provider/class_provider.dart';
import '../utils/theme.dart';
import 'customized_button.dart';

class McqButton extends StatefulWidget {
  final Word word;
  const McqButton({super.key, required this.word});

  @override
  State<McqButton> createState() => _McqButtonState();
}

class _McqButtonState extends State<McqButton> {
  @override
  Widget build(BuildContext context) {
    print("correct: ${widget.word.id}");
    final classProvider = Provider.of<ClassProvider>(context, listen: true);
    return classProvider.selectedId == 404
        ? SizedBox(height: 50,)
        : classProvider.selectedId == widget.word.id
        ? CustomizedButton(
      func: () {
        classProvider.nextPage();
        classProvider.setSelectedId(404);
      },
      color: AppTheme.mainOrange,
      title: "Correct!",
    )
        : CustomizedButton(
      func: () {
        classProvider.setSelectedId(404);

      },
      color: AppTheme.mainBlue,
      title: "Not really...",
    );
  }
}
