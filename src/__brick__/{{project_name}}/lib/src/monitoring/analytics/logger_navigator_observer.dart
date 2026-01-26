import 'dart:developer';

import 'package:flutter/material.dart';

import 'analytics_facade.dart';

class LoggerNavigatorObserver extends NavigatorObserver {
  LoggerNavigatorObserver(this._analytics);
  final AnalyticsFacade _analytics;

  static const _name = 'Navigation';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logNavigation(route.settings.name, 'push');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logNavigation(route.settings.name, 'pop');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _logNavigation(newRoute.settings.name, 'replace');
    }
  }

  void _logNavigation(String? routeName, String action) {
    if (routeName != null) {
      _analytics.trackScreenView(routeName, action);
    } else {
      log('Route name is missing', name: _name);
    }
  }
}
