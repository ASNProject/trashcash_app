import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'dio_exceptions.dart';

class BaseRemote {
  Dio dio;

  String hostName;

  String apiBaseUrl;

  BaseRemote({
    required this.dio,
    required this.hostName,
    required this.apiBaseUrl,
});

  /// Get Endpoint
  @protected
  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
        void Function(int, int)? onReceiveProgress,
      }) async {
    late Response<T> response;
    try {
      response = await dio.get(
        _getUrl(path),
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.data is List<int>) {
        // do nothing as result is List<int>
        // example of this result is csv
      } else if ((response.data as Map<String, dynamic>)['success'] != true) {
        final message = (response.data as Map<String, dynamic>)['message'];
        if (message != null) {
          throw DioExceptions(message, response.statusCode);
        } else {
          throw DioExceptions(
            'Oops something went wrong!',
            response.statusCode,
          );
        }
      }
    } on DioError catch (err, stack) {
      throw DioExceptions.fromDioError(err, stack);
    } catch (err) {
      rethrow;
    }

    return response;
  }

  /// Post Endpoint
  @protected
  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
        CancelToken? cancelToken,
        void Function(int, int)? onSendProgress,
        void Function(int, int)? onReceiveProgress,
      }) async {
    late Response<T> response;
    try {
      response = await dio.post(
        _getUrl(path),
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

      if ((response.data as Map<String, dynamic>)['success'] != true) {
        final message = (response.data as Map<String, dynamic>)['message'];
        if (message != null) {
          throw DioExceptions(message, response.statusCode);
        } else {
          throw DioExceptions(
            'Oops something went wrong!',
            response.statusCode,
          );
        }
      }
    } on DioError catch (err, stack) {
      throw DioExceptions.fromDioError(err, stack);
    } catch (err) {
      rethrow;
    }

    return response;
  }

  /// Put Endpoint
  @protected
  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
      }) async {
    late Response<T> response;
    try {
      response = await dio.put(
        _getUrl(path),
        data: data,
        queryParameters: queryParams,
        options: options,
      );

      if ((response.data as Map<String, dynamic>)['success'] != true) {
        final message = (response.data as Map<String, dynamic>)['message'];
        if (message != null) {
          throw DioExceptions(message, response.statusCode);
        } else {
          throw DioExceptions(
            'Oops something went wrong!',
            response.statusCode,
          );
        }
      }
    } on DioError catch (err, stack) {
      throw DioExceptions.fromDioError(err, stack);
    } catch (err) {
      rethrow;
    }

    return response;
  }

  /// Patch endpoint
  Future<Response<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
      }) async {
    late Response<T> response;
    try {
      response = await dio.patch(
        _getUrl(path),
        data: data,
        queryParameters: queryParams,
        options: options,
      );

      if ((response.data as Map<String, dynamic>)['success'] != true) {
        final message = (response.data as Map<String, dynamic>)['message'];
        if (message != null) {
          throw DioExceptions(message, response.statusCode);
        } else {
          throw DioExceptions(
            'Oops something went wrong!',
            response.statusCode,
          );
        }
      }
    } on DioError catch (err, stack) {
      throw DioExceptions.fromDioError(err, stack);
    } catch (err) {
      rethrow;
    }

    return response;
  }

  /// Delete Endpoint
  @protected
  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
      }) async {
    late Response<T> response;
    try {
      response = await dio.delete(
        _getUrl(path),
        data: data,
        queryParameters: queryParams,
        options: options,
      );

      if ((response.data as Map<String, dynamic>)['success'] != true) {
        final message = (response.data as Map<String, dynamic>)['message'];
        if (message != null) {
          throw DioExceptions(message, response.statusCode);
        } else {
          throw DioExceptions(
            'Oops something went wrong!',
            response.statusCode,
          );
        }
      }
    } on DioError catch (err, stack) {
      throw DioExceptions.fromDioError(err, stack);
    } catch (err) {
      rethrow;
    }

    return response;
  }

  /// Generate endpoint url from provided `hostName`, `baseUrl` and `path`.
  ///
  /// e.g. https://elevarm.com/api/login
  @protected
  String _getUrl(String path) {
    return 'https://app-574b3b2b-05f4-4a14-a811-fd215c1e4fdf.cleverapps.io/$path';
  }
}
