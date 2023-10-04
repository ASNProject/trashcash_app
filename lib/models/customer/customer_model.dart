import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trashcash_app/models/status/status_model.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@Freezed()
class CustomerModel with _$CustomerModel {
  factory CustomerModel({
    @JsonKey(name: "id_user") String? idUser,
    String? name,
    String? password,
    String? address,
    @JsonKey(name: "id_number") String? idNumber,
    String? registration,
    @JsonKey(name: "id_status") String? idStatus,
    StatusModel? status,
}) = _CustomerModel;
  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);
}
