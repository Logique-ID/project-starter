import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_widget/connection_listener_widget.dart';
import 'core/mixins/router_mixin.dart';
{{#use_localization}}
import 'localization/app_localization_repository.dart';
import 'localization/app_localizations.dart';
{{/use_localization}}
import 'theme/app_theme.dart';

class App extends ConsumerWidget with RouterMixin {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: goRouter(ref),
          restorationScopeId: 'app',
          {{#use_localization}}
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
          ],
          locale: Locale(ref.watch(localeProvider)),
          supportedLocales: AppLocalizations.supportedLocales,
          {{/use_localization}}
          builder: (context, widget) => _OrientationLocker(
            child: ConnectionListenerWidget(child: widget!),
          ),
          theme: appLightTheme,
        );
      },
    );
  }
}

class _OrientationLocker extends StatefulWidget {
  final Widget child;

  const _OrientationLocker({required this.child});

  @override
  State<_OrientationLocker> createState() => _OrientationLockerState();
}

class _OrientationLockerState extends State<_OrientationLocker>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _forcePortrait();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _forcePortrait();
    }
  }

  void _forcePortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
