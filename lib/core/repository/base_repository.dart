import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseRepository {
  static Future<Map<String, dynamic>?> fetchData(String idUser) async {
    const baseUrl =
        "https://app-574b3b2b-05f4-4a14-a811-fd215c1e4fdf.cleverapps.io";

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
}
