import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/Exceptions/app_exceptions.dart';

class AuthService {
  final String baseUrl = "https://resback.sampaarsh.cloud";
  static const int _timeoutSeconds = 30;
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _roleKey = 'user_role';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/users/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'UserName': username, 'Password': password}),
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // Extract token from data object
        final token = decodedData['data']?['token'] ?? '';
        final userData = decodedData['data'] ?? {};
        const userRole = 'manager';

        if (token.isEmpty) {
          throw ApiException(message: decodedData['message'] ?? 'Login failed');
        }

        // Save token and user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userKey, jsonEncode(userData));
        await prefs.setString(_roleKey, userRole);

        return {'token': token, 'user': userData, 'role': userRole};
      } else {
        throw ApiException(
          message: 'Login failed - Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NetworkException(message: 'Network error during login');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ApiException(
        message: 'Error during login: $e',
        originalException: e,
      );
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_roleKey);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return jsonDecode(userJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final role = await getUserRole();
    return token != null && role != null && role.toLowerCase() == 'manager';
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      await prefs.remove(_roleKey);
    } catch (e) {
      throw RepositoryException(
        message: 'Error during logout',
        originalException: e,
      );
    }
  }

  Future<String?> validateToken() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await http
          .post(
            Uri.parse('$baseUrl/users/validate'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return token;
      } else {
        await logout();
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
