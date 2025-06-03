import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareImageFromUint8List(Uint8List imageData) async {
  try {
    await Share.shareXFiles(
      [
        XFile.fromData(
          imageData,
          mimeType: 'image/png',
        )
      ],
      text: 'Check out this amazing post!',
    );
  } catch (e) {
    print('Error sharing image: $e');
  }
}

networkImage(String imageUrl, double? width) {
  return Image.network(
    width: width,
    imageUrl,
    loadingBuilder: (BuildContext context, Widget child,
        ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return Center(
        child: CircularProgressIndicator(
          value:
          loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
  );

}