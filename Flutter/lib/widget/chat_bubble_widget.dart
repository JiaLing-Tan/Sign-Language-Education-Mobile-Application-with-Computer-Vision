import 'package:flutter/material.dart';

import '../utils/theme.dart';

class ChatBubbleWidget extends StatelessWidget {
  final double width;
  final String reply;
  const ChatBubbleWidget({super.key, required this.width, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "lib/image/dog.png",
          width: width / 4,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: width - (width / 4) - 50,
          decoration: AppTheme.widgetDeco(),
          child: Text(reply),
        )
      ],
    );
  }
}
