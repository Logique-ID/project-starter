import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  double get textScaleFactor => MediaQuery.textScaleFactorOf(this);
  double get topPadding => MediaQuery.paddingOf(this).top;
  bool get hasNotch => topPadding > 20;

  EdgeInsets get safeAreaPadding => MediaQuery.paddingOf(this);

  double get responsiveAspect => isMobile ? 0.8 : 1.0;
  int get gridColumns => isMobile ? 2 : 4;

  // Generic responsive method
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
