/// This file defines the AllowNotificationRequestPayload class, which represents the request payload
/// for allowing notifications in the Zarpay application.

import 'package:equatable/equatable.dart';
import 'package:zarpay/app/core/utilities/json_utils.dart';

/// The AllowNotificationRequestPayload class represents the request payload for allowing notifications.
class AllowNotificationRequestPayload extends Equatable
    implements JsonConverter {
  final bool isAllowedNotification;

  /// Constructor for the AllowNotificationRequestPayload class.
  ///
  /// [isAllowedNotification] Indicates whether notifications are allowed.
  const AllowNotificationRequestPayload({
    required this.isAllowedNotification,
  });

  /// Factory method for creating a AllowNotificationRequestPayload instance from a JSON map.
  ///
  /// [json] The JSON map containing allow notification request data.
  /// Returns a AllowNotificationRequestPayload instance.
  @override
  AllowNotificationRequestPayload fromJson(Map<String, dynamic> json) {
    return AllowNotificationRequestPayload(
      isAllowedNotification: json["allow_notifications"] ?? false,
    );
  }

  /// Converts the AllowNotificationRequestPayload instance to a JSON map.
  ///
  /// Returns a JSON map representing the allow notification request data.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["allow_notifications"] = isAllowedNotification;
    return data;
  }

  /// List of properties to include in equality comparison.
  ///
  /// Returns a list containing the isAllowedNotification property.
  @override
  List<Object?> get props => [isAllowedNotification];
}
