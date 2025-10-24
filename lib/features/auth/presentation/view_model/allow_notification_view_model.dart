/// ViewModel for managing the notification permission process in the Zarpay application.
///
/// This class handles the state and logic for requesting notification permissions,
/// sending the permission status to the backend, and navigating to the next screen based on the result.

import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:zarpay/app/core/Exception/exception_handler_services.dart';
import 'package:zarpay/app/core/notifications/notification_service.dart';
import 'package:zarpay/app/features/auth/data/models/request/allow_notification_request_model.dart';
import 'package:zarpay/app/features/auth/domain/usecase/allow_notification.dart';
import 'package:zarpay/app/features/waitlist/presentation/views/waitlist_screen.dart';
import 'package:zarpay/injection_container.dart';

/// The AllowNotificationViewModel class extends GetxController to manage the state and logic for notification permissions.
class AllowNotificationViewModel extends GetxController {
  /// Observable boolean to track the loading state.
  RxBool isLoading = false.obs;

  /// Service for managing notifications.
  final NotificationService _notificationService =
      locator<NotificationService>();

  /// UseCase for allowing notifications.
  final AllowNotificationUseCase _allowNotificationUseCase =
      locator<AllowNotificationUseCase>();

  /// Service for handling exceptions.
  final ExceptionHandlerServices exceptionService =
      locator<ExceptionHandlerServices>();

  /// Handles the process when the "Allow Notification" button is pressed.
  ///
  /// Requests notification permissions and sends the permission status to the backend.
  /// Navigates to the next screen based on the result.
  Future<void> onAllowNotificationPressed() async {
    AllowNotificationRequestPayload payload =
        const AllowNotificationRequestPayload(isAllowedNotification: false);

    NotificationSettings settings =
        await _notificationService.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Handling granted notification permission in backend
      payload =
          const AllowNotificationRequestPayload(isAllowedNotification: true);
    }

    isLoading(true);
    final response = await _allowNotificationUseCase(payload);
    isLoading(false);

    response.fold((failure) {
      log("Failure: ${failure.code}");
      exceptionService.handleException(failure);
    }, (notificationResponse) {
      log("Success: ${notificationResponse.toJson()}");
      Get.offAll(() => const WaitlistScreen(),
          transition: Transition.rightToLeft);
    });
  }
}
