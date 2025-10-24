/// ViewModel for managing the required PIN code entry process in the Zarpay application.
///
/// This class handles the state and logic for validating and submitting the required PIN code,
/// interacting with a custom numeric keyboard, checking Face ID support, and displaying error messages.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zarpay/app/widgets/custom_numeric_keyboard/custom_numeric_keyboard.dart';
import 'package:zarpay/app/bottomsheets/incorrect_pin_bottom_sheet.dart';
import 'package:zarpay/app/core/localStorage/local_storage_service.dart';
import 'package:zarpay/app/core/utilities/custom_keyboard_focus_node.dart';
import 'package:zarpay/app/features/auth/presentation/views/create_pin_code_screen.dart';
import 'package:zarpay/app/features/auth/presentation/views/enable_faceid_screen.dart';
import 'package:zarpay/app/features/waitlist/presentation/views/waitlist_screen.dart';
import 'package:zarpay/injection_container.dart';
import 'package:zarpay/app/widgets/custom_numeric_keyboard/viewModel/custom_numeric_keyboard_view_model.dart';

/// The RequiredPinCodeViewModel class extends GetxController to manage the state and logic for the required PIN code process.
class RequiredPinCodeViewModel extends GetxController {
  /// Observable boolean to track the loading state.
  RxBool isLoading = false.obs;

  /// Controller for the PIN code text field.
  TextEditingController pinCodeEditingController = TextEditingController();

  /// Form key for the required PIN code form.
  var requiredPinCodeFormKey = GlobalKey<FormState>();

  /// Focus node for the custom keyboard in the required PIN code screen.
  CustomKeyboardFocusNode requiredPinCodeFocusNode = CustomKeyboardFocusNode();

  /// Service for local storage operations.
  final localStorageService = locator<LocalStorageService>();

  /// Observable string to store any PIN code error messages.
  RxString pinCodeError = "".obs;

  /// Instance of LocalAuthentication for biometric authentication.
  final LocalAuthentication auth = LocalAuthentication();

  /// Flag to indicate if the incorrect PIN bottom sheet is displayed.
  bool _isBottomSheetDisplayed = false;

  /// Stream subscription to listen for input changes in the custom numeric keyboard.
  StreamSubscription<String>? _inputSubscription;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requiredPinCodeFocusNode.requestFocus();
      showCustomNumericKeyboard();
    });

    // Listen to changes in the custom keyboard input
    _inputSubscription =
        Get.find<CustomNumericKeyboardViewModel>().input.listen((value) {
      pinCodeEditingController.text = value;
    });
  }

  @override
  void onClose() {
    _inputSubscription?.cancel(); // Cancel the subscription
    super.onClose();
  }

  /// Handles the submission of the PIN code.
  ///
  /// [isFromSetting] Boolean indicating if the request is from the settings screen.
  void _onConfirmSubmitted({isFromSetting = false}) async {
    isLoading(true);
    if (requiredPinCodeFormKey.currentState!.validate()) {
      requiredPinCodeFormKey.currentState!.save();

      clearInputAndCancelSubscription(); // Clear input and cancel subscription

      if (!isFromSetting) {
        Future.delayed(const Duration(milliseconds: 100), () async {
          if (await checkFaceIDSupport()) {
            Get.to(() => const EnableFaceIdScreen(),
                transition: Transition.rightToLeft);
          } else {
            Get.offAll(const WaitlistScreen(),
                transition: Transition.rightToLeft);
          }
        });
      } else {
        Get.to(
          CreatePinCodeScreen(isFromSetting: isFromSetting),
          transition: Transition.rightToLeft,
        );
      }
    }
    isLoading(false);
  }

  /// Clears the input of the custom keyboard and cancels the input subscription.
  void clearInputAndCancelSubscription() {
    Get.find<CustomNumericKeyboardViewModel>().clearInput();
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

  /// Validates and submits the entered PIN code.
  ///
  /// [value] The entered PIN code.
  /// [isFromSetting] Boolean indicating if the request is from the settings screen.
  void validateAndSubmitPinCode(String value, bool isFromSetting) {
    if (value.length < 6) {
      pinCodeError.value = "";
    } else if (pinCodeEditingController.text !=
        localStorageService.getLastLoginUser()!.pincode) {
      _handleIncorrectPin();
    } else {
      pinCodeError.value = "";
      _onConfirmSubmitted(isFromSetting: isFromSetting);
    }
  }

  /// Handles the incorrect PIN code entry by displaying a bottom sheet.
  void _handleIncorrectPin() {
    if (!_isBottomSheetDisplayed) {
      _isBottomSheetDisplayed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showIncorrectPincodeBottomSheet();
      });
    }
  }

  /// Displays a bottom sheet for incorrect PIN code entry.
  void showIncorrectPincodeBottomSheet() {
    Get.bottomSheet(
      isDismissible: false,
      IncorrectPincodeBottomSheet(
        onPressed: () {
          Get.find<CustomNumericKeyboardViewModel>().clearInput();
          Get.back();
          _isBottomSheetDisplayed = false;
          // Request focus on the pin code field after the bottom sheet is dismissed
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pinCodeEditingController.clear();
            requiredPinCodeFocusNode.requestFocus();
          });
        },
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      _isBottomSheetDisplayed = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        requiredPinCodeFocusNode.requestFocus();
      });
    });
  }

  /// Resets the text controllers and focus nodes.
  void resetControllers() {
    pinCodeEditingController = TextEditingController();
    requiredPinCodeFocusNode = CustomKeyboardFocusNode();
  }
}
