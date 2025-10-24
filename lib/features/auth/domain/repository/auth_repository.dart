/// This file defines the AuthRepository abstract class, which provides an interface
/// for authentication-related operations in the Zarpay application.
/// The operations include sending OTP, verifying OTP, and allowing notifications.

import 'package:fpdart/fpdart.dart';
import 'package:zarpay/app/core/error/failure.dart';
import 'package:zarpay/app/core/models/request/request.dart';
import 'package:zarpay/app/features/auth/data/models/request/allow_notification_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/send_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/allow_notification_response_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/send_otp_response_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/verify_otp_response_model.dart';

/// The AuthRepository abstract class provides an interface for authentication-related operations.
abstract class AuthRepository {
  /// Sends an OTP request.
  ///
  /// [request] The request object containing the OTP request payload.
  /// Returns a Future containing either a Failure or a SendOtpResponseModel.
  Future<Either<Failure, SendOtpResponseModel>> sendOtp(
      Request<SendOtpRequestPayload> request);

  /// Verifies an OTP request.
  ///
  /// [request] The request object containing the OTP verification payload.
  /// Returns a Future containing either a Failure or a VerifyOtpResponseModel.
  Future<Either<Failure, VerifyOtpResponseModel>> verifyOtp(
      Request<VerifyOtpRequestPayload> request);

  /// Allows notifications.
  ///
  /// [request] The request object containing the allow notification payload.
  /// Returns a Future containing either a Failure or an AllowNotificationResponseModel.
  Future<Either<Failure, AllowNotificationResponseModel>> allowNotification(
      Request<AllowNotificationRequestPayload> request);
}
