// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerModelImpl _$$CustomerModelImplFromJson(Map<String, dynamic> json) =>
    _$CustomerModelImpl(
      idUser: json['id_user'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      address: json['address'] as String?,
      idNumber: json['id_number'] as String?,
      registration: json['registration'] as String?,
      idStatus: json['id_status'] as String?,
      status: json['status'] == null
          ? null
          : StatusModel.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CustomerModelImplToJson(_$CustomerModelImpl instance) =>
    <String, dynamic>{
      'id_user': instance.idUser,
      'name': instance.name,
      'password': instance.password,
      'address': instance.address,
      'id_number': instance.idNumber,
      'registration': instance.registration,
      'id_status': instance.idStatus,
      'status': instance.status,
    };
