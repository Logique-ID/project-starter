import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'device_type.dart';

part 'device_info.g.dart';

class DeviceInfo {
  final double screenWidth;
  final double screenHeight;
  final DeviceType deviceType;
  final Orientation orientation;
  final double textScaleFactor;
  final double topPadding;
  final EdgeInsets padding;

  const DeviceInfo({
    required this.screenWidth,
    required this.screenHeight,
    required this.deviceType,
    required this.orientation,
    required this.textScaleFactor,
    required this.topPadding,
    required this.padding,
  });

  bool get isMobile => deviceType.isMobile;
  bool get isTablet => deviceType.isTablet;
  bool get isDesktop => deviceType.isDesktop;

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  bool get hasNotch => topPadding > 20;

  double get screenDiagonal =>
      (screenWidth * screenWidth + screenHeight * screenHeight).toDouble();

  @override
  String toString() =>
      'DeviceInfo('
      'width: $screenWidth, '
      'height: $screenHeight, '
      'type: $deviceType, '
      'orientation: ${isPortrait ? "portrait" : "landscape"}'
      ')';
}

// Providers
@riverpod
class DeviceInfoNotifier extends _$DeviceInfoNotifier {
  @override
  DeviceInfo build() {
    return _createInitialDeviceInfo();
  }

  static DeviceInfo _createInitialDeviceInfo() {
    // This should be called from a BuildContext in a real app
    // For now, return default values
    return const DeviceInfo(
      screenWidth: 0,
      screenHeight: 0,
      deviceType: DeviceType.mobile,
      orientation: Orientation.portrait,
      textScaleFactor: 1.0,
      topPadding: 0,
      padding: EdgeInsets.zero,
    );
  }

  void updateDeviceInfo(DeviceInfo info) {
    state = info;
  }
}

final responsiveValueProvider = Provider.family<dynamic, Map<String, dynamic>>((
  Ref ref,
  Map<String, dynamic> params,
) {
  final deviceInfo = ref.watch(deviceInfoProvider);
  final mobile = params['mobile'];
  final tablet = params['tablet'];
  final desktop = params['desktop'];

  return switch (deviceInfo.deviceType) {
    DeviceType.mobile => mobile,
    DeviceType.tablet => tablet ?? mobile,
    DeviceType.desktop => desktop ?? tablet ?? mobile,
  };
});

extension ResponsiveRef on WidgetRef {
  DeviceInfo get deviceInfo => watch(deviceInfoProvider);

  bool get isMobile => deviceInfo.isMobile;
  bool get isTablet => deviceInfo.isTablet;
  bool get isDesktop => deviceInfo.isDesktop;
  bool get isPortrait => deviceInfo.isPortrait;
  bool get isLandscape => deviceInfo.isLandscape;

  bool get hasNotch => deviceInfo.hasNotch;

  double get screenWidth => deviceInfo.screenWidth;
  double get screenHeight => deviceInfo.screenHeight;
  double get textScaleFactor => deviceInfo.textScaleFactor;
}
