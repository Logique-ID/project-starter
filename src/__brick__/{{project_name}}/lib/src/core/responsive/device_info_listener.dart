import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'device_info.dart';
import 'device_type.dart';

DeviceType _getDeviceType(double width) {
  if (width < 600) {
    return DeviceType.mobile;
  } else if (width < 1200) {
    return DeviceType.tablet;
  } else {
    return DeviceType.desktop;
  }
}

class DeviceInfoListener extends ConsumerWidget {
  final Widget child;

  const DeviceInfoListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(deviceInfoProvider.notifier)
          .updateDeviceInfo(
            DeviceInfo(
              screenWidth: mediaQuery.size.width,
              screenHeight: mediaQuery.size.height,
              deviceType: _getDeviceType(mediaQuery.size.width),
              orientation: mediaQuery.orientation,
              textScaleFactor: mediaQuery.textScaler.scale(1.0),
              topPadding: mediaQuery.padding.top,
              padding: mediaQuery.padding,
            ),
          );
    });

    return child;
  }
}
