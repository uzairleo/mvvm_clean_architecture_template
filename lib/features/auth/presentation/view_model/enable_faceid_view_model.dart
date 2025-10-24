/// ViewModel for enabling Face ID authentication in the Zarpay application.
///
/// This class manages the state and logic for authenticating with Face ID, including
/// checking if Face ID is available on the device, performing the authentication,
/// and handling the success or failure of the authentication process.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zarpay/app/bottomsheets/face_id_success_bottom_sheet.dart';
import 'package:zarpay/app/core/error/dialog/error_dialog.dart';
import 'package:zarpay/app/features/auth/presentation/views/enable_notifications_screen.dart';

/// The EnableFaceIdViewModel class extends GetxController to manage the state and logic for Face ID authentication.
class EnableFaceIdViewModel extends GetxController {
  /// Observable boolean to track the loading state.
  RxBool isLoading = false.obs;

  /// Instance of LocalAuthentication for biometric authentication.
  final LocalAuthentication auth = LocalAuthentication();

  /// Observable boolean to track the authentication state.
  RxBool isAuthenticated = false.obs;

  /// Authenticates the user with Face ID.
  ///
  /// [context] The build context.
  /// [isFromProfileSettings] Boolean indicating if the request is from the profile settings.
  Future<void> authenticateWithFaceID(context,
      {isFromProfileSettings = false}) async {
    bool canAuthenticateWithFaceID = await auth.canCheckBiometrics;
    if (!canAuthenticateWithFaceID) {
      const ErrorDialog(
        title: 'Error',
        message: 'Face ID not available on this device',
      );
      return;
    }

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to move forward',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      isAuthenticated.value = authenticated;

      if (authenticated) {
        if (isFromProfileSettings) {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            clipBehavior: Clip.hardEdge,
            isDismissible: false,
            context: context,
            builder: (context) => FaceIDSuccessBottomSheet(
              onPressed: () {
                Get.back();
                Get.back();
              },
            ),
          );
        } else {
          Get.to(() => const EnableNotificationScreen(),
              transition: Transition.rightToLeft);
        }
      } else {
        const ErrorDialog(title: 'Failed', message: 'Authentication Failed');
      }
    } catch (e) {
      const ErrorDialog(title: 'Error', message: 'Authentication Failed');
      showLoading(false);
    }
  }

  /// Shows or hides the loading indicator.
  ///
  /// [value] Boolean indicating whether to show or hide the loading indicator.
  void showLoading(value) {
    isLoading.value = value;
    update();
  }
}
