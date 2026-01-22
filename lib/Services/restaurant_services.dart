import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class RestaurantServices {
  final String baseUrl = "https://resback.sampaarsh.cloud/restaurants";
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

  Future<List<dynamic>> getAllRestaurants() async {
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
              'Failed to fetch restaurants - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(
        message: 'Network error while fetching restaurants',
      );
    } catch (e) {
      throw ApiException(message: 'Error fetching restaurants: $e');
    }
  }

  Future<void> createRestaurant(Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) {
        throw ApiException(message: 'Restaurant data cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .post(Uri.parse(baseUrl), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          message:
              'Failed to create restaurant - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(
        message: 'Network error while creating restaurant',
      );
    } catch (e) {
      throw ApiException(message: 'Error creating restaurant: $e');
    }
  }

  Future<void> updateRestaurant(String id, Map<String, dynamic> data) async {
    try {
      if (id.isEmpty || data.isEmpty) {
        throw ApiException(message: 'Invalid restaurant data');
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
          message:
              'Failed to update restaurant - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(
        message: 'Network error while updating restaurant',
      );
    } catch (e) {
      throw ApiException(message: 'Error updating restaurant: $e');
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      if (id.isEmpty) {
        throw ApiException(message: 'Restaurant ID cannot be empty');
      }

      final headers = await _getHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'), headers: headers)
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message:
              'Failed to delete restaurant - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(
        message: 'Network error while deleting restaurant',
      );
    } catch (e) {
      throw ApiException(message: 'Error deleting restaurant: $e');
    }
  }
}
