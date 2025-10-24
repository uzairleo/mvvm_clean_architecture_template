/// This file defines the VerifyOtpResponseModel class, which represents the response model
/// for verifying OTP in the Zarpay application.

import 'package:equatable/equatable.dart';
import 'package:zarpay/app/core/utilities/json_utils.dart';

/// The VerifyOtpResponseModel class represents the response model for verifying OTP.
class VerifyOtpResponseModel extends Equatable implements JsonConverter {
  final String idToken;

  /// Constructor for the VerifyOtpResponseModel class.
  ///
  /// [idToken] The ID token received after OTP verification.
  const VerifyOtpResponseModel({
    required this.idToken,
  });

  /// Factory constructor to create a VerifyOtpResponseModel instance from a JSON map.
  ///
  /// [json] The JSON map containing OTP verification response data.
  /// Returns a VerifyOtpResponseModel instance.
  @override
  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      idToken: json["idToken"],
    );
  }

  /// Converts the VerifyOtpResponseModel instance to a JSON map.
  ///
  /// Returns a JSON map representing the OTP verification response data.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idToken"] = idToken;
    return data;
  }

  /// List of properties to include in equality comparison.
  ///
  /// Returns a list containing the ID token.
  @override
  List<Object?> get props => [idToken];

  /// Method for converting JSON to an instance of VerifyOtpResponseModel.
  ///
  /// This method is unimplemented and throws an UnimplementedError.
  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
