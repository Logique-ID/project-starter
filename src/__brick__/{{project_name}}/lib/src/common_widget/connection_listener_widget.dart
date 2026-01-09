import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../flavor.dart';
import '../core/mixins/connection_listener_mixin.dart';
import '../localization/string_hardcoded.dart';
import '../theme/app_color_theme.dart';
import '../theme/app_text_theme.dart';

class ConnectionListenerWidget extends ConsumerStatefulWidget {
  const ConnectionListenerWidget({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionListenerWidgetState();
}

class _ConnectionListenerWidgetState
    extends ConsumerState<ConnectionListenerWidget>
    with ConnectionMixin {
  late StreamSubscription<InternetStatus> connectionListener;

  @override
  void initState() {
    connectionListener = InternetConnection.createInstance().onStatusChange
        .listen((status) {
          setConnectionAvailable(ref, status == InternetStatus.connected);
        });
    super.initState();
  }

  @override
  void dispose() {
    connectionListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
            ),
      child: SafeArea(
        child: Column(
          children: [
            Consumer(
              builder: (context, consRef, _) => !isConnectionAvailable(consRef)
                  ? const _ConnectionStatusWidget()
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: Stack(
                children: [
                  widget.child,
                  if (!kReleaseMode) _CustomBannerWidget(ref: ref),
                ],
              ),
              /* , */
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomBannerWidget extends StatelessWidget {
  const _CustomBannerWidget({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: -25,
      child: Transform.rotate(
        angle: 0.7,
        child: GestureDetector(
          onTap: () {
            // TODO action when banner is tapped
            /*  final isTest = ref.read(isTestingModeProvider);
            if (!kReleaseMode && !isTest) {
              ref.read(aliceProvider).showInspector();
            } */
          },
          child: Container(
            width: 120,
            color: F.appFlavor == Flavor.dev
                ? AppColorTheme.alert700.withValues(alpha: 0.5)
                : F.appFlavor == Flavor.stg
                ? AppColorTheme.warning700.withValues(alpha: 0.5)
                : AppColorTheme.primary300.withValues(alpha: 0.3),
            child: Center(
              child: Text(
                F.appFlavor.name.toUpperCase(),
                style: AppTextTheme.boldXs.copyWith(
                  color: AppColorTheme.white,
                  decoration: TextDecoration.none,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionStatusWidget extends StatelessWidget {
  const _ConnectionStatusWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      color: AppColorTheme.alert400,
      child: Row(
        children: <Widget>[
          Icon(Icons.signal_wifi_off, color: AppColorTheme.alert700),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'You Are Offline! Please Connect To The Internet'.hardcoded,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 12.sp,
                color: AppColorTheme.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
