/// This file defines the VerifyOtpRequestPayload class, which represents the request payload
/// for verifying OTP in the Zarpay application.

import 'package:equatable/equatable.dart';
import 'package:zarpay/app/core/utilities/json_utils.dart';
import 'package:zarpay/app/features/auth/data/models/device.dart';

/// The VerifyOtpRequestPayload class represents the request payload for verifying OTP.
class VerifyOtpRequestPayload extends Equatable implements JsonConverter {
  final String phoneNumber;
  final String countryCode;
  final String verificationCode;
  final Device? device;

  /// Constructor for the VerifyOtpRequestPayload class.
  ///
  /// [phoneNumber] The phone number to verify.
  /// [countryCode] The country code of the phone number.
  /// [verificationCode] The verification code received via OTP.
  /// [device] The device information.
  const VerifyOtpRequestPayload({
    required this.phoneNumber,
    required this.countryCode,
    required this.verificationCode,
    this.device,
  });

  /// Factory method for creating a VerifyOtpRequestPayload instance from a JSON map.
  ///
  /// [json] The JSON map containing OTP verification request data.
  /// Returns a VerifyOtpRequestPayload instance.
  @override
  VerifyOtpRequestPayload fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestPayload(
      phoneNumber: json["phone_number"],
      countryCode: json["country_code"],
      verificationCode: json["verification_code"],
      device: json["device"] != null ? Device.fromJson(json["device"]) : null,
    );
  }

  /// Converts the VerifyOtpRequestPayload instance to a JSON map.
  ///
  /// Returns a JSON map representing the OTP verification request data.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["phone_number"] = phoneNumber;
    data["country_code"] = countryCode;
    data["verification_code"] = verificationCode;
    data["device"] = device?.toJson();
    return data;
  }

  /// List of properties to include in equality comparison.
  ///
  /// Returns a list containing the phone number.
  @override
  List<Object?> get props => [phoneNumber];
}
