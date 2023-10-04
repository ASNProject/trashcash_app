import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;
  int? statusCode;
  StackTrace? stackTrace;

  DioExceptions(this.message, [statusCode, stackTrace]);

  DioExceptions.fromDioError(DioError dioError, [this.stackTrace]) {
    statusCode = dioError.response?.statusCode;

    switch (dioError.type) {
      case DioErrorType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioErrorType.connectionTimeout:
        message = 'Connection timeout with API server';
        break;
      case DioErrorType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;
      case DioErrorType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;
      case DioErrorType.connectionError:
        if (dioError.message!.contains('SocketException')) {
          message = 'No Internet';
          break;
        }
        message = 'Unexpected error occurred';
        break;
      default:
        message = 'Something went wrong';
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request | ${error['message']}';
      case 401:
        return 'Unauthorized | ${error['message']}';
      case 403:
        return 'Forbidden | ${error['message']}';
      case 404:
        return 'Not found | ${error['message']}';
      case 500:
        return 'Internal server error | ${error['message']}';
      case 502:
        return 'Bad gateway | ${error['message']}';
      default:
        return 'Oops something went wrong | ${error['message']}';
    }
  }

  @override
  String toString() => message;

  String get errorMessage {
    final split = message.split(' | ');
    if (split.length > 1) {
      return split.last;
    }
    return message;
  }
}
