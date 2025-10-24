/// This file defines the AllowNotificationUseCase class, which handles the use case
/// for allowing notifications in the Zarpay application.

import 'package:fpdart/fpdart.dart';
import 'package:zarpay/app/core/error/failure.dart';
import 'package:zarpay/app/core/models/request/request.dart';
import 'package:zarpay/app/features/auth/data/models/request/allow_notification_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/allow_notification_response_model.dart';
import 'package:zarpay/app/features/auth/domain/repository/auth_repository.dart';

/// The AllowNotificationUseCase class handles the use case for allowing notifications.
///
/// This class interacts with the AuthRepository to send the allow notification request
/// and return the response.
class AllowNotificationUseCase {
  final AuthRepository _authRepository;

  /// Constructor for the AllowNotificationUseCase class.
  ///
  /// [authRepository] The repository used to handle authentication-related operations.
  AllowNotificationUseCase(this._authRepository);

  /// Calls the allowNotification method of the AuthRepository.
  ///
  /// [request] The payload for the allow notification request.
  /// Returns a Future containing either a Failure or an AllowNotificationResponseModel.
  Future<Either<Failure, AllowNotificationResponseModel>> call(
      AllowNotificationRequestPayload request) async {
    return await _authRepository.allowNotification(Request(request));
  }
}
