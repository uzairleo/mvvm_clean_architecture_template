/// This file defines the SendOtpUsecase class, which handles the use case
/// for sending OTP in the Zarpay application.

import 'package:fpdart/fpdart.dart';
import 'package:zarpay/app/core/error/failure.dart';
import 'package:zarpay/app/core/models/request/request.dart';
import 'package:zarpay/app/features/auth/data/models/request/send_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/send_otp_response_model.dart';
import 'package:zarpay/app/features/auth/domain/repository/auth_repository.dart';

/// The SendOtpUsecase class handles the use case for sending OTP.
///
/// This class interacts with the AuthRepository to send the OTP request
/// and return the response.
class SendOtpUsecase {
  final AuthRepository _authRepository;

  /// Constructor for the SendOtpUsecase class.
  ///
  /// [authRepository] The repository used to handle authentication-related operations.
  SendOtpUsecase(this._authRepository);

  /// Calls the sendOtp method of the AuthRepository.
  ///
  /// [request] The payload for the send OTP request.
  /// Returns a Future containing either a Failure or a SendOtpResponseModel.
  Future<Either<Failure, SendOtpResponseModel>> call(
      SendOtpRequestPayload request) async {
    return await _authRepository.sendOtp(Request(request));
  }
}
