/// ViewModel for the authentication process in the Zarpay application.
///
/// This class manages the state and logic for various authentication-related
/// tasks, such as sending OTP, verifying OTP, handling country code changes,
/// and managing the OTP countdown timer.

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:zarpay/app/core/Exception/exception_handler_services.dart';
import 'package:zarpay/app/core/localStorage/local_storage_service.dart';
import 'package:zarpay/app/core/notifications/notification_service.dart';
import 'package:zarpay/app/features/auth/data/models/device.dart';
import 'package:zarpay/app/features/auth/domain/entity/user.dart';
import 'package:zarpay/app/features/auth/data/models/request/send_otp_request_model.dart';
import 'package:zarpay/app/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:zarpay/app/features/auth/domain/repository/device_repository.dart';
import 'package:zarpay/app/features/auth/domain/usecase/send_otp.dart';
import 'package:zarpay/app/features/auth/domain/usecase/verification.dart';
import 'package:zarpay/app/features/auth/presentation/views/create_pin_code_screen.dart';
import 'package:zarpay/app/features/auth/presentation/views/verify_otp_screen.dart';
import 'package:zarpay/app/features/auth/presentation/widgets/verification_succes_bottomsheet.dart';
import 'package:zarpay/app/features/auth/data/models/country.dart';
import 'package:zarpay/app/features/waitlist/domain/usecase/fetch_registrant.dart';
import 'package:zarpay/app/features/waitlist/presentation/views/waitlist_screen.dart';
import 'package:zarpay/injection_container.dart';

/// The AuthViewModel class extends GetxController to manage the state and logic for the authentication process.
class AuthViewModel extends GetxController {
  /// Observable boolean to track the loading state.
  RxBool isLoading = false.obs;

  /// Form key for the create account screen.
  final GlobalKey<FormState> createAccountScreenformkey =
      GlobalKey<FormState>();

  /// Form key for the OTP screen.
  final GlobalKey<FormState> otpScreenFormKey = GlobalKey<FormState>();

  /// Country code for the phone number.
  String countryCode = '92';

  /// Controller for the phone number text field.
  final TextEditingController phoneNumberCtlr = TextEditingController();

  /// Controller for the OTP text field.
  final TextEditingController otptextController = TextEditingController();

  /// Usecase for sending OTP.
  SendOtpUsecase sendOtpUsecase = locator<SendOtpUsecase>();

  /// Usecase for verifying OTP.
  VerificationUseCase verificationUseCase = locator<VerificationUseCase>();

  /// Usecase for fetching registrant data.
  final FetchRegistrantUsecase _fetchRegistrantUsecase =
      locator<FetchRegistrantUsecase>();

  /// Service for local storage operations.
  final LocalStorageService localStorageService =
      locator<LocalStorageService>();

  /// Service for handling exceptions.
  final ExceptionHandlerServices _exceptionHandler =
      locator<ExceptionHandlerServices>();

  /// Notification service instance.
  final NotificationService _notificationService =
      locator<NotificationService>();

  /// Repository for device information.
  final DeviceRepository _deviceRepository = locator<DeviceRepository>();

  /// Referral code, can be null.
  String? referralCode;

  /// Constants for the OTP countdown timer.
  static const int countdownDuration = 15;
  // ignore: unused_field
  late Timer _timer;

  /// Observable integer to track the seconds remaining in the OTP countdown.
  RxInt secondsRemaining = countdownDuration.obs;

  /// Observable boolean to indicate if the countdown has finished.
  RxBool isCountdownFinished = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the referralCode argument, it can be null
    referralCode = Get.arguments as String?;
    countryCode = getCountry.dialCode;
  }

  /// Starts the OTP countdown timer.
  void startCountdown() {
    isCountdownFinished.value = false;
    secondsRemaining.value = countdownDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      isCountdownFinished.value = false;
      if (secondsRemaining.value <= 0) {
        timer.cancel();
        isCountdownFinished.value = true;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  /// Handles the logic for sending OTP.
  ///
  /// Validates the form and sends the OTP request if the form is valid.
  Future<void> onSendOtpPressed() async {
    isLoading(true);

    if (createAccountScreenformkey.currentState!.validate()) {
      createAccountScreenformkey.currentState!.save();

      final response = await sendOtpUsecase(SendOtpRequestPayload(
        phoneNumber: phoneNumberCtlr.text,
        countryCode: countryCode,
        referrerCode: referralCode,
      ));

      response.fold((failure) {
        log("Failure: ${failure.code}");
        _exceptionHandler.handleException(failure);
      }, (signupResponse) {
        log("Success: ${signupResponse.toJson()}");
        startCountdown();
        Get.offAll(() => const VerifyOtpScreen());
      });
    }
    isLoading(false);
  }

  /// Handles the logic for resending OTP.
  ///
  /// Sends the OTP request again.
  Future<void> resendOtpPressed() async {
    isLoading(true);

    final response = await sendOtpUsecase(SendOtpRequestPayload(
      phoneNumber: phoneNumberCtlr.text,
      countryCode: countryCode,
      referrerCode: referralCode,
    ));

    response.fold((failure) {
      log("Failure: ${failure.code}");
      _exceptionHandler.handleException(failure);
    }, (signupResponse) {
      log("Success: ${signupResponse.toJson()}");
      startCountdown();
    });
    isLoading(false);
  }

  /// Handles the logic for verifying the OTP.
  ///
  /// Validates the form and sends the verification request if the form is valid.
  Future<void> onVerificationPressed(BuildContext context) async {
    isLoading(true);
    if (otpScreenFormKey.currentState!.validate()) {
      otpScreenFormKey.currentState!.save();
      Device deviceInfo = await _deviceRepository.getDeviceInformation();
      final response = await verificationUseCase(VerifyOtpRequestPayload(
        phoneNumber: phoneNumberCtlr.text,
        countryCode: countryCode,
        verificationCode: otptextController.text,
        device: Device(
          pushId: _notificationService.pushId,
          deviceId: deviceInfo.deviceId,
          deviceModel: deviceInfo.deviceModel,
          platformType: deviceInfo.platformType,
        ),
      ));

      response.fold((failure) {
        log("Failure: ${failure.code}");
        _exceptionHandler.handleException(failure);
      }, (verifyOtpResponse) async {
        log("Success: ${verifyOtpResponse.toJson()}");
        // Calling registrant data for uid
        await fetchRegistrant();
        showModalBottomSheet(
          // ignore: use_build_context_synchronously
          context: context,
          isDismissible: false,
          builder: (BuildContext buildContext) {
            var phonenumber = countryCode + phoneNumberCtlr.text;
            return VerificationSuccessBottomSheet(
              onPressed: () {
                Get.back();
                var localUser =
                    localStorageService.getUser(phonenumber) ?? User();

                if (localUser.pincode?.isNotEmpty ?? false) {
                  Get.offAll(() => const WaitlistScreen(),
                      transition: Transition.rightToLeft);
                } else {
                  Get.offAll(() => const CreatePinCodeScreen(),
                      transition: Transition.rightToLeft);
                }
              },
            );
          },
        );
      });
    }
    isLoading(false);
  }

  /// Fetches the registrant data and updates the local storage.
  Future<void> fetchRegistrant() async {
    isLoading(true);
    final result = await _fetchRegistrantUsecase();
    result.fold(
      (failure) => _exceptionHandler.handleException(failure),
      (data) {
        var user = localStorageService.getLastLoginUser() ?? User();
        user.id = data.id;
        user.lastUpdatedAt = DateTime.now().toIso8601String();
        localStorageService.updateUser(user);
      },
    );
    isLoading(false);
  }

  /// Retrieves the country model from the local storage.
  CountryModel get getCountry {
    return CountryModel.fromJson(localStorageService.getCountry());
  }

  /// Handles the logic when the country is changed in the phone field.
  ///
  /// [country] The selected country.
  void onCountryChanged(Country country) {
    countryCode = country.dialCode;
    CountryModel countryEntity = CountryModel(country.dialCode, country.code);
    localStorageService.setCountry(countryEntity.toJson());
  }

  @override
  void onClose() {
    // Cancels the timer when the controller is closed.
    // _timer.cancel();
    super.onClose();
  }
}
