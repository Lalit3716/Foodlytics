import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:foodlytics/features/product/domain/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryApiService {
  final Dio _dio = Dio();
  static const String _baseUrl =
      'https://foodlytics-backend-1.onrender.com/api'; // Updated API endpoint

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Product>> getHistory({int limit = 50, int offset = 0}) async {
    final token = await _getToken();
    if (token == null) {
      debugPrint('No token found, user must be logged in');
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/history',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> historyData = response.data['history'];
        debugPrint(historyData.toString());
        return historyData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load history');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      throw Exception('Failed to load history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }

  Future<void> clearHistory() async {
    final token = await _getToken();
    if (token == null) {
      debugPrint('No token found, user must be logged in');
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.delete(
        '$_baseUrl/history',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear history');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      throw Exception('Failed to clear history: ${e.message}');
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }

  Future<void> deleteHistoryItem(String barcode) async {
    final token = await _getToken();
    if (token == null) {
      debugPrint('No token found, user must be logged in');
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.delete(
        '$_baseUrl/history/$barcode',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete history item');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (e.response?.statusCode == 404) {
        throw Exception('History item not found');
      }
      throw Exception('Failed to delete history item: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete history item: $e');
    }
  }
}
