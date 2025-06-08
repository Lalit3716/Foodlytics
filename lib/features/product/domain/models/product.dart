import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  @JsonKey(name: 'barcode')
  final String barcode;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'brand')
  final String brand;

  @JsonKey(name: 'imageUrl')
  final String imageUrl;

  @JsonKey(name: 'nutritionInfo')
  final NutritionInfo nutritionInfo;

  @JsonKey(name: 'ingredients')
  final List<String> ingredients;

  @JsonKey(name: 'allergens')
  final List<String> allergens;

  @JsonKey(name: 'servingSize')
  final String servingSize;

  @JsonKey(name: 'servingUnit')
  final String servingUnit;

  @JsonKey(name: 'healthScore')
  final double healthScore;

  @JsonKey(name: 'recommendations')
  final Recommendations? recommendations;

  Product({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.nutritionInfo,
    required this.ingredients,
    required this.allergens,
    required this.servingSize,
    required this.servingUnit,
    required this.healthScore,
    this.recommendations,
  });

  // For regular JSON serialization (used by HistoryService)
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // Special factory for handling OpenFoodFacts API response
  factory Product.fromApiResponse(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? {};
    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

    // Extract product name and brand with better fallbacks
    String name = product['product_name']?.toString() ??
        product['product_name_en']?.toString() ??
        product['generic_name']?.toString() ??
        'Unknown Product';

    String brand = product['brands']?.toString() ??
        product['brand_owner']?.toString() ??
        'Unknown Brand';

    // Clean up the name and brand
    name = name.trim();
    brand = brand.trim();

    return Product(
      barcode: product['code']?.toString() ?? '',
      name: name,
      brand: brand,
      imageUrl: product['image_url']?.toString() ?? '',
      nutritionInfo: NutritionInfo(
        calories: nutriments['energy-kcal_100g']?.toDouble() ?? 0.0,
        protein: nutriments['proteins_100g']?.toDouble() ?? 0.0,
        carbs: nutriments['carbohydrates_100g']?.toDouble() ?? 0.0,
        fat: nutriments['fat_100g']?.toDouble() ?? 0.0,
        fiber: nutriments['fiber_100g']?.toDouble() ?? 0.0,
        sugar: nutriments['sugars_100g']?.toDouble() ?? 0.0,
        sodium: nutriments['sodium_100g']?.toDouble() ?? 0.0,
      ),
      ingredients: (product['ingredients'] as List<dynamic>?)
              ?.map(
                  (e) => (e as Map<String, dynamic>)['text']?.toString() ?? '')
              .where((text) => text.isNotEmpty)
              .toList() ??
          [],
      allergens: (product['allergens_tags'] as List<dynamic>?)
              ?.map((e) => e.toString().replaceAll('en:', ''))
              .where((allergen) => allergen.isNotEmpty)
              .toList() ??
          [],
      servingSize: product['serving_size']?.toString() ?? '100',
      servingUnit: product['serving_unit']?.toString() ?? 'g',
      healthScore: _calculateHealthScore(
        nutriments['energy-kcal_100g']?.toDouble() ?? 0.0,
        nutriments['proteins_100g']?.toDouble() ?? 0.0,
        nutriments['carbohydrates_100g']?.toDouble() ?? 0.0,
        nutriments['fat_100g']?.toDouble() ?? 0.0,
        nutriments['fiber_100g']?.toDouble() ?? 0.0,
        nutriments['sugars_100g']?.toDouble() ?? 0.0,
        nutriments['sodium_100g']?.toDouble() ?? 0.0,
      ),
    );
  }

  static double _calculateHealthScore(
    double calories,
    double protein,
    double carbs,
    double fat,
    double fiber,
    double sugar,
    double sodium,
  ) {
    double score = 100.0;

    // Calories (max 40% of daily value)
    if (calories > 400)
      score -= 40;
    else if (calories > 300)
      score -= 30;
    else if (calories > 200)
      score -= 20;
    else if (calories > 100) score -= 10;

    // Protein (positive impact)
    if (protein > 20)
      score += 10;
    else if (protein > 15) score += 5;

    // Carbs (negative impact if too high)
    if (carbs > 50)
      score -= 15;
    else if (carbs > 30) score -= 10;

    // Fat (negative impact if too high)
    if (fat > 20)
      score -= 15;
    else if (fat > 10) score -= 10;

    // Fiber (positive impact)
    if (fiber > 5)
      score += 10;
    else if (fiber > 3) score += 5;

    // Sugar (negative impact)
    if (sugar > 20)
      score -= 20;
    else if (sugar > 10) score -= 10;

    // Sodium (negative impact)
    if (sodium > 500)
      score -= 15;
    else if (sodium > 300) score -= 10;

    return score.clamp(0, 100);
  }
}

@JsonSerializable(explicitToJson: true)
class NutritionInfo {
  @JsonKey(name: 'calories')
  final double calories;

  @JsonKey(name: 'protein')
  final double protein;

  @JsonKey(name: 'carbs')
  final double carbs;

  @JsonKey(name: 'fat')
  final double fat;

  @JsonKey(name: 'fiber')
  final double fiber;

  @JsonKey(name: 'sugar')
  final double sugar;

  @JsonKey(name: 'sodium')
  final double sodium;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Recommendations {
  @JsonKey(name: 'recommendations')
  final List<Recommendation> recommendations;

  @JsonKey(name: 'generalAdvice')
  final String generalAdvice;

  Recommendations({
    required this.recommendations,
    required this.generalAdvice,
  });

  factory Recommendations.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Recommendation {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'imgUrl')
  final String? imgUrl;

  @JsonKey(name: 'barcode')
  final String? barcode;

  @JsonKey(name: 'reason')
  final String reason;

  @JsonKey(name: 'nutritionHighlights')
  final List<String> nutritionHighlights;

  @JsonKey(name: 'category')
  final String category;

  Recommendation({
    required this.name,
    this.imgUrl,
    this.barcode,
    required this.reason,
    required this.nutritionHighlights,
    required this.category,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationToJson(this);
}
