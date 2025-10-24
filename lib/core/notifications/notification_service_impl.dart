/// This file provides an implementation of the [NotificationService] abstract class
/// using Firebase Cloud Messaging and Flutter Local Notifications.

import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zarpay/app/core/notifications/notification_service.dart';

/// Implementation of [NotificationService] using Firebase Cloud Messaging and Flutter Local Notifications.
class NotificationServiceImpl implements NotificationService {
  /// Firebase Cloud Messaging token.
  String fcmToken = "";

  /// Instance of [FirebaseMessaging] for handling FCM.
  var _messaging = FirebaseMessaging.instance;

  /// Instance of [FlutterLocalNotificationsPlugin] for showing local notifications.
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'com.mobile.zarpay';
  static const _channelName = 'zarpay';

  /// Initializes the notification service.
  ///
  /// Sets up the FCM instance, retrieves the FCM token, and listens for incoming messages.
  @override
  Future<void> init() async {
    _messaging = FirebaseMessaging.instance;
    await getToken();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        showNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          type: message.data['type'] ?? '',
        );
      }
    });
    final message = await _messaging.getInitialMessage();
    await _onMessageOpenedApp(message);
    FirebaseMessaging.onMessageOpenedApp.listen(_addEvent);
  }

  /// Handles the event when a message is opened from the app.
  Future<void> _onMessageOpenedApp(RemoteMessage? message) async {
    if (message == null) return;
  }

  /// Displays a notification with the provided [title], [body], and [type].
  ///
  /// Uses the [FlutterLocalNotificationsPlugin] to show the notification.
  @override
  Future<void> showNotification({
    String? title,
    String? body,
    String? type,
  }) async {
    try {
      final id = Random().nextInt(10000);

      await _notificationsPlugin.show(
        id,
        title ?? "Zarpay",
        body ?? "Details",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.max,
            icon: "ic_notification",
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (_) {}
  }

  /// Handles adding an event from a remote message.
  void _addEvent(RemoteMessage? message) {}

  /// Retrieves the current FCM token.
  ///
  /// Returns the FCM token as a [String].
  @override
  Future<String?> getToken() async {
    return await _messaging.getToken().then((value) {
      fcmToken = value ?? "";
      return value;
    });
  }

  /// Requests permission to show notifications.
  ///
  /// Returns the [NotificationSettings] indicating the current permission status.
  @override
  Future<NotificationSettings> requestPermission() async {
    return await _messaging.requestPermission();
  }

  /// Retrieves the push notification ID.
  ///
  /// Returns the push notification ID as a [String].
  @override
  String get pushId => fcmToken;

  /// Retrieves the current notification settings.
  ///
  /// Returns the [NotificationSettings] indicating the current settings.
  @override
  Future<NotificationSettings> getCurrentSettings() async {
    return await _messaging.getNotificationSettings();
  }

  /// Enables or disables notifications based on the [enable] parameter.
  ///
  /// [enable] is a boolean indicating whether to enable or disable notifications.
  @override
  Future<void> enableNotifications(bool enable) async {
    await _messaging.requestPermission(
      alert: enable,
      badge: enable,
      sound: enable,
      announcement: enable,
      carPlay: enable,
      criticalAlert: enable,
    );
  }
}

/// Background message handler for FCM.
Future<void> backgroundHandler(RemoteMessage message) async {}
