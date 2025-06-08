// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      imageUrl: json['imageUrl'] as String,
      nutritionInfo:
          NutritionInfo.fromJson(json['nutritionInfo'] as Map<String, dynamic>),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allergens:
          (json['allergens'] as List<dynamic>).map((e) => e as String).toList(),
      servingSize: json['servingSize'] as String,
      servingUnit: json['servingUnit'] as String,
      healthScore: (json['healthScore'] as num).toDouble(),
      recommendations: json['recommendations'] == null
          ? null
          : Recommendations.fromJson(
              json['recommendations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'name': instance.name,
      'brand': instance.brand,
      'imageUrl': instance.imageUrl,
      'nutritionInfo': instance.nutritionInfo.toJson(),
      'ingredients': instance.ingredients,
      'allergens': instance.allergens,
      'servingSize': instance.servingSize,
      'servingUnit': instance.servingUnit,
      'healthScore': instance.healthScore,
      'recommendations': instance.recommendations?.toJson(),
    };

NutritionInfo _$NutritionInfoFromJson(Map<String, dynamic> json) =>
    NutritionInfo(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
    );

Map<String, dynamic> _$NutritionInfoToJson(NutritionInfo instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
    };

Recommendations _$RecommendationsFromJson(Map<String, dynamic> json) =>
    Recommendations(
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      generalAdvice: json['generalAdvice'] as String,
    );

Map<String, dynamic> _$RecommendationsToJson(Recommendations instance) =>
    <String, dynamic>{
      'recommendations':
          instance.recommendations.map((e) => e.toJson()).toList(),
      'generalAdvice': instance.generalAdvice,
    };

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String?,
      barcode: json['barcode'] as String?,
      reason: json['reason'] as String,
      nutritionHighlights: (json['nutritionHighlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      category: json['category'] as String,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'barcode': instance.barcode,
      'reason': instance.reason,
      'nutritionHighlights': instance.nutritionHighlights,
      'category': instance.category,
    };
