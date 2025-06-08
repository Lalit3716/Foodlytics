// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      overview: Overview.fromJson(json['overview'] as Map<String, dynamic>),
      today: TodayStats.fromJson(json['today'] as Map<String, dynamic>),
      weekly: WeeklyStats.fromJson(json['weekly'] as Map<String, dynamic>),
      nutritionTotals: NutritionTotals.fromJson(
          json['nutritionTotals'] as Map<String, dynamic>),
      healthScoreDistribution: HealthScoreDistribution.fromJson(
          json['healthScoreDistribution'] as Map<String, dynamic>),
      scanningPatterns: ScanningPatterns.fromJson(
          json['scanningPatterns'] as Map<String, dynamic>),
      topAllergens: (json['topAllergens'] as List<dynamic>)
          .map((e) => AllergenCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'overview': instance.overview,
      'today': instance.today,
      'weekly': instance.weekly,
      'nutritionTotals': instance.nutritionTotals,
      'healthScoreDistribution': instance.healthScoreDistribution,
      'scanningPatterns': instance.scanningPatterns,
      'topAllergens': instance.topAllergens,
    };

Overview _$OverviewFromJson(Map<String, dynamic> json) => Overview(
      totalScans: (json['totalScans'] as num).toInt(),
      uniqueProducts: (json['uniqueProducts'] as num).toInt(),
      totalCalories: (json['totalCalories'] as num).toInt(),
      averageHealthScore: (json['averageHealthScore'] as num).toInt(),
    );

Map<String, dynamic> _$OverviewToJson(Overview instance) => <String, dynamic>{
      'totalScans': instance.totalScans,
      'uniqueProducts': instance.uniqueProducts,
      'totalCalories': instance.totalCalories,
      'averageHealthScore': instance.averageHealthScore,
    };

TodayStats _$TodayStatsFromJson(Map<String, dynamic> json) => TodayStats(
      scans: (json['scans'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      products: (json['products'] as List<dynamic>)
          .map((e) => ScannedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TodayStatsToJson(TodayStats instance) =>
    <String, dynamic>{
      'scans': instance.scans,
      'calories': instance.calories,
      'products': instance.products,
    };

ScannedProduct _$ScannedProductFromJson(Map<String, dynamic> json) =>
    ScannedProduct(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      healthScore: (json['healthScore'] as num).toDouble(),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );

Map<String, dynamic> _$ScannedProductToJson(ScannedProduct instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'name': instance.name,
      'calories': instance.calories,
      'healthScore': instance.healthScore,
      'scannedAt': instance.scannedAt.toIso8601String(),
    };

WeeklyStats _$WeeklyStatsFromJson(Map<String, dynamic> json) => WeeklyStats(
      scans: (json['scans'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      averageScansPerDay: (json['averageScansPerDay'] as num).toDouble(),
    );

Map<String, dynamic> _$WeeklyStatsToJson(WeeklyStats instance) =>
    <String, dynamic>{
      'scans': instance.scans,
      'calories': instance.calories,
      'averageScansPerDay': instance.averageScansPerDay,
    };

NutritionTotals _$NutritionTotalsFromJson(Map<String, dynamic> json) =>
    NutritionTotals(
      protein: (json['protein'] as num).toInt(),
      carbs: (json['carbs'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
      fiber: (json['fiber'] as num).toInt(),
      sugar: (json['sugar'] as num).toInt(),
      sodium: (json['sodium'] as num).toInt(),
    );

Map<String, dynamic> _$NutritionTotalsToJson(NutritionTotals instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
    };

HealthScoreDistribution _$HealthScoreDistributionFromJson(
        Map<String, dynamic> json) =>
    HealthScoreDistribution(
      excellent: (json['excellent'] as num).toInt(),
      good: (json['good'] as num).toInt(),
      fair: (json['fair'] as num).toInt(),
      poor: (json['poor'] as num).toInt(),
    );

Map<String, dynamic> _$HealthScoreDistributionToJson(
        HealthScoreDistribution instance) =>
    <String, dynamic>{
      'excellent': instance.excellent,
      'good': instance.good,
      'fair': instance.fair,
      'poor': instance.poor,
    };

ScanningPatterns _$ScanningPatternsFromJson(Map<String, dynamic> json) =>
    ScanningPatterns(
      mostActiveHour: (json['mostActiveHour'] as num?)?.toInt(),
      mostActiveDay: json['mostActiveDay'] as String?,
      averageScansPerDay: (json['averageScansPerDay'] as num).toDouble(),
    );

Map<String, dynamic> _$ScanningPatternsToJson(ScanningPatterns instance) =>
    <String, dynamic>{
      'mostActiveHour': instance.mostActiveHour,
      'mostActiveDay': instance.mostActiveDay,
      'averageScansPerDay': instance.averageScansPerDay,
    };

AllergenCount _$AllergenCountFromJson(Map<String, dynamic> json) =>
    AllergenCount(
      allergen: json['allergen'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$AllergenCountToJson(AllergenCount instance) =>
    <String, dynamic>{
      'allergen': instance.allergen,
      'count': instance.count,
    };

DailyStatsResponse _$DailyStatsResponseFromJson(Map<String, dynamic> json) =>
    DailyStatsResponse(
      dailyStats: (json['dailyStats'] as List<dynamic>)
          .map((e) => DailyStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyStatsResponseToJson(DailyStatsResponse instance) =>
    <String, dynamic>{
      'dailyStats': instance.dailyStats,
    };

DailyStat _$DailyStatFromJson(Map<String, dynamic> json) => DailyStat(
      date: DateTime.parse(json['date'] as String),
      scans: (json['scans'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      productCount: (json['productCount'] as num).toInt(),
    );

Map<String, dynamic> _$DailyStatToJson(DailyStat instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'scans': instance.scans,
      'calories': instance.calories,
      'productCount': instance.productCount,
    };

NutritionData _$NutritionDataFromJson(Map<String, dynamic> json) =>
    NutritionData(
      totals: NutritionTotals.fromJson(json['totals'] as Map<String, dynamic>),
      averagePerScan: NutritionAverages.fromJson(
          json['averagePerScan'] as Map<String, dynamic>),
      macroDistribution: MacroDistribution.fromJson(
          json['macroDistribution'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NutritionDataToJson(NutritionData instance) =>
    <String, dynamic>{
      'totals': instance.totals,
      'averagePerScan': instance.averagePerScan,
      'macroDistribution': instance.macroDistribution,
    };

NutritionAverages _$NutritionAveragesFromJson(Map<String, dynamic> json) =>
    NutritionAverages(
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
    );

Map<String, dynamic> _$NutritionAveragesToJson(NutritionAverages instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
    };

MacroDistribution _$MacroDistributionFromJson(Map<String, dynamic> json) =>
    MacroDistribution(
      protein: (json['protein'] as num).toInt(),
      carbs: (json['carbs'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
    );

Map<String, dynamic> _$MacroDistributionToJson(MacroDistribution instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
    };
