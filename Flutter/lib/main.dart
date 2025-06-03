import 'package:fingo/model/word.dart';
import 'package:fingo/provider/provider.dart';
import 'package:fingo/resource/auth_gate.dart';
import 'package:fingo/screen/class_display_screen.dart';
import 'package:fingo/screen/class_menu_screen.dart';
import 'package:fingo/screen/community_hub_screen.dart';
import 'package:fingo/screen/cv_menu.dart';
import 'package:fingo/screen/home_screen.dart';
import 'package:fingo/screen/login_screen.dart';
import 'package:fingo/screen/register_screen.dart';
import 'package:fingo/screen/translation_screen.dart';
import 'package:fingo/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  await Supabase.initialize(url: "",
      anonKey: "");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          // home:ClassDisplayScreen(word: Word(id: 3640, my: "Sama-sama", eng: "You Are Welcome", link: "https://www.youtube.com/embed/DBCRj6JNGgk?autoplay=1&mute=0&controls=1&origin=https%3A%2F%2Fwww.bimsignbank.org&playsinline=1&showinfo=0&rel=0&iv_load_policy=3&modestbranding=1&enablejsapi=1&widgetid=1"))),
        home: AuthGate()),
          
    );
  }
}
