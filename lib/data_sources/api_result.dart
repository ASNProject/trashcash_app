import 'package:trashcash_app/data_sources/paginated_result.dart';

import 'list_result.dart';

/// API result model.
class ApiResult<T> {
  /// Whether the request successful or not.
  final bool success;

  /// Error message if any.
  final String? message;

  /// The response payload if any.
  final T? result;

  /// Json key for retrieving [success].
  static const String jsonKeySuccess = 'success';

  /// Json key for retrieving [message].
  static const String jsonKeyMessage = 'message';

  /// Json key for retrieving [result].
  static const String jsonKeyResult = 'result';

  /// Json key for retrieving [PaginatedResult.totalData].
  static const String jsonKeyPaginatedTotalData = 'total_data';

  /// Json key for retrieving [PaginatedResult.currentPage].
  static const String jsonKeyPaginatedCurrentPage = 'current_page';

  /// Json key for retrieving [PaginatedResult.perPage].
  static const String jsonKeyPaginatedPerPage = 'per_page';

  /// Json key for retrieving [PaginatedResult.totalPages].
  static const String jsonKeyPaginatedTotalPages = 'total_pages';

  /// Json key for retrieving [PaginatedResult.data].
  static const String jsonKeyPaginatedData = 'data';

  const ApiResult._(this.success, this.message, this.result);

  /// Parse JSON map into generic [T] object.
  static ApiResult<T> fromResponse<T>(
      Map<String, dynamic> data,
      T Function(dynamic json) mapper,
      ) {
    return ApiResult._(
      data[jsonKeySuccess],
      data[jsonKeyMessage],
      mapper(data[jsonKeyResult]),
    );
  }

  /// Parse JSON map into [PaginatedResult] object.
  static ApiResult<PaginatedResult<T>> fromResponsePaginatedResult<T>(
      Map<String, dynamic> data,
      T Function(dynamic json) mapper,
      ) {
    return ApiResult._(
      data[jsonKeySuccess],
      data[jsonKeyMessage],
      PaginatedResult<T>(
        totalData: data[jsonKeyResult][jsonKeyPaginatedTotalData],
        currentPage: data[jsonKeyResult][jsonKeyPaginatedCurrentPage],
        perPage: data[jsonKeyResult][jsonKeyPaginatedPerPage],
        totalPages: data[jsonKeyResult][jsonKeyPaginatedTotalPages],
        data: (data[jsonKeyResult][jsonKeyPaginatedData] as List)
            .map(
              (item) => mapper(item),
        )
            .toList(),
      ),
    );
  }

  /// Parse JSON map into [ListResult] object.
  static ApiResult<ListResult<T>> fromResponseListResult<T>(
      Map<String, dynamic> data,
      T Function(dynamic json) mapper,
      ) {
    return ApiResult._(
      data[jsonKeySuccess],
      data[jsonKeyMessage],
      ListResult<T>(
        data: (data[jsonKeyResult][jsonKeyPaginatedData] as List)
            .map(
              (item) => mapper(item),
        )
            .toList(),
      ),
    );
  }
}
