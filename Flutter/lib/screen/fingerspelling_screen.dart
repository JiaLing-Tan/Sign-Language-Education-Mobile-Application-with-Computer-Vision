import 'package:fingo/resource/CRUD/word_controller.dart';
import 'package:fingo/screen/class_display_screen.dart';
import 'package:fingo/screen/fingerspelling_detail_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/utils/utils.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import '../model/word.dart';

class FingerspellingScreen extends StatefulWidget {
  const FingerspellingScreen({super.key});

  @override
  State<FingerspellingScreen> createState() => _FingerspellingScreenState();
}

class _FingerspellingScreenState extends State<FingerspellingScreen> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemCount: alphabetMap.length,
        itemBuilder: (_, index) {
          final alphabet = alphabetMap.keys.elementAt(index);
          return GestureDetector(
            onTap: () async {
              navigateToScreen(
                  context,
                  FingerspellingDetailScreen(currentIndex: index));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: AppTheme.widgetDeco(),
              child: Center(
                child: Text(
                  alphabet,
                  style: TextStyle(
                      color: AppTheme.grayText, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
