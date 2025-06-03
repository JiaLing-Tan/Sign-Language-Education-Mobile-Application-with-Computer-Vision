import 'package:fingo/model/word.dart';
import 'package:fingo/widget/fitb_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../provider/class_provider.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import '../widget/customized_button.dart';

class ClassFitbScreen extends StatelessWidget {
  final Word word;

  const ClassFitbScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    double _width = MediaQuery.of(context).size.width;
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: getYoutubeId(word),
      flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          hideThumbnail: true,
          loop: true,
          hideControls: false,
          enableCaption: false,
          useHybridComposition: false),
    );

    return SingleChildScrollView(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Text(
            "What is this sign?",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
          ),
          SizedBox(
            height: 30,
          ),
          Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                // height: ((width / 2) - 10 )/ 16 * 9,
                height: _width /1.2,
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
            ),
            Positioned(
              left: _width/12,
              child: Container(
                height: _width /38.4*7,
                width: _width / 1.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 0,
              left: _width/12,
              child: Container(
                height: _width/38.4*7,
                width: _width / 1.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: Colors.white),
              ),
            )
          ]),
          SizedBox(
            height: 70,
          ),
          Container(
            width: _width/1.2,
            child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: _textController,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          ),
          FitbButton(textEditingController: _textController, word: word)


        ],
      ),
    );
  }
}
