import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_model.freezed.dart';
part 'status_model.g.dart';

@Freezed()
class StatusModel with _$StatusModel {
  factory StatusModel({
    @JsonKey(name: "id_status") int? idStatus,
    String? status,
}) = _StatusModel;

  factory StatusModel.fromJson(Map<String, dynamic> json) => _$StatusModelFromJson(json);
}
