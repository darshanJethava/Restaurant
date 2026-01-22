import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class MenuCategoryServices {
  final String baseUrl = "https://resback.sampaarsh.cloud/menu-categories";
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

  Future<List<dynamic>> getAllCategories() async {
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
          message:
              'Failed to fetch categories - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(
        message: 'Network error while fetching categories',
      );
    } catch (e) {
      throw ApiException(
        message: 'Error fetching categories: $e',
        originalException: e,
      );
    }
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw ApiException(message: 'Category data cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .post(Uri.parse(baseUrl), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          message: 'Failed to create category - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while creating category');
    } catch (e) {
      throw ApiException(
        message: 'Error creating category: $e',
        originalException: e,
      );
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    try {
      if (id.isEmpty || data.isEmpty) {
        throw ApiException(message: 'Invalid category data');
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
          message: 'Failed to update category - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while updating category');
    } catch (e) {
      throw ApiException(
        message: 'Error updating category: $e',
        originalException: e,
      );
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      if (id.isEmpty) {
        throw ApiException(message: 'Category ID cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Failed to delete category - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error while deleting category');
    } catch (e) {
      throw ApiException(
        message: 'Error deleting category: $e',
        originalException: e,
      );
    }
  }
}
