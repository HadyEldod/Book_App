import 'dart:io';
import 'package:dio/dio.dart';

/// Abstract class to represent failures.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// Represents server-related failures.
class ServerFailure extends Failure {
  ServerFailure(super.message);

  /// Factory constructor to create a [ServerFailure] from a [DioException].
  factory ServerFailure.fromDioException(DioException dioException) {
    print('DioException occurred: ${dioException.type}'); // إضافة طباعة لتتبع الأخطاء

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with the server');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with the server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with the server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('Request to the server was canceled');
      case DioExceptionType.unknown:
        if (dioException.error is SocketException) {
          return ServerFailure('No internet connection');
        }
        return ServerFailure('Unexpected error, please try again!');
      default:
        return ServerFailure('An unknown error occurred, please try again');
    }
  }

  /// Factory constructor to create a [ServerFailure] from the response status code and data.
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == null || response == null) {
      return ServerFailure('Unknown error occurred, please try again');
    }

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return ServerFailure(response['error']?['message'] ?? 'Authentication error');
      case 404:
        return ServerFailure('The requested resource was not found, please try later');
      case 500:
        return ServerFailure('Internal server error, please try later');
      default:
        return ServerFailure('An error occurred, please try again');
    }
  }
}
