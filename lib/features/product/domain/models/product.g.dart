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
