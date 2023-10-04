import 'package:trashcash_app/data_sources/base_remote.dart';
import 'package:trashcash_app/data_sources/endpoints.dart';
import 'package:trashcash_app/models/customer/customer_model.dart';

import 'api_result.dart';

class DataSources extends BaseRemote {
  DataSources({
    required super.dio,
    required super.hostName,
    required super.apiBaseUrl,
  });

  Future<ApiResult<CustomerModel?>> getDetailCustomer(
    String idUser,
  ) async {
    final response = await get(
      EndPoints.getCustomerDetail.replaceAll(':id_user', idUser),
    );
    return ApiResult.fromResponse(
      response.data,
      (json) => json != null ? CustomerModel.fromJson(json) : null,
    );
  }
}
