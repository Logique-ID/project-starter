import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../flavor.dart';
import '../feature/authentication/data/auth_repository.dart';
import '../feature/login/presentation/login_screen.dart';
import '../feature/main_nav/presentation/main_nav_screen.dart';
{{#use_dio}}
import '../utils/data_source_config/dio/dio_config.dart';
{{/use_dio}}
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

enum AppRoute { mainNav, login }

@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  {{#use_dio}}
  final navigatorKey = ref.watch(aliceProvider).getNavigatorKey();
  {{/use_dio}}
  {{^use_dio}}
  final navigatorKey = GlobalKey<NavigatorState>();
  {{/use_dio}}
  return GoRouter(
    initialLocation: '${MainNavScreen.path}/0',
    debugLogDiagnostics: !kReleaseMode && F.appFlavor != Flavor.prod,
    navigatorKey: navigatorKey,
    refreshListenable: GoRouterRefreshStream(
      authRepository.authStateChangesStream(),
    ),
    redirect: (context, state) {
      final isLoggedin = authRepository.currentUser?.accessToken != null;
      // TODO if not logged in but want to go to authorized screen then redirect to login

      //TODO if logged in but still in login screen then redirect to previous screen
      //TODO if not logged in but still in authorized screen then redirect to login

      return null;
    },
    routes: [
      GoRoute(
        path: '${MainNavScreen.path}/:currentIndex',
        name: AppRoute.mainNav.name,
        pageBuilder: (context, state) {
          final currentIndex = int.parse(state.pathParameters['currentIndex']!);

          return _transitionPage(
            state: state,
            child: MainNavScreen(currentIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: LoginScreen.path,
            name: AppRoute.login.name,
            pageBuilder: (context, state) =>
                _transitionPage(state: state, child: const LoginScreen()),
          ),
        ],
      ),
    ],
  );
}

Page<dynamic> _transitionPage({
  required GoRouterState state,
  required Widget child,
}) {
  return Platform.isIOS
      ? CupertinoPage<void>(
          maintainState: true,
          key: state.pageKey,
          child: child,
          restorationId: 'app',
        )
      : CustomTransitionPage<void>(
          maintainState: true,
          transitionDuration: const Duration(milliseconds: 320),
          key: state.pageKey,
          child: child,
          restorationId: 'app',
          transitionsBuilder:
              _fadeAndScaleTranisiton, //Customize the animation transition here
        );
}

//////Transition Animation Options

/// Fade Transition:
///
/// Widget _fadeTransition(BuildContext context, Animation<double> animation,
///     Animation<double> secondaryAnimation, Widget child) {
///   return FadeTransition(
///     opacity: animation,
///     child: child,
///   );
/// }

/// Slide Transition
///
// Widget _slideTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) {
//   const begin = Offset(1.0, 0.0);
//   const end = Offset.zero;
//   const curve = Curves.ease;
//   final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//   return SlideTransition(
//     position: animation.drive(tween),
//     child: child,
//   );
// }

/// Scale Transition
///
// Widget _scaleTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) {
//   return ScaleTransition(
//     scale: animation,
//     child: child,
//   );
// }

/// Rotation Transition
///
// Widget _rotationTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) {
//   return RotationTransition(
//     turns: animation,
//     child: child,
//   );
// }

/// Size Transition
///
// Widget _sizeTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) {
//   return Align(
//     child: SizeTransition(
//       sizeFactor: animation,
//       child: child,
//     ),
//   );
// }

/// Rotation + Scale Transition
///
// Widget _rotationAndScaleTransition(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child) {
//   return RotationTransition(
//     turns: animation,
//     child: ScaleTransition(
//       scale: animation,
//       child: child,
//     ),
//   );
// }

/// Slide + Fade Transition
// Widget _slideAndFadeTransition(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child) {
//   return SlideTransition(
//     position: Tween<Offset>(
//       begin: const Offset(1.0, 0.0),
//       end: Offset.zero,
//     ).animate(animation),
//     child: FadeTransition(
//       opacity: animation,
//       child: child,
//     ),
//   );
// }

/// Flipping Transition
///
// Widget _flippingTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) {
//   final angle = animation.value * pi;
//   final transform = Matrix4.identity()
//     ..setEntry(3, 2, 0.001)
//     ..rotateY(angle);
//   return Transform(
//       transform: transform,
//       alignment: Alignment.center,
//       child: animation.value <= 0.5
//           ? child
//           : Transform(
//               transform: Matrix4.rotationY(pi),
//               alignment: Alignment.center,
//               child: child,
//             ));
// }

/// Fade + Scale transition
///
Widget _fadeAndScaleTranisiton(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    ),
  );
}
