import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodlytics/features/analytics/domain/models/analytics_models.dart';

class AnalyticsService {
  static const String _baseUrl =
      'https://foodlytics-backend-1.onrender.com/api'; // Replace with your server URL

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<DashboardData> getDashboard() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/analytics/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DashboardData.fromJson(data);
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }

  Future<DailyStatsResponse> getDailyStats({int days = 30}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/analytics/daily?days=$days'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DailyStatsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load daily statistics');
    }
  }

  Future<NutritionData> getNutritionBreakdown() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/analytics/nutrition'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NutritionData.fromJson(data);
    } else {
      throw Exception('Failed to load nutrition data');
    }
  }

  Future<void> resetAnalytics() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/analytics/reset'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset analytics');
    }
  }
} 