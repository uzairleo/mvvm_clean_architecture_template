/// This file defines the AuthRemoteDatasource abstract class and its implementation,
/// which provides methods for remote data interactions related to authentication in the Zarpay application.

import 'package:zarpay/app/core/constants/urls.dart';
import 'package:zarpay/app/core/httpClient/dio_service.dart';
import 'package:zarpay/app/core/models/request/request.dart';
import 'package:zarpay/app/features/auth/data/models/request/allow_notification_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/send_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/allow_notification_response_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/send_otp_response_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/verify_otp_response_model.dart';

/// The AuthRemoteDatasource abstract class provides an interface for remote data interactions related to authentication.
abstract class AuthRemoteDatasource {
  /// Sends an OTP request.
  ///
  /// [request] The request object containing the OTP request payload.
  /// Returns a Future containing a SendOtpResponseModel.
  Future<SendOtpResponseModel> sendOtp(Request<SendOtpRequestPayload> request);

  /// Verifies an OTP request.
  ///
  /// [request] The request object containing the OTP verification payload.
  /// Returns a Future containing a VerifyOtpResponseModel.
  Future<VerifyOtpResponseModel> verifyOtp(
      Request<VerifyOtpRequestPayload> request);

  /// Allows notifications.
  ///
  /// [request] The request object containing the allow notification payload.
  /// Returns a Future containing an AllowNotificationResponseModel.
  Future<AllowNotificationResponseModel> allowNotification(
      Request<AllowNotificationRequestPayload> request);
}

/// The AuthRemoteDatasourceImpl class implements the AuthRemoteDatasource interface.
///
/// This class provides a concrete implementation for remote data interactions related to authentication
/// by interacting with a Dio HTTP client.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioServices _dioClient;

  /// Constructor for the AuthRemoteDatasourceImpl class.
  ///
  /// [dioClient] The Dio HTTP client used for making network requests.
  AuthRemoteDatasourceImpl(this._dioClient);

  /// Sends an OTP request.
  ///
  /// [request] The request object containing the OTP request payload.
  /// Returns a Future containing a SendOtpResponseModel.
  @override
  Future<SendOtpResponseModel> sendOtp(
      Request<SendOtpRequestPayload> request) async {
    final data = await _dioClient.post(Urls.sendOtp, body: request.toJson());
    return SendOtpResponseModel.fromJson(data["data"] ?? {});
  }

  /// Verifies an OTP request.
  ///
  /// [request] The request object containing the OTP verification payload.
  /// Returns a Future containing a VerifyOtpResponseModel.
  @override
  Future<VerifyOtpResponseModel> verifyOtp(
      Request<VerifyOtpRequestPayload> request) async {
    final data = await _dioClient.put(Urls.verifyOtp, body: request.toJson());
    return VerifyOtpResponseModel.fromJson(data["data"] ?? {});
  }

  /// Allows notifications.
  ///
  /// [request] The request object containing the allow notification payload.
  /// Returns a Future containing an AllowNotificationResponseModel.
  @override
  Future<AllowNotificationResponseModel> allowNotification(
      Request<AllowNotificationRequestPayload> request) async {
    final data =
        await _dioClient.put(Urls.allowNotification, body: request.toJson());
    return AllowNotificationResponseModel.fromJson(data["data"] ?? {});
  }
}
