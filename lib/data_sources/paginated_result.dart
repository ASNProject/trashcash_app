import 'package:freezed_annotation/freezed_annotation.dart';

/// Base class for paginated result.
class PaginatedResult<T> {
  /// Total data.
  @JsonKey(name: 'total_data')
  int? totalData;

  /// Current page starting from 1.
  @JsonKey(name: 'current_page')
  int? currentPage;

  /// Number of data per page.
  @JsonKey(name: 'per_page')
  int? perPage;

  /// Total pages.
  @JsonKey(name: 'total_pages')
  int? totalPages;

  /// The paginated data.
  @JsonKey(name: 'data')
  List<T>? data;

  PaginatedResult({
    this.totalData,
    this.currentPage,
    this.perPage,
    this.totalPages,
    this.data,
  });
}
