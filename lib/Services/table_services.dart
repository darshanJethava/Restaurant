import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class TableServices {
  final String baseUrl = "https://resback.sampaarsh.cloud/tables";
  static const int _timeoutSeconds = 30;
  static const String _tokenKey = 'jwt_token';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getAllTables() async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(baseUrl), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final data = decodedData['data'] ?? decodedData;
        return data is List ? data : [];
      } else {
        throw ApiException(
          message: 'Failed to fetch tables - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while fetching tables');
    } catch (e) {
      throw ApiException(
        message: 'Error fetching tables: $e',
        originalException: e,
      );
    }
  }

  Future<void> createTable(Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw ApiException(message: 'Table data cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .post(Uri.parse(baseUrl), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          message: 'Failed to create table - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while creating table');
    } catch (e) {
      throw ApiException(
        message: 'Error creating table: $e',
        originalException: e,
      );
    }
  }

  Future<void> updateTable(String id, Map<String, dynamic> data) async {
    try {
      if (id.isEmpty || data.isEmpty) {
        throw ApiException(message: 'Invalid table data');
      }

      final headers = await _getHeaders();
      final response = await http
          .put(
            Uri.parse('$baseUrl/$id'),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Failed to update table - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while updating table');
    } catch (e) {
      throw ApiException(
        message: 'Error updating table: $e',
        originalException: e,
      );
    }
  }

  Future<void> deleteTable(String id) async {
    try {
      if (id.isEmpty) {
        throw ApiException(message: 'Table ID cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Failed to delete table - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while deleting table');
    } catch (e) {
      throw ApiException(
        message: 'Error deleting table: $e',
        originalException: e,
      );
    }
  }
}
