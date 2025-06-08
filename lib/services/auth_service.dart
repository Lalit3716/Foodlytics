import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class AuthService {
  static const String baseUrl =
      'https://foodlytics-backend-1.onrender.com/api/auth';

  Future<AuthResponse> login(String username, String password) async {
    debugPrint('Login request: $username, $password');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          LoginRequest(username: username, password: password).toJson(),
        ),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Login failed: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> register(String email, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(RegisterRequest(
          email: email,
          username: username,
          password: password,
        ).toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get user details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get user details: $e');
    }
  }
}
