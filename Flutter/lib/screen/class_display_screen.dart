import 'package:fingo/provider/exam_provider.dart';
import 'package:fingo/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/word.dart';
import '../provider/class_provider.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class ClassDisplayScreen extends StatelessWidget {
  final Word word;
  final bool isExam;
  final bool isDisplay;

  ClassDisplayScreen(
      {super.key,
      required this.word,
      this.isExam = false,
      this.isDisplay = false});

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    double _width = MediaQuery.of(context).size.width;
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: getYoutubeId(word),
      flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
          hideThumbnail: true,
          loop: true,
          hideControls: false,
          enableCaption: false,
          useHybridComposition: false),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // height: ((width / 2) - 10 )/ 16 * 9,
          height: _width / 1.2,
          width: _width / 1.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: YoutubePlayer(
              topActions: [],
              bottomActions: [],
              controller: _controller,
              controlsTimeOut: const Duration(seconds: 1),
              // showVideoProgressIndicator: true,
              // progressIndicatorColor: Colors.amber,
              // progressColors: const ProgressBarColors(
              //   playedColor: Colors.amber,
              //   handleColor: Colors.amberAccent,
              // ),
              // onReady: () {
              //   _controller.addListener(listener);
              // },
            ),
          ),
          decoration: AppTheme.widgetDeco(),
        ),
        SizedBox(
          height: 70,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            word.eng,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            word.my,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        isDisplay
            ? SizedBox(
                height: 70,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: (isExam && examProvider.isCorrect)
                    ? CustomizedButton(
                        func: () {
                          examProvider.nextPage();
                        },
                        title: "Correct!",
                      )
                    : (isExam)
                        ? CustomizedButton(
                            color: AppTheme.mainBlue,
                            func: () {
                              examProvider.previousPage();
                            },
                            title: "Try again!",
                          )
                        : CustomizedButton(
                            func: () {
                              classProvider.nextPage();
                            },
                            title: "Got it!",
                          ),
              )
      ],
    );
  }
}
