import 'package:flutter/material.dart';
import 'package:taskorganizer/app/theme/app_colors.dart';

abstract class AppThemes {
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryDark,
      surface: AppColors.backgroundLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryLight,
      elevation: 1,
      shadowColor: Colors.black87,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.backgroundLight,
    ),
    iconTheme: IconThemeData(
      color: AppColors.iconLight,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.titleLargeLight,
      ),
      bodyLarge: TextStyle(
        color: AppColors.bodyLargeLight,
      ),
      bodyMedium: TextStyle(
        color: AppColors.bodyMediumLight,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.bodyMediumLight),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.bodyMediumLight, width: 1.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.bodyLargeLight, width: 2.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
      ),
    ),
    // cardTheme: CardTheme(
    //   color: AppColors.cardLight,
    // ),
    cardColor: AppColors.cardLight,
    focusColor: AppColors.completedCardLight,
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: AppColors.cardDark, width: 2),
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.cardDark;
        }
        return Colors.transparent;
      }),
      overlayColor: WidgetStatePropertyAll(AppColors.cardDark),
      checkColor: WidgetStatePropertyAll(AppColors.cardLight),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.backgroundLight,
    ),
  );

  static ThemeData dark = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      surface: AppColors.backgroundDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryDark,
      elevation: 1,
      shadowColor: Colors.black87,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.backgroundDark,
    ),
    iconTheme: IconThemeData(
      color: AppColors.iconDark,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.titleLargeDark,
      ),
      bodyLarge: TextStyle(
        color: AppColors.bodyLargeDark,
      ),
      bodyMedium: TextStyle(
        color: AppColors.bodyMediumDark,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.bodyMediumDark),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.bodyMediumDark, width: 1.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.bodyLargeDark, width: 2.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
      ),
    ),
    // cardTheme: CardTheme(
    //   color: AppColors.cardDark,
    // ),
    cardColor: AppColors.cardDark,
    focusColor: AppColors.completedCardDark,
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: AppColors.cardLight, width: 2),
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.cardLight;
        }
        return Colors.transparent;
      }),
      overlayColor: WidgetStatePropertyAll(AppColors.cardLight),
      checkColor: WidgetStatePropertyAll(AppColors.cardDark),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.backgroundDark,
    ),
  );
}
