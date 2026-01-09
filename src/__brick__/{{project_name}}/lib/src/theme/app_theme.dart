import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_theme.dart';
import 'app_text_theme.dart';

ThemeData get appLightTheme {
  return ThemeData(
    colorScheme: ColorScheme.light(primary: AppColorTheme.primary500),
    primarySwatch: AppColorTheme.primarySwatch,
    scaffoldBackgroundColor: AppColorTheme.white,
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorTheme.primary500,
        foregroundColor: AppColorTheme.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColorTheme.primary500,
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 20.sp),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorTheme.white,
      titleTextStyle: AppTextTheme.semiBoldXl,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
    ),
    tabBarTheme: TabBarThemeData(
      unselectedLabelStyle: AppTextTheme.regularSm.copyWith(
        color: AppColorTheme.secondary200,
      ),
      indicatorColor: AppColorTheme.primary900,
      overlayColor: WidgetStatePropertyAll(AppColorTheme.secondary50),
      labelStyle: AppTextTheme.regularSm.copyWith(
        color: AppColorTheme.primary900,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorTheme.primary500,
        textStyle: AppTextTheme.regularSm,
      ),
    ),
  );
}
