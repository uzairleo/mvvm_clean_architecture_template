/// This file defines the SendOtpRequestPayload class, which represents the request payload
/// for sending OTP in the Zarpay application.

import 'package:equatable/equatable.dart';
import 'package:zarpay/app/core/utilities/json_utils.dart';

/// The SendOtpRequestPayload class represents the request payload for sending OTP.
class SendOtpRequestPayload extends Equatable implements JsonConverter {
  final String phoneNumber;
  final String countryCode;
  final String? referrerCode;

  /// Constructor for the SendOtpRequestPayload class.
  ///
  /// [phoneNumber] The phone number to send OTP to.
  /// [countryCode] The country code of the phone number.
  /// [referrerCode] The optional referrer code.
  const SendOtpRequestPayload({
    required this.phoneNumber,
    required this.countryCode,
    this.referrerCode,
  });

  /// Factory method for creating a SendOtpRequestPayload instance from a JSON map.
  ///
  /// [json] The JSON map containing OTP sending request data.
  /// Returns a SendOtpRequestPayload instance.
  @override
  SendOtpRequestPayload fromJson(Map<String, dynamic> json) {
    return SendOtpRequestPayload(
      phoneNumber: json["phone_number"],
      countryCode: json["country_code"],
      referrerCode: json["referrer_code"],
    );
  }

  /// Converts the SendOtpRequestPayload instance to a JSON map.
  ///
  /// Returns a JSON map representing the OTP sending request data.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["phone_number"] = phoneNumber;
    data["country_code"] = countryCode;
    if (referrerCode != null) data["referrer_code"] = referrerCode;
    return data;
  }

  /// List of properties to include in equality comparison.
  ///
  /// Returns a list containing the phone number.
  @override
  List<Object?> get props => [phoneNumber];
}
