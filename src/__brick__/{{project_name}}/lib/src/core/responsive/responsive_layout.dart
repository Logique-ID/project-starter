import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_info.dart';
import 'device_type.dart';

/// A responsive layout widget that displays different widgets based on screen width.
///
/// Breakpoints:
/// - Mobile: width < 768
/// - Tablet: 768 <= width < 1024
/// - Desktop: width >= 1024
///
/// [mobile] is required and shown on all screen sizes when no larger widget is
/// provided. [tablet] and [desktop] are optional and shown when screen width
/// meets their respective breakpoints.
class ResponsiveLayout extends ConsumerWidget {
  /// Widget displayed on mobile devices (width < 768).
  final Widget mobile;

  /// Optional widget displayed on tablet devices (768 <= width < 1024).
  final Widget? tablet;

  /// Optional widget displayed on desktop devices (width >= 1024).
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInfo = ref.watch(deviceInfoProvider);

    return switch (deviceInfo.deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
    };
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static T? value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= mobileBreakpoint && desktop != null) return desktop;
    if (width >= tabletBreakpoint && tablet != null) return tablet;
    return mobile;
  }
}
