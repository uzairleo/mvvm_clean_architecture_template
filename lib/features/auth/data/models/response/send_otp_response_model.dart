/// This file defines the SendOtpResponseModel class, which represents the response model
/// for sending OTP in the Zarpay application.

import 'package:equatable/equatable.dart';
import 'package:zarpay/app/core/utilities/json_utils.dart';

/// The SendOtpResponseModel class represents the response model for sending OTP.
class SendOtpResponseModel extends Equatable implements JsonConverter {
  final String message;

  /// Constructor for the SendOtpResponseModel class.
  ///
  /// [message] The message received after sending OTP.
  const SendOtpResponseModel({
    required this.message,
  });

  /// Factory constructor to create a SendOtpResponseModel instance from a JSON map.
  ///
  /// [json] The JSON map containing OTP sending response data.
  /// Returns a SendOtpResponseModel instance.
  @override
  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SendOtpResponseModel(
      message: json["message"],
    );
  }

  /// Converts the SendOtpResponseModel instance to a JSON map.
  ///
  /// Returns a JSON map representing the OTP sending response data.
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

  /// Method for converting JSON to an instance of SendOtpResponseModel.
  ///
  /// This method is unimplemented and throws an UnimplementedError.
  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
