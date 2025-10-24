/// This file defines the AuthLocalDatasource abstract class and its implementation,
/// which provides methods for local data storage related to authentication in the Zarpay application.

import 'package:zarpay/app/core/Exception/exception.dart';
import 'package:zarpay/app/core/localStorage/local_storage_service.dart';
import 'package:zarpay/app/features/auth/domain/entity/user.dart';
import 'package:zarpay/app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/response/verify_otp_response_model.dart';

/// The AuthLocalDatasource abstract class provides an interface for local data storage related to authentication.
abstract class AuthLocalDatasource {
  /// Saves the ID token and updates user information in local storage.
  ///
  /// [request] The OTP verification request payload.
  /// [response] The OTP verification response model.
  /// Returns a Future containing a boolean indicating the success of the operation.
  Future<bool> saveIdToken(
      VerifyOtpRequestPayload request, VerifyOtpResponseModel response);
}

/// The AuthLocalDatasourceImpl class implements the AuthLocalDatasource interface.
///
/// This class provides a concrete implementation for saving the ID token and updating user information
/// in local storage by interacting with the LocalStorageService.
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final LocalStorageService localStorageService;

  /// Constructor for the AuthLocalDatasourceImpl class.
  ///
  /// [localStorageService] The service used for local data storage operations.
  AuthLocalDatasourceImpl(this.localStorageService);

  /// Saves the ID token and updates user information in local storage.
  ///
  /// [request] The OTP verification request payload.
  /// [response] The OTP verification response model.
  /// Returns a Future containing a boolean indicating the success of the operation.
  /// Throws a CacheException if there is an error in local storage.
  @override
  Future<bool> saveIdToken(
      VerifyOtpRequestPayload request, VerifyOtpResponseModel response) async {
    try {
      User user = localStorageService.getLastLoginUser() ?? User();
      user.idToken = response.idToken;
      user.phoneNumber = request.countryCode + request.phoneNumber;

      // If the user is new, clear certain fields
      if (!localStorageService
          .getAllUsers()
          .contains(User(phoneNumber: user.phoneNumber))) {
        user.pincode = "";
        user.isContactSynced = false;
        user.isXFollowed = false;
        user.isFacebookFollowed = false;
        user.isInstagramFollowed = false;
        user.isDiscordJoined = false;
        user.seenStories = {for (var name in potentialStoryIds) name: false};
      } else {
        // Get the existing user by phone number
        User getUser = localStorageService.getUser(user.phoneNumber!)!;
        user.pincode = getUser.pincode;
        user.isContactSynced = getUser.isContactSynced;
        user.isXFollowed = getUser.isXFollowed;
        user.isFacebookFollowed = getUser.isFacebookFollowed;
        user.isInstagramFollowed = getUser.isInstagramFollowed;
        user.isDiscordJoined = getUser.isDiscordJoined;
        user.seenStories = getUser.seenStories;
      }

      user.lastUpdatedAt = DateTime.now().toIso8601String();
      await localStorageService.saveUser(user);
      return true;
    } on Exception {
      throw CacheException("500", ["Error in local storage"]);
    }
  }
}
