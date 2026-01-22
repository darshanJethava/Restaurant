import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class UserServices {
  final String baseUrl = "https://resback.sampaarsh.cloud/users";
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

  Future<List<dynamic>> getAlluser() async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(baseUrl), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        try {
          final decodedData = jsonDecode(response.body);

          // Extract data from response wrapper
          var data = decodedData['data'];
          if (data == null) {
            data = decodedData;
          }

          if (data is List) {
            return data.cast<dynamic>();
          } else if (data is Map) {
            return [data];
          } else {
            return [];
          }
        } catch (e) {
          throw ParseException(message: 'Failed to parse user data: $e');
        }
      } else {
        throw ApiException(
          message: 'Failed to fetch users - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Request timeout while fetching users');
    } on ApiException {
      rethrow;
    } on ParseException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected error fetching users: $e');
    }
  }

  Future<void> createuser(Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw ApiException(message: 'User data cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .post(Uri.parse(baseUrl), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          message: 'Failed to create user - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Request timeout while creating user');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected error creating user: $e');
    }
  }

  Future<void> updateuser(String id, Map<String, dynamic> data) async {
    try {
      if (id.isEmpty) {
        throw ApiException(message: 'User ID cannot be empty');
      }

      if (data.isEmpty) {
        throw ApiException(message: 'User data cannot be empty');
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
          message: 'Failed to update user - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Request timeout while updating user');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected error updating user: $e');
    }
  }

  Future<void> deleteuser(String id) async {
    try {
      if (id.isEmpty) {
        throw ApiException(message: 'User ID cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Failed to delete user - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Request timeout while deleting user');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected error deleting user: $e');
    }
  }
}
