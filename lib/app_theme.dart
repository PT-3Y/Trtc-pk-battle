import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: appLayoutBackground,
    primaryColor: appColorPrimary,
    primaryColorDark: appColorPrimary,
    useMaterial3: false,
    errorColor: Colors.red,
    hoverColor: Colors.white54,
    dividerColor: bodyWhite.withOpacity(0.4),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    appBarTheme: AppBarTheme(
      surfaceTintColor: appLayoutBackground,
      color: appLayoutBackground,
      iconTheme: IconThemeData(color: textPrimaryColor),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    ),
    tabBarTheme: TabBarTheme(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Color(0xFFB6D5EF), width: 3))),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    colorScheme: ColorScheme.light(primary: appColorPrimary),
    cardTheme: CardTheme(color: Colors.white),
    cardColor: appSectionBackground,
    iconTheme: IconThemeData(color: textPrimaryColor),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: whiteColor),
    textTheme: TextTheme(
      button: TextStyle(color: appColorPrimary),
      headline6: TextStyle(color: textPrimaryColor),
      subtitle2: TextStyle(color: textSecondaryColor),
    ),
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(appColorPrimary),
    ),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackgroundColorDark,
    useMaterial3: false,
    highlightColor: appBackgroundColorDark,
    errorColor: Color(0xFFCF6676),
    appBarTheme: AppBarTheme(
      surfaceTintColor: appBackgroundColorDark,
      color: appBackgroundColorDark,
      iconTheme: IconThemeData(color: whiteColor),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: appColorPrimary,
    dividerColor: bodyDark.withOpacity(0.4),
    primaryColorDark: appColorPrimary,
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    primaryTextTheme: TextTheme(headline6: primaryTextStyle(color: Colors.white), overline: primaryTextStyle(color: Colors.white)),
    cardTheme: CardTheme(color: cardBackgroundBlackDark),
    cardColor: cardBackgroundBlackDark,
    iconTheme: IconThemeData(color: whiteColor),
    textTheme: TextTheme(
      button: TextStyle(color: appColorPrimary),
      headline6: TextStyle(color: whiteColor),
      subtitle2: TextStyle(color: Colors.white54),
    ),
    tabBarTheme: TabBarTheme(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.dark(primary: appBackgroundColorDark, onPrimary: cardBackgroundBlackDark).copyWith(secondary: whiteColor),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(appColorPrimary),
    ),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );
}
