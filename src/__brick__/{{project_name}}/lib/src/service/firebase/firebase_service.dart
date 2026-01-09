import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../feature/authentication/data/auth_repository.dart';
import '../../utils/common_utils.dart';
import '../notification/local_notification.dart';

part 'firebase_service.g.dart';

class FirebaseService {
  FirebaseService(this._ref);

  final Ref _ref;

  Future<void> init() async {
    await _initializeFirebaseFCM();
  }

  /// Request notification permissions. Should be called after successful login.
  Future<bool> requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _initializeFirebaseFCM() async {
    await _handleToken();

    await _setupInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message, 'onMessageOpenedApp');
    });

    FirebaseMessaging.onMessage.listen((message) {
      _ref.read(localNotificationProvider).showLocalNotification(message);
    });
  }

  Future<void> _handleToken() async {
    String? token;
    try {
      if (Platform.isIOS) {
        token = await FirebaseMessaging.instance.getAPNSToken();
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }
    } catch (e, stackTrace) {
      CommonUtils.printAndRecordLog(e, stackTrace.toString());
      token = 'unknown';
    }

    if (token != null) {
      await _ref.watch(authRepositoryProvider).saveFcmToken(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final authRepository = _ref.watch(authRepositoryProvider);
      await authRepository.saveFcmToken(token);
      if (authRepository.currentUser != null) {
        //TODO call API update fcm token but should not wait until it finish
      }
    });
  }

  Future<void> _setupInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    _handleMessage(initialMessage, 'getInitialMessage');
  }
}

@Riverpod(keepAlive: true)
FirebaseService firebaseService(Ref ref) {
  return FirebaseService(ref);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  _handleMessage(message, 'firebaseMessagingBackgroundHandler');
}

void _handleMessage(RemoteMessage? message, String methodSource) {
  if (message != null) {
    final notifPayload = message.data;
    onMsgClicked(notifPayload, methodSource);
  }
}

void onMsgClicked(Map<String, dynamic> notifPayload, String methodSource) {
  log('notifPayload: $notifPayload - methodSource: $methodSource');

  //TODO get payload param by notifPayload['paramName']
  //TODO perform action for example to open specific screen
}
