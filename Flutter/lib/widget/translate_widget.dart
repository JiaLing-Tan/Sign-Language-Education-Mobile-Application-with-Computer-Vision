import 'package:fingo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/word.dart';
import '../utils/theme.dart';

class TranslateWidget extends StatelessWidget {
  final double width;
  final Word word;
  const TranslateWidget({super.key, required this.width, required this.word});

  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: AppTheme.widgetDeco(),
        child: Row(
          children: [
            Container(
              // height: ((width / 2) - 10 )/ 16 * 9,
              height: (width / 2) - 10,
              width: (width / 2) - 10 ,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: YoutubePlayer(
                  topActions: [],
                  bottomActions: []
                  ,
                  controller: _controller,
                    controlsTimeOut : const Duration(seconds: 1),
                ),
              ),
              decoration: AppTheme.widgetDeco(
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(

                  width: width/2 - 77,
                  child: Text(
                    word.eng,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  width: width/2 - 77,
                  child: Text(
                    word.my,
                    style: TextStyle(
                      color: AppTheme.grayText,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            )
          ],
          crossAxisAlignment:
          CrossAxisAlignment.center,
        ),
      ),
    );

  }
}
