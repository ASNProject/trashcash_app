import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseRepository {
  static const baseUrl =
      "https://app-574b3b2b-05f4-4a14-a811-fd215c1e4fdf.cleverapps.io";

  static Future<Map<String, dynamic>?> fetchData(String idUser) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customer/$idUser'));

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
      final response = await http.get(Uri.parse('$baseUrl/customer'));

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

  static Future<Map<String, dynamic>?> fetchDebit() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/debit'));

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
      final response = await http.get(Uri.parse('$baseUrl/credit'));

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
  }) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/customer'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
        body: {
          'id_user': idUser,
          'password': password,
          'name': name,
          'address': address,
          'id_number': idNumber,
          'id_status': idStatus,
        }
      );
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
      final response = await http.post(Uri.parse('$baseUrl/type-waste'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'id_type': idType,
            'type': type,
            'price': price,

          }
      );
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
