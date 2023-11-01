import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseRepository {
  // static const baseUrl =
  //     "https://app-574b3b2b-05f4-4a14-a811-fd215c1e4fdf.cleverapps.io";
  static const baseUrl =
      "https://asnproject.site/api";

  static Future<Map<String, dynamic>?> fetchData(String idUser) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers/$idUser'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchDataCustomerAll() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteCustomer(String idUser) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/customers/$idUser'));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchDebit() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/debits'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  static Future<Map<String, dynamic>?> fetchDebitId(String idUser) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/debits/$idUser'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchCredit() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/credits'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  static Future<Map<String, dynamic>?> fetchCreditId(String idUser) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/credits/$idUser'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addCustomer({
    required String idUser,
    required String password,
    required String name,
    required String address,
    required String idNumber,
    required String idStatus,
    required String idLoad,
  }) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/customers'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'id_user': idUser,
        'password': password,
        'name': name,
        'address': address,
        'id_number': idNumber,
        'id_status': idStatus,
        'id_load': idLoad,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addWasteType({
    required String idType,
    required String type,
    required String price,
  }) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/type-wastes'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'id_type': idType,
        'type': type,
        'price': price,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchDataTypeWasteAll() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/type-wastes'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchDataTypeWasteId(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/type-wastes/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteTypeWaste(String idType) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/type-wastes/$idType'));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchLoadId(String code) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/loads/$code'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> addCredit({
    required String userId,
    required String typeId,
    required String weight,
    required String credit,
  }) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/credits'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'id_user': userId,
        'id_type': typeId,
        'weight': weight,
        'credit': credit,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addDebit({
    required String userId,
    required String debit,
    required String status,
  }) async {
    try {
      final response =
      await http.post(Uri.parse('$baseUrl/debits'), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'id_user': userId,
        'debit': debit,
        'status_withdrawal': status,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

