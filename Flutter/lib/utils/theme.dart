
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static Color mainBlue = Color(0xff484EFF).withAlpha(240);
  static const backgroundWhite = Color(0xffFAFAFA);
  static const mainOrange = Color(0xffFEBC58);
  static const lightGrey = Color(0xffEAEAEA);
  static Color? grayText = Colors.grey.shade800;

  static List<BoxShadow> bottomLightShadow = [
    BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4))
  ];


  static BoxDecoration widgetDeco({Color color = Colors.white, bool isLuminous = false}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.withOpacity(0.10)),
      boxShadow: [
        BoxShadow(
          color: isLuminous? Colors.white:Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 3,
          offset: isLuminous? Offset(0, 0): Offset(0, 3),
        ),
      ],
    );
  }

  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: backgroundWhite,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.nunito(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
    elevation: 0,
    iconTheme: IconThemeData(color: mainBlue),
  );

  static final IconThemeData _lightIconTheme = IconThemeData(
    color: mainBlue,
  );

  static final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: mainBlue),
      primarySwatch: generateMaterialColor(mainBlue),
      scaffoldBackgroundColor: backgroundWhite,
      appBarTheme: _lightAppBarTheme,
      iconTheme: _lightIconTheme,
      textTheme: GoogleFonts.nunitoTextTheme()
    //     .copyWith(
    //   displayLarge: TextStyle(fontWeight: FontWeight.w500),
    //   displayMedium: TextStyle(fontWeight: FontWeight.w500),
    //   displaySmall: TextStyle(fontWeight: FontWeight.w500),
    //   headlineMedium: TextStyle(fontWeight: FontWeight.w500),
    //   headlineSmall: TextStyle(fontWeight: FontWeight.w500),
    //   titleLarge: TextStyle(fontWeight: FontWeight.w500),
    //   titleMedium: TextStyle(fontWeight: FontWeight.w500),
    //   titleSmall: TextStyle(fontWeight: FontWeight.w500),
    //   bodyLarge: TextStyle(fontWeight: FontWeight.w500),
    //   bodyMedium: TextStyle(fontWeight: FontWeight.w500),
    //   bodySmall: TextStyle(fontWeight: FontWeight.w500),
    //   labelLarge: TextStyle(fontWeight: FontWeight.w500),
    //   labelSmall: TextStyle(fontWeight: FontWeight.w500),
    // ),
  );
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);