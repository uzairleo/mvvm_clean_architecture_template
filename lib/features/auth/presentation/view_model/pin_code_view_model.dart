/// ViewModel for managing the PIN code creation and confirmation process in the Zarpay application.
///
/// This class handles the state and logic for creating and confirming a PIN code, including
/// interacting with a custom numeric keyboard, local storage, and biometric authentication.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zarpay/app/widgets/custom_numeric_keyboard/custom_numeric_keyboard.dart';
import 'package:zarpay/app/bottomsheets/pin_code_success_bottom_sheet.dart';
import 'package:zarpay/app/core/localStorage/local_storage_service.dart';
import 'package:zarpay/app/core/utilities/custom_keyboard_focus_node.dart';
import 'package:zarpay/app/features/auth/presentation/views/confirm_pin_code_screen.dart';
import 'package:zarpay/app/features/auth/presentation/views/enable_faceid_screen.dart';
import 'package:zarpay/app/features/auth/presentation/views/enable_notifications_screen.dart';
import 'package:zarpay/injection_container.dart';
import 'package:zarpay/app/widgets/custom_numeric_keyboard/viewModel/custom_numeric_keyboard_view_model.dart';

/// The PinCodeViewModel class extends GetxController to manage the state and logic for the PIN code process.
class PinCodeViewModel extends GetxController {
  /// Observable boolean to track the loading state.
  RxBool isLoading = false.obs;

  /// Controller for the PIN code text field in the create PIN code screen.
  late TextEditingController pinCodeEditingCtrlr;

  /// Controller for the PIN code text field in the confirm PIN code screen.
  late TextEditingController pinCodeEditingCtrlr2;

  /// Form key for the create PIN code screen.
  final GlobalKey<FormState> createPinCodeScreenFormkey =
      GlobalKey<FormState>();

  /// Form key for the confirm PIN code screen.
  final GlobalKey<FormState> confirmPinCodeScreenFormkey =
      GlobalKey<FormState>();

  /// Focus node for the custom keyboard in the create PIN code screen.
  CustomKeyboardFocusNode createPinCodeFocusNode = CustomKeyboardFocusNode();

  /// Focus node for the custom keyboard in the confirm PIN code screen.
  CustomKeyboardFocusNode confirmPinCodeFocusNode = CustomKeyboardFocusNode();

  /// Service for local storage operations.
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  /// String to store any PIN code error messages.
  String pinCodeError = "";

  /// Instance of LocalAuthentication for biometric authentication.
  final LocalAuthentication auth = LocalAuthentication();

  /// Stream subscription to listen for input changes in the custom numeric keyboard.
  StreamSubscription<String>? _inputSubscription;

  /// Flag to suppress the input listener.
  bool _suppressInputListener = false;

  @override
  void onInit() {
    super.onInit();
    pinCodeEditingCtrlr = TextEditingController();
    pinCodeEditingCtrlr2 = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == '/CreatePinCodeScreen') {
        createPinCodeFocusNode.requestFocus();
      } else if (Get.currentRoute == '/ConfirmPinCodeScreen') {
        confirmPinCodeFocusNode.requestFocus();
      }
      showCustomNumericKeyboard();
    });

    // Listen to changes in the custom keyboard input
    _inputSubscription =
        Get.find<CustomNumericKeyboardViewModel>().input.listen((value) {
      if (_suppressInputListener) return; // Suppress listener if flag is set

      if (Get.currentRoute == '/CreatePinCodeScreen') {
        pinCodeEditingCtrlr.text = value;
      } else if (Get.currentRoute == '/ConfirmPinCodeScreen') {
        pinCodeEditingCtrlr2.text = value;
      }
    });
  }

  @override
  void onClose() {
    _inputSubscription?.cancel(); // Cancel the subscription
    super.onClose();
  }

  /// Handles the submission of the PIN code in the create PIN code screen.
  ///
  /// [isFromSetting] Boolean indicating if the request is from the settings screen.
  Future<void> onSubmitted(bool isFromSetting) async {
    isLoading(true);
    if (createPinCodeScreenFormkey.currentState!.validate()) {
      // Clear the input of the custom keyboard
      _suppressInputListener = true; // Set flag to suppress listener
      Get.find<CustomNumericKeyboardViewModel>().clearInput();
      _suppressInputListener = false; // Reset flag
      pinCodeEditingCtrlr2.clear(); // Clear the text editing controller
      confirmPinCodeFocusNode.requestFocus();

      Get.to(
        ConfirmPinCodeScreen(isFromSetting: isFromSetting),
        transition: Transition.rightToLeft,
      );
    }
    isLoading(false);
  }

  /// Handles the submission of the PIN code in the confirm PIN code screen.
  ///
  /// [context] The build context.
  /// [isFromSetting] Boolean indicating if the request is from the settings screen.
  Future<void> onConfirmSubmitted(
      BuildContext context, bool isFromSetting) async {
    isLoading(true);
    if (confirmPinCodeScreenFormkey.currentState!.validate()) {
      confirmPinCodeScreenFormkey.currentState!.save();

      var userToBeUpdated = _localStorageService.getLastLoginUser();
      userToBeUpdated!.pincode = pinCodeEditingCtrlr2.text;
      userToBeUpdated.lastUpdatedAt = DateTime.now().toIso8601String();
      _localStorageService.updateUser(userToBeUpdated);
      clearInputAndCancelSubscription();

      if (!isFromSetting) {
        Future.delayed(const Duration(milliseconds: 100), () async {
          if (await checkFaceIDSupport()) {
            Get.to(() => const EnableFaceIdScreen(),
                transition: Transition.rightToLeft);
          } else {
            Get.to(() => const EnableNotificationScreen(),
                transition: Transition.rightToLeft);
          }
        });
      } else {
        showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (context) => PincodeSuccessBottomSheet(
            onPressed: () {
              Get.back(); // Navigate back multiple times to exit the flow
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              Get.back();
            },
          ),
        );
      }
    }
    isLoading(false);
  }

  /// Clears the input of the custom keyboard and cancels the input subscription.
  void clearInputAndCancelSubscription() {
    // Clearing input only for pinCodeEditingCtrlr2
    _suppressInputListener = true; // Set flag to suppress listener
    Get.find<CustomNumericKeyboardViewModel>().clearInput();
    _suppressInputListener = false; // Reset flag
    pinCodeEditingCtrlr2.clear();
    _inputSubscription?.cancel();
  }

  /// Checks if Face ID is supported on the device.
  ///
  /// Returns a Future<bool> indicating whether Face ID is supported.
  Future<bool> checkFaceIDSupport() async {
    try {
      bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();
        return availableBiometrics.contains(BiometricType.face);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Resets the text controllers and focus nodes.
  void resetControllers() {
    pinCodeEditingCtrlr2 = TextEditingController();
    confirmPinCodeFocusNode = CustomKeyboardFocusNode();
  }
}
