import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
{{#use_splash}}
import 'package:flutter_native_splash/flutter_native_splash.dart';
{{/use_splash}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app.dart';
import '../constant/error_message.dart';
import '../core/mixins/startup_mixin.dart';
{{#use_localization}}
import '../localization/app_localization_repository.dart';
{{/use_localization}}
import '../monitoring/error_log/error_log_facade.dart';
{{#use_firebase}}
import '../service/firebase/firebase_service.dart';
{{/use_firebase}}
import '../utils/data_source_config/sembast/sembast_config.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  ref.onDispose(() {
    ref.invalidate(sembastDatabaseProvider);
  });

  await ref.watch(sembastDatabaseProvider.future);
  {{#use_localization}}
  await ref.watch(appLocalizationRepositoryProvider).readLocalization(ref);
  {{/use_localization}}
  {{#use_firebase}}
  await ref.read(firebaseServiceProvider).init();
  {{/use_firebase}}
  {{#use_splash}}

  FlutterNativeSplash.remove();
  {{/use_splash}}
}

/// Widget class to manage asynchronous app initialization
class AppStartupScreen extends ConsumerWidget with StartupMixin {
  const AppStartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return startupState(ref).when(
      data: (_) => const App(),
      loading: () => const _AppStartupWidget(isLoading: true),
      error: (e, st) {
        ref.read(errorLogFacadeProvider).nonFatalError(e, st);
        return _AppStartupWidget(
          isLoading: false,
          message: kReleaseMode
              ? ErrorMessage.defaultUnParseErrorMsg
              : e.toString(),
          onRetry: () => startupRetry(ref),
        );
      },
    );
  }
}

///can be designed as splash screen
class _AppStartupWidget extends StatelessWidget {
  const _AppStartupWidget({
    required this.isLoading,
    this.message,
    this.onRetry,
  });
  final bool isLoading;

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$message',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: onRetry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
