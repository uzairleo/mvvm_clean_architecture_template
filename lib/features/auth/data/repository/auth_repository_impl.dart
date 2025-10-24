/// This file defines the AuthRepositoryImpl class, which implements the AuthRepository interface.
/// It provides concrete implementations for authentication-related operations, including sending OTP,
/// verifying OTP, and allowing notifications in the Zarpay application.

import 'package:fpdart/fpdart.dart';
import 'package:zarpay/app/core/Exception/exception.dart';
import 'package:zarpay/app/core/error/failure.dart';
import 'package:zarpay/app/core/error/server_failure.dart';
import 'package:zarpay/app/core/models/request/request.dart';
import 'package:zarpay/app/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:zarpay/app/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:zarpay/app/features/auth/data/models/request/allow_notification_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/send_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/allow_notification_response_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/send_otp_response_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/verify_otp_response_model.dart';
import 'package:zarpay/app/features/auth/domain/repository/auth_repository.dart';

/// The AuthRepositoryImpl class implements the AuthRepository interface.
///
/// This class provides concrete implementations for sending OTP, verifying OTP, and allowing notifications
/// by interacting with remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;

  /// Constructor for the AuthRepositoryImpl class.
  ///
  /// [remoteDatasource] The remote data source used for authentication operations.
  /// [localDatasource] The local data source used for caching authentication data.
  AuthRepositoryImpl(this._remoteDatasource, this._localDatasource);

  /// Sends an OTP request.
  ///
  /// [request] The request object containing the OTP request payload.
  /// Returns a Future containing either a Failure or a SendOtpResponseModel.
  @override
  Future<Either<Failure, SendOtpResponseModel>> sendOtp(
      Request<SendOtpRequestPayload> request) async {
    try {
      return Right(await _remoteDatasource.sendOtp(request));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code, e.messages));
    }
  }

  /// Verifies an OTP request.
  ///
  /// [request] The request object containing the OTP verification payload.
  /// Returns a Future containing either a Failure or a VerifyOtpResponseModel.
  @override
  Future<Either<Failure, VerifyOtpResponseModel>> verifyOtp(
      Request<VerifyOtpRequestPayload> request) async {
    try {
      VerifyOtpResponseModel response =
          await _remoteDatasource.verifyOtp(request);
      await _localDatasource.saveIdToken(request.data, response);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code, e.messages));
    } on CacheException catch (e) {
      return Left(ServerFailure(e.code, e.messages));
    }
  }

  /// Allows notifications.
  ///
  /// [request] The request object containing the allow notification payload.
  /// Returns a Future containing either a Failure or an AllowNotificationResponseModel.
  @override
  Future<Either<Failure, AllowNotificationResponseModel>> allowNotification(
      Request<AllowNotificationRequestPayload> request) async {
    try {
      AllowNotificationResponseModel response =
          await _remoteDatasource.allowNotification(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code, e.messages));
    }
  }
}
