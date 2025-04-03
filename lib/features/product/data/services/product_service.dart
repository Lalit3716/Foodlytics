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
    // Get random barcode from sample list
    final randomBarcode =
        sampleBarcodes[Random().nextInt(sampleBarcodes.length)];

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
      print('Error fetching product: $e');
      return null;
    }
  }
}
