import 'dart:developer';
import 'package:fingo/provider/translation_provider.dart';
import 'package:fingo/resource/CRUD/word_controller.dart';
import 'package:fingo/resource/gemini.dart';
import 'package:fingo/utils/theme.dart';
import 'package:fingo/widget/chat_bubble_widget.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

import '../model/word.dart';
import '../utils/utils.dart';
import '../widget/translate_widget.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String reply = "";

  @override
  Widget build(BuildContext context) {
    final translationProvider =
        Provider.of<TranslationProvider>(context, listen: false);
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: SingleChildScrollView(
          child: Stack(alignment: Alignment.topCenter, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: _width / 2.4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    width: double.infinity,
                    decoration: AppTheme.widgetDeco(color: AppTheme.mainOrange),
                    child: Column(
                      children: [
                        SizedBox(
                          height: _width / 4,
                        ),
                        Text(
                          "Translate with Fingo",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        Text(
                          "Your five star translator!",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SearchBar(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: _controller,
                          leading: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.search),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomizedButton(
                          isLoading: _isLoading,
                          func: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_isLoading) {
                              showSnackBar("Give me a second please!", context);
                            } else if (_controller.text == "") {
                              showSnackBar(
                                  "Tell me what is the word you want to translate!",
                                  context);
                            } else {
                              setState(
                                () {
                                  _isLoading = true;
                                },
                              );
                              await Gemini()
                                  .callGeminiModel(context, _controller);
                              setState(
                                () {
                                  _isLoading = false;
                                },
                              );
                            }
                          },
                          color: AppTheme.mainBlue,
                          width: double.infinity,
                          title: "Translate",
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: translationProvider.reply == ""
                        ? []
                        : [
                            ChatBubbleWidget(
                                width: _width,
                                reply: translationProvider.reply),
                            SizedBox(height: 20),
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return TranslateWidget(
                                  width: _width,
                                  word: translationProvider.output
                                      .elementAt(index),
                                );
                              },
                              itemCount: translationProvider.output.length,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset(
                "lib/image/translation_bg.png",
                width: _width / 1.4,
              ),
            ),
          ]),
        ));
  }
}
