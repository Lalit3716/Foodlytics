import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:foodlytics/features/product/domain/models/product.dart';

// Hardcoded sample barcodes
const sampleBarcodes = [
  "3017620422003",
  "5449000000996",
  "7622210449283",
  "5449000054227"
];

class ProductService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2';

  Future<Product?> getProduct(String barcode) async {
    // First try with the scanned barcode
    try {
      final response = await _dio.get('$_baseUrl/product/$barcode');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 1 && data['product'] != null) {
          return Product.fromApiResponse(data);
        }
      }
    } catch (e) {
      print('Error fetching product with scanned barcode: $e');
    }

    // If no product found with scanned barcode, use random sample for testing
    final randomBarcode =
        sampleBarcodes[Random().nextInt(sampleBarcodes.length)];
    print('Using sample barcode for testing: $randomBarcode');

    try {
      final response = await _dio.get('$_baseUrl/product/$randomBarcode');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 1 && data['product'] != null) {
          return Product.fromApiResponse(data);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching sample product: $e');
      return null;
    }
  }
}
