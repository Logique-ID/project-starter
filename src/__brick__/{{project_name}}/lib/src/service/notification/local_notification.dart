import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../firebase/firebase_service.dart';

part 'local_notification.g.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const notifChannelId = 'guzilla_notif_channel_id';
const notifChannelName = 'guzilla Notif Channel';

class LocalNotification {
  LocalNotification();
  final _androidNotificationDetails = const AndroidNotificationDetails(
    notifChannelId,
    notifChannelName,
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker',
    visibility: NotificationVisibility.public,
    channelDescription: 'This is a general notifications channel',
    playSound: true,
    icon: '@drawable/ic_bg_service_small',
  );
  final _darwinNotificationDetails = const DarwinNotificationDetails();

  Future<void> init() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    //TODO change drawable/ic_notification.png
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        const DarwinInitializationSettings(
          //TODO: add onDidReceiveLocalNotification when needed
          //onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
        );
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            _androidNotificationDetails.channelId,
            _androidNotificationDetails.channelName,
            description: _androidNotificationDetails.channelDescription,
            importance: _androidNotificationDetails.importance,
          ),
        );
  }

  //TODO: add onDidReceiveLocalNotification when needed
  /* void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    final String? notifPayload = payload;
    if (notifPayload != null) {
      final Map<String, dynamic> payloadJson = json.decode(notifPayload);

      onMsgClicked(payloadJson, '_onDidReceiveLocalNotification');
    }
  } */

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? notifPayload = notificationResponse.payload;
    if (notifPayload != null) {
      final Map<String, dynamic> payloadJson = json.decode(notifPayload);

      onMsgClicked(payloadJson, '_onDidReceiveNotificationResponse');
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: json.encode(message.data),
    );
  }
}

Future<void> _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  final String? notifPayload = notificationResponse.payload;
  if (notifPayload != null) {
    final Map<String, dynamic> payloadJson = json.decode(notifPayload);

    onMsgClicked(payloadJson, '_onDidReceiveBackgroundNotificationResponse');
  }
}

@Riverpod(keepAlive: true)
LocalNotification localNotification(Ref ref) => LocalNotification();
