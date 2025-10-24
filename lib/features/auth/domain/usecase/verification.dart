/// This file defines the VerificationUseCase class, which handles the use case
/// for verifying OTP in the Zarpay application.

import 'package:fpdart/fpdart.dart';
import 'package:zarpay/app/core/error/failure.dart';
import 'package:zarpay/app/core/models/request/request.dart';
import 'package:zarpay/app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/verify_otp_response_model.dart';
import 'package:zarpay/app/features/auth/domain/repository/auth_repository.dart';

/// The VerificationUseCase class handles the use case for verifying OTP.
///
/// This class interacts with the AuthRepository to send the OTP verification request
/// and return the response.
class VerificationUseCase {
  final AuthRepository _authRepository;

  /// Constructor for the VerificationUseCase class.
  ///
  /// [authRepository] The repository used to handle authentication-related operations.
  VerificationUseCase(this._authRepository);

  /// Calls the verifyOtp method of the AuthRepository.
  ///
  /// [request] The payload for the OTP verification request.
  /// Returns a Future containing either a Failure or a VerifyOtpResponseModel.
  Future<Either<Failure, VerifyOtpResponseModel>> call(
      VerifyOtpRequestPayload request) async {
    return await _authRepository.verifyOtp(Request(request));
  }
}
