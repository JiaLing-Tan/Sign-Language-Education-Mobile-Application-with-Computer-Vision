import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/word.dart';
import '../provider/class_provider.dart';
import '../utils/theme.dart';
import 'customized_button.dart';

class FitbButton extends StatefulWidget {
  final Word word;
  final TextEditingController textEditingController;

  const FitbButton(
      {super.key, required this.textEditingController, required this.word});

  @override
  State<FitbButton> createState() => _FitbButtonState();
}

class _FitbButtonState extends State<FitbButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final input =
        widget.textEditingController.text.toLowerCase().trim().split(',').first;

    if ((input == widget.word.eng.toLowerCase() ||
            widget.word.eng.toLowerCase().split(',').contains(input) ||
            input == widget.word.my.toLowerCase() ||
            widget.word.my.toLowerCase().split(',').contains(input)) &&
        isClicked) {
      FocusManager.instance.primaryFocus?.unfocus();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: CustomizedButton(
          color: AppTheme.mainOrange,
          func: () {
            {
              isClicked = false;
              classProvider.nextPage();
            }
          },
          title: "Correct! ",
        ),
      );
    } else if (isClicked) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: CustomizedButton(
          color: AppTheme.mainBlue,
          func: () {
            {
              widget.textEditingController.clear();
              setState(() {
                isClicked = false;
              });
            }
          },
          title: "Try again!! ",
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: CustomizedButton(
          titleColor: AppTheme.mainBlue,
          color: Colors.white,
          func: () {
            {
              setState(() {});

              if (widget.textEditingController.text.toLowerCase().trim().split(',').first == "") {
                showSnackBar("Type your answer in the filed!", context);
              } else {
                setState(() {
                  isClicked = true;
                });
              }
            }
          },
          title: "Submit",
        ),
      );
    }
  }
}
