import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CommunityPuppyWidget extends StatelessWidget {
  final double width;
  const CommunityPuppyWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: AppTheme.widgetDeco(),
        width: double.infinity,
        child: Row(
          children: [
            Image.asset(
              "lib/image/dog.png",
              width: width / 4,
            ),
            const SizedBox(
              width: 12,
            ),
            const Column(
              children: [
                Text("Welcome back to the fam!",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                SizedBox(height: 5,),
                Text(
                  "A safe space to send support\nand share your story!",
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
