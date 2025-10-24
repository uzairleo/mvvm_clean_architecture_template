/// This file defines the AllowNotificationResponseModel class, which represents the response model
/// for allowing notifications in the Zarpay application.

import 'package:equatable/equatable.dart';
import 'package:zarpay/app/core/utilities/json_utils.dart';

/// The AllowNotificationResponseModel class represents the response model for allowing notifications.
class AllowNotificationResponseModel extends Equatable
    implements JsonConverter {
  final String message;

  /// Constructor for the AllowNotificationResponseModel class.
  ///
  /// [message] The message received after allowing notifications.
  const AllowNotificationResponseModel({
    required this.message,
  });

  /// Factory constructor to create a AllowNotificationResponseModel instance from a JSON map.
  ///
  /// [json] The JSON map containing allow notification response data.
  /// Returns a AllowNotificationResponseModel instance.
  @override
  factory AllowNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return AllowNotificationResponseModel(
      message: json["message"],
    );
  }

  /// Converts the AllowNotificationResponseModel instance to a JSON map.
  ///
  /// Returns a JSON map representing the allow notification response data.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message"] = message;
    return data;
  }

  /// List of properties to include in equality comparison.
  ///
  /// Returns a list containing the message.
  @override
  List<Object?> get props => [message];

  /// Method for converting JSON to an instance of AllowNotificationResponseModel.
  ///
  /// This method is unimplemented and throws an UnimplementedError.
  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
