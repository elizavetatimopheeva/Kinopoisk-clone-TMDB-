import 'package:flutter/material.dart';
import 'package:kino/ui/theme/app_colors.dart';

class AppTheme {
  // static final lightTheme = ThemeData(
  //   primaryColor: AppColors.white,
  //   scaffoldBackgroundColor: AppColors.mainDarkBlue,
  //   brightness: Brightness.light,
  //   fontFamily: 'Satoshi',
  //   textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xff383838)),
  //   sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
  //   inputDecorationTheme: InputDecorationTheme(
  //     filled: true,
  //     fillColor: Colors.transparent,
  //     contentPadding: const EdgeInsets.all(30),

  //     hintStyle: const TextStyle(
  //       color: Color(0xff383838),
  //       fontWeight: FontWeight.w500,
  //     ),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(30),
  //       borderSide: const BorderSide(color: Colors.white, width: 0.4),
  //     ),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(30),
  //       borderSide: const BorderSide(color: Colors.black, width: 0.8),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(30),
  //       borderSide: const BorderSide(color: AppColors.primary, width: 0.4),
  //     ),
  //   ),
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: AppColors.primary,
  //       elevation: 0,
  //       textStyle: const TextStyle(
  //         fontSize: 16,
  //         color: AppColors.white,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  //     ),
  //   ),
  // );

  static final lightTheme = ThemeData(
    primaryColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.mainDarkBlue,
    brightness: Brightness.dark,
    fontFamily: 'Satoshi',
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xffA7A7A7),
    ),
    //   sliderTheme: SliderThemeData(
    //     overlayShape: SliderComponentShape.noOverlay,
    //     activeTrackColor: const Color(0xffB7B7B7),
    //     inactiveTrackColor: Colors.grey.withOpacity(0.3),
    //     thumbColor: const Color(0xffB7B7B7),
    //   ),
    //   inputDecorationTheme: InputDecorationTheme(
    //     filled: true,
    //     fillColor: Colors.transparent,
    //     hintStyle: const TextStyle(
    //       color: Color(0xffA7A7A7),
    //       fontWeight: FontWeight.w500,
    //     ),
    //     contentPadding: const EdgeInsets.all(30),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Colors.white, width: 0.4),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(30),
    //       borderSide: const BorderSide(color: Colors.white, width: 0.4),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(30),
    //       borderSide: const BorderSide(color: AppColors.white, width: 0.4),
    //     ),
    //   ),
    //   elevatedButtonTheme: ElevatedButtonThemeData(
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: AppColors.white,
    //       elevation: 0,
    //       textStyle: const TextStyle(
    //         fontSize: 16,
    //         color: AppColors.white,
    //         fontWeight: FontWeight.bold,
    //       ),
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    //     ),
    //   ),
  );
}
