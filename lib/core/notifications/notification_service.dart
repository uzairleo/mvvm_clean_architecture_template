/// This file defines the [NotificationService] abstract class, which provides
/// an interface for managing notifications in the application.

import 'package:firebase_messaging/firebase_messaging.dart';

/// An abstract class that provides an interface for managing notifications.
abstract class NotificationService {
  /// Initializes the notification service.
  ///
  /// This method should be called to set up the notification service.
  Future<void> init();

  /// Requests permission to show notifications.
  ///
  /// Returns the [NotificationSettings] indicating the current permission status.
  Future<NotificationSettings> requestPermission();

  /// Retrieves the current FCM token.
  ///
  /// Returns the FCM token as a [String].
  Future<String?> getToken();

  /// Displays a notification with the provided [title], [body], and [type].
  ///
  /// [title] is the title of the notification.
  /// [body] is the body of the notification.
  /// [type] is the type of the notification.
  Future<void> showNotification({String? title, String? body, String? type});

  /// Retrieves the push notification ID.
  ///
  /// Returns the push notification ID as a [String].
  String get pushId;

  /// Retrieves the current notification settings.
  ///
  /// Returns the [NotificationSettings] indicating the current settings.
  Future<NotificationSettings> getCurrentSettings();

  /// Enables or disables notifications based on the [enable] parameter.
  ///
  /// [enable] is a boolean indicating whether to enable or disable notifications.
  Future<void> enableNotifications(bool enable);
}
