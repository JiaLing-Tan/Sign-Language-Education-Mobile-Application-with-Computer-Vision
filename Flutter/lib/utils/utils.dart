import 'dart:convert';

import 'package:fingo/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/word.dart';

showSnackBar(String message, context, {int duration = 1}) {
  final snackbar = SnackBar(
    backgroundColor: AppTheme.mainBlue,
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    duration: Duration(seconds: duration),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Map<int, int> foodToExperience = {
  50: 20,
  100: 50,
  200: 120,
};

Map<int, String> levelToRole = {
  0: "New Friend",
  1: "New Friend",
  2: "Playmate",
  3: "Bestie",
  4: "Beloved Buddy",
  5: "Soulmate",
  6: "Legendary Friend",
  7: "Bond Beyond Time "
};

Map parseJsonString(String input) {
  final startPattern = RegExp(r'^```json\s*');
  final endPattern = RegExp(r'\s*```$');
  String jsonString =
      input.replaceAll(startPattern, '').replaceAll(endPattern, '');
  print("jsonString");
  print(jsonString);

  return jsonDecode(jsonString);
}

String getYoutubeId(Word word) {
  RegExp regExp = RegExp(r'/embed\/([^?]+)');
  Match match = regExp.firstMatch(word.link)!;
  return match.group(1)!;
}

void navigateToScreen(context, Widget screen, [String name = '']) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen,
      settings: RouteSettings(name: name),
    ),
  );
}

String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    return "${(difference.inDays / 365).floor()} years ago";
  } else if (difference.inDays > 30) {
    return "${(difference.inDays / 30).floor()} months ago";
  } else if (difference.inDays > 0) {
    return "${difference.inDays} days ago";
  } else if (difference.inHours > 0) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0) {
    return "${difference.inMinutes} minutes ago";
  } else {
    return "Just now";
  }
}

void showBackDialog(
    {confirmation = "Yes",
    required context,
    cancel = "Cancel",
    question = "Are you sure?",
    function = const {},
    cancelFunc = const {}}) {
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext alertContext) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          question,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(cancel),
            onPressed: () {
              Navigator.of(alertContext).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(confirmation),
            onPressed: () {
              //delay

              Navigator.of(alertContext).pop();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (confirmation == 'Are you sure you want to leave the app?') {
                  SystemNavigator.pop();
                } else if (function != null) {
                  function();
                }
              });
            },
          ),
        ],
      );
    },
  );
}

// Map<String, String> profileUrl = {
//   "fox" : "https://eyfbmywsvyukmgoaqrwu.supabase.co/storage/v1/object/public/profile_pictures//fox_profile.png",
//   "dog" : "https://eyfbmywsvyukmgoaqrwu.supabase.co/storage/v1/object/public/profile_pictures//dog_profile.png"
// };

List<String> profileUrl = [
  "https://eyfbmywsvyukmgoaqrwu.supabase.co/storage/v1/object/public/profile_pictures//fox_profile.png",
  "https://eyfbmywsvyukmgoaqrwu.supabase.co/storage/v1/object/public/profile_pictures//dog_profile.png"
];

Map<String, int> alphabetMap = {
  "A": 1474,
  "B": 1595,
  "C": 1904,
  "D": 1990,
  "E": 2091,
  "F": 2117,
  "G": 2137,
  "H": 2243,
  "I": 2305,
  "J": 2355,
  "K": 2445,
  "L": 2766,
  "M": 2881,
  "N": 3104,
  "O": 3151,
  "P": 3175,
  "Q": 3533,
  "R": 3535,
  "S": 3606,
  "T": 3925,
  "U": 4214,
  "V": 4247,
  "W": 4256,
  "X": 4281,
  "Y": 4283,
  "Z": 4289};
