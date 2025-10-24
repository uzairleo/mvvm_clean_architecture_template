/// This class Defines Implementation of [ExceptionHandlerServices].
///
/// This class handles exceptions by displaying an error dialog and, in certain cases,
/// clearing the current user token from local storage.

import 'package:get/get.dart';
import 'package:zarpay/app/core/Exception/exception_handler_services.dart';
import 'package:zarpay/app/core/error/dialog/error_dialog.dart';
import 'package:zarpay/app/core/error/failure.dart';
import 'package:zarpay/app/core/localStorage/local_storage_service.dart';

class ExceptionHandlerImpl implements ExceptionHandlerServices {
  final LocalStorageService _localStorageService;

  /// Creates an instance of [ExceptionHandlerImpl] with the given [localStorageService].
  ExceptionHandlerImpl(this._localStorageService);

  @override
  void handleException(Failure f) {
    Get.back();
    if (f.code == "403") {
      _localStorageService.clearCurrentUserToken();
    }
    Get.dialog(ErrorDialog(title: "Error ${f.code}", message: f.messages.first),
        barrierDismissible: false);
  }
}
