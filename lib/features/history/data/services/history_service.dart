import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodlytics/features/product/domain/models/product.dart';

class HistoryService {
  static HistoryService? _instance;
  static SharedPreferences? _prefs;
  static const String _historyKey = 'scan_history';

  // Private constructor
  HistoryService._();

  static Future<HistoryService> getInstance() async {
    if (_instance == null) {
      _instance = HistoryService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<List<Product>> getHistory() async {
    final String? historyJson = _prefs?.getString(_historyKey);
    if (historyJson == null) return [];

    final List<dynamic> historyList = json.decode(historyJson);
    return historyList.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> addToHistory(Product product) async {
    final history = await getHistory();

    // Check if product already exists
    if (history.any((p) => p.barcode == product.barcode)) {
      print('Product already exists in history: $product');
      return;
    }

    print('Adding product to history: $product');
    // Add new product at the beginning
    history.insert(0, product);

    // Keep only last 50 items
    if (history.length > 50) {
      history.removeLast();
    }

    final historyJson = json.encode(history.map((p) => p.toJson()).toList());
    await _prefs?.setString(_historyKey, historyJson);
  }

  Future<Product?> getProductFromHistory(String barcode) async {
    final history = await getHistory();
    try {
      return history.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearHistory() async {
    await _prefs?.remove(_historyKey);
  }
}
