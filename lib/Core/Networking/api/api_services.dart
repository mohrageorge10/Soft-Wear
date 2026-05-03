import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soft_wear/Core/Constants/api_constants.dart';

class ApiService {
  final String _baseUrl = ApiConstants.weatherBaseUrl;

  Future<dynamic> get({
    required String endPoint,
    Map<String, String>? query,
  }) async {
    try {
      var uri = Uri.parse('$_baseUrl$endPoint');
      if (query != null) {
        uri = uri.replace(queryParameters: query);
      }

      final response = await http.get(uri);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("${ApiConstants.networkError} $e");
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else if (response.statusCode == 400) {
      throw Exception("${ApiConstants.badRequest} ${response.body}");
    } else if (response.statusCode == 401) {
      throw Exception(ApiConstants.unauthorized);
    } else {
      throw Exception("${ApiConstants.serverError} ${response.statusCode}");
    }
  }
}
