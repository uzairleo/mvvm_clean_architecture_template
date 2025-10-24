/// Abstract class for handling exceptions.
///
/// This class provides a method to handle exceptions that occur in the application.
/// Implementations of this class should define how to handle different types of [Failure].

import 'package:zarpay/app/core/error/failure.dart';

abstract class ExceptionHandlerServices {
  /// Handles the given [failure].
  ///
  /// This method should implement logic to handle the provided [Failure] instance.
  void handleException(Failure failure);
}
