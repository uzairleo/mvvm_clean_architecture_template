/// Custom exceptions for various types of errors in the application.
///
/// This file defines custom exception classes for handling HTTP-related errors,
/// server errors, cache errors, and URL launcher errors. Each class provides
/// additional fields and methods to represent specific error conditions and messages.

import 'dart:io';

///
/// This class extends [IOException] and provides additional fields for error code,
/// message, and API-specific code.
class HttpCustomException implements IOException {
  final int? code;
  final String? message;
  final String? apiCode;

  /// Creates an instance of [HttpCustomException] with the given [code], [message], and [apiCode].
  HttpCustomException({this.code, this.message, this.apiCode = ''});

  @override
  String toString() {
    var b = StringBuffer()..write(message);
    return b.toString();
  }
}

/// Exception for bad HTTP requests.
///
/// This class extends [HttpException] and represents an invalid HTTP request.
class BadRequestException extends HttpException {
  /// Creates an instance of [BadRequestException] with the given [message].
  BadRequestException({String message = 'The request is invalid.'})
      : super(message);

  @override
  String toString() {
    var b = StringBuffer()
      ..write('BadRequestException: ')
      ..write(message);
    return b.toString();
  }
}

/// Exception for unauthorized access.
///
/// This class extends [HttpException] and represents an unauthorized access attempt.
class UnauthorizedAccessException extends HttpException {
  /// Creates an instance of [UnauthorizedAccessException] with the given [message].
  UnauthorizedAccessException(
      {String message = 'User not allowed to perform this operation'})
      : super(message);

  @override
  String toString() {
    var b = StringBuffer()
      ..write('UnauthorizedAccessException: ')
      ..write(message);
    return b.toString();
  }
}

/// Exception for resource not found.
///
/// This class extends [HttpException] and represents a missing resource error.
class ResourceNotFoundException extends HttpException {
  /// Creates an instance of [ResourceNotFoundException] with the given [message].
  ResourceNotFoundException({String message = ''}) : super(message);

  @override
  String toString() {
    var b = StringBuffer()
      ..write('ResourceNotFoundException: ')
      ..write(message);
    return b.toString();
  }
}

/// Exception for server-related errors.
class ServerException {
  final String code;
  final List<String> messages;

  /// Creates an instance of [ServerException] with the given [code] and [messages].
  ServerException(this.code, this.messages);
}

/// Exception for cache-related errors.
class CacheException {
  final String code;
  final List<String> messages;

  /// Creates an instance of [CacheException] with the given [code] and [messages].
  CacheException(this.code, this.messages);
}

/// Exception for URL launcher-related errors.
class UrlLauncherException {
  final String code;
  final List<String> messages;

  /// Creates an instance of [UrlLauncherException] with the given [code] and [messages].
  UrlLauncherException(this.code, this.messages);
}
