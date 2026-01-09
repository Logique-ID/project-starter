import 'package:flutter/material.dart';

class AppColorTheme {
  static final MaterialColor primarySwatch = MaterialColor(0xFF000000, swatch);

  static final Map<int, Color> swatch = {
    50: primary50,
    100: primary100,
    200: primary200,
    300: primary300,
    400: primary400,
    500: primary500,
    600: primary600,
    700: primary700,
    800: primary800,
    900: primary900,
  };

  static Color primary50 = '#e6effa'.toColor();
  static Color primary100 = '#b3d1f0'.toColor();
  static Color primary200 = '#80b2e6'.toColor();
  static Color primary300 = '#4d94db'.toColor();
  static Color primary400 = '#267bdd'.toColor();
  static Color primary500 = '#0057d9'.toColor();
  static Color primary600 = '#004ec3'.toColor();
  static Color primary700 = '#0042a8'.toColor();
  static Color primary800 = '#00378c'.toColor();
  static Color primary900 = '#00265d'.toColor();

  static Color secondary50 = '#FEF0EF'.toColor();
  static Color secondary100 = '#FCCBCA'.toColor();
  static Color secondary200 = '#FBA7A5'.toColor();
  static Color secondary300 = '#F8726E'.toColor();
  static Color secondary400 = '#F45647'.toColor();
  static Color secondary500 = '#ED4441'.toColor();
  static Color secondary600 = '#CD3C39'.toColor();
  static Color secondary700 = '#A42F2C'.toColor();
  static Color secondary800 = '#7E2320'.toColor();
  static Color secondary900 = '#5E1715'.toColor();

  static Color info50 = '#e7fbfe'.toColor();
  static Color info100 = '#b6f4fd'.toColor();
  static Color info200 = '#92eefc'.toColor();
  static Color info300 = '#61e7fb'.toColor();
  static Color info400 = '#42E2FA'.toColor();
  static Color info500 = '#009BDD'.toColor();
  static Color info600 = '#11C7E3'.toColor();
  static Color info700 = '#0D9BB1'.toColor();
  static Color info800 = '#0A7889'.toColor();
  static Color info900 = '#085c69'.toColor();

  static Color success50 = '#eefbec'.toColor();
  static Color success100 = '#CAF3C3'.toColor();
  static Color success200 = '#B0EDA6'.toColor();
  static Color success300 = '#8CE57E'.toColor();
  static Color success400 = '#75E065'.toColor();
  static Color success500 = '#53D83E'.toColor();
  static Color success600 = '#4CC538'.toColor();
  static Color success700 = '#3B992C'.toColor();
  static Color success800 = '#2E7722'.toColor();
  static Color success900 = '#235b1a'.toColor();

  static Color warning50 = '#fffbe8'.toColor();
  static Color warning100 = '#FEF1B7'.toColor();
  static Color warning200 = '#FEEA94'.toColor();
  static Color warning300 = '#FDE163'.toColor();
  static Color warning400 = '#FDDB45'.toColor();
  static Color warning500 = '#FCD216'.toColor();
  static Color warning600 = '#E5BF14'.toColor();
  static Color warning700 = '#B39510'.toColor();
  static Color warning800 = '#8B740C'.toColor();
  static Color warning900 = '#6a5809'.toColor();

  static Color alert50 = '#fef0e9'.toColor();
  static Color alert100 = '#FDCFBA'.toColor();
  static Color alert200 = '#FCB898'.toColor();
  static Color alert300 = '#FB986A'.toColor();
  static Color alert400 = '#FA844D'.toColor();
  static Color alert500 = '#F96520'.toColor();
  static Color alert600 = '#E35C1D'.toColor();
  static Color alert700 = '#b14817'.toColor();
  static Color alert800 = '#893812'.toColor();
  static Color alert900 = '#692a0d'.toColor();

  static Color white = '#FFFFFF'.toColor();
  static Color neutral100 = '#F2F2F2'.toColor();
  static Color neutral200 = '#E5E5E5'.toColor();
  static Color neutral300 = '#B2B2B2'.toColor();
  static Color neutral400 = '#666666'.toColor();
  static Color neutral500 = '#000000'.toColor();

  static Color blackRock50 = '#e7e6eb'.toColor();
  static Color blackRock100 = '#b4b1bf'.toColor();
  static Color blackRock200 = '#908ba1'.toColor();
  static Color blackRock300 = '#5d5676'.toColor();
  static Color blackRock400 = '#3d355b'.toColor();
  static Color blackRock500 = '#0d0332'.toColor();
  static Color blackRock600 = '#0c032e'.toColor();
  static Color blackRock700 = '#090224'.toColor();
  static Color blackRock800 = '#07021c'.toColor();
  static Color blackRock900 = '#050115'.toColor();
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
