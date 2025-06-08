import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:foodlytics/features/product/domain/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // Updated API endpoint

  Future<Product?> getProduct(String barcode) async {
    // Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) {
      debugPrint('No token found, user must be logged in to fetch products');
      return null;
    }

    try {
      // Call our server endpoint with authentication
      final response = await _dio.get(
        '$_baseUrl/product/$barcode',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Product.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching product: $e');
      return null;
    }
  }
}
