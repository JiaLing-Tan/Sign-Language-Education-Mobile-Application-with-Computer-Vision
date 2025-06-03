import 'package:fingo/utils/theme.dart';
import 'package:flutter/material.dart';

class FeedReaction extends StatelessWidget {
  int stats;
  final bool isActive;
  final int type;
  final VoidCallback? onTap;

  FeedReaction(
      {super.key,
      this.stats = 0,
      required this.isActive,
      required this.type,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        color: !isActive
            ? Colors.white
            : type == 1
            ? Colors.redAccent.withAlpha(20)
            : type == 2
            ? Colors.blueAccent.withAlpha(20)
            : Colors.orangeAccent.withAlpha(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          splashColor: type == 1
              ? Colors.redAccent.withAlpha(20)
              : type == 2
              ? Colors.blueAccent.withAlpha(20)
              : Colors.orangeAccent.withAlpha(40),
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.withOpacity(0.10)),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                    height: 20,
                    type == 1
                        ? "lib/image/likes.png"
                        : type == 2
                            ? "lib/image/comment.png"
                            : "lib/image/share.png"),
                type == 3 ? SizedBox() : SizedBox(width: 8),
                type == 3
                    ? SizedBox()
                    : Text(
                        stats.toString(),
                        style: TextStyle(fontSize: 12),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
