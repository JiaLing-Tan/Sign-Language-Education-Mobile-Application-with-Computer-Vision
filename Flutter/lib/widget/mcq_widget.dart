import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/word.dart';
import '../provider/class_provider.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class McqWidget extends StatelessWidget {
  final Word word;
  final bool isAns;

  const McqWidget({super.key, required this.word, required this.isAns});

  @override
  Widget build(BuildContext context) {
    print("build: ${word.id}");
    double _width = MediaQuery.of(context).size.width;
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: getYoutubeId(word),
      flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          hideThumbnail: true,
          loop: true,
          hideControls: true,
          enableCaption: false,
          useHybridComposition: false),
    );
    return GestureDetector(
      onTap: () {

        if (classProvider.selectedId == 404) {
          classProvider.setSelectedId(word.id);
          print("select in mcq: ${word.id}");
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              // height: ((width / 2) - 10 )/ 16 * 9,
              height: _width,
              width: _width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: YoutubePlayer(
                  // key: ValueKey(word.id), // forces the widget to rebuild
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
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: _width / 8,
              width: _width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: _width / 8,
                width: _width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
