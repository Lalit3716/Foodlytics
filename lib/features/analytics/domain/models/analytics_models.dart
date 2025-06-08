import 'package:json_annotation/json_annotation.dart';

part 'analytics_models.g.dart';

@JsonSerializable()
class DashboardData {
  final Overview overview;
  final TodayStats today;
  final WeeklyStats weekly;
  final NutritionTotals nutritionTotals;
  final HealthScoreDistribution healthScoreDistribution;
  final ScanningPatterns scanningPatterns;
  final List<AllergenCount> topAllergens;

  DashboardData({
    required this.overview,
    required this.today,
    required this.weekly,
    required this.nutritionTotals,
    required this.healthScoreDistribution,
    required this.scanningPatterns,
    required this.topAllergens,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

@JsonSerializable()
class Overview {
  final int totalScans;
  final int uniqueProducts;
  final int totalCalories;
  final int averageHealthScore;

  Overview({
    required this.totalScans,
    required this.uniqueProducts,
    required this.totalCalories,
    required this.averageHealthScore,
  });

  factory Overview.fromJson(Map<String, dynamic> json) =>
      _$OverviewFromJson(json);
  Map<String, dynamic> toJson() => _$OverviewToJson(this);
}

@JsonSerializable()
class TodayStats {
  final int scans;
  final int calories;
  final List<ScannedProduct> products;

  TodayStats({
    required this.scans,
    required this.calories,
    required this.products,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) =>
      _$TodayStatsFromJson(json);
  Map<String, dynamic> toJson() => _$TodayStatsToJson(this);
}

@JsonSerializable()
class ScannedProduct {
  final String barcode;
  final String name;
  final double calories;
  final double healthScore;
  final DateTime scannedAt;

  ScannedProduct({
    required this.barcode,
    required this.name,
    required this.calories,
    required this.healthScore,
    required this.scannedAt,
  });

  factory ScannedProduct.fromJson(Map<String, dynamic> json) =>
      _$ScannedProductFromJson(json);
  Map<String, dynamic> toJson() => _$ScannedProductToJson(this);
}

@JsonSerializable()
class WeeklyStats {
  final int scans;
  final int calories;
  final double averageScansPerDay;

  WeeklyStats({
    required this.scans,
    required this.calories,
    required this.averageScansPerDay,
  });

  factory WeeklyStats.fromJson(Map<String, dynamic> json) =>
      _$WeeklyStatsFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyStatsToJson(this);
}

@JsonSerializable()
class NutritionTotals {
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int sugar;
  final int sodium;

  NutritionTotals({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory NutritionTotals.fromJson(Map<String, dynamic> json) =>
      _$NutritionTotalsFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionTotalsToJson(this);
}

@JsonSerializable()
class HealthScoreDistribution {
  final int excellent;
  final int good;
  final int fair;
  final int poor;

  HealthScoreDistribution({
    required this.excellent,
    required this.good,
    required this.fair,
    required this.poor,
  });

  factory HealthScoreDistribution.fromJson(Map<String, dynamic> json) =>
      _$HealthScoreDistributionFromJson(json);
  Map<String, dynamic> toJson() => _$HealthScoreDistributionToJson(this);
}

@JsonSerializable()
class ScanningPatterns {
  final int? mostActiveHour;
  final String? mostActiveDay;
  final double averageScansPerDay;

  ScanningPatterns({
    this.mostActiveHour,
    this.mostActiveDay,
    required this.averageScansPerDay,
  });

  factory ScanningPatterns.fromJson(Map<String, dynamic> json) =>
      _$ScanningPatternsFromJson(json);
  Map<String, dynamic> toJson() => _$ScanningPatternsToJson(this);
}

@JsonSerializable()
class AllergenCount {
  final String allergen;
  final int count;

  AllergenCount({
    required this.allergen,
    required this.count,
  });

  factory AllergenCount.fromJson(Map<String, dynamic> json) =>
      _$AllergenCountFromJson(json);
  Map<String, dynamic> toJson() => _$AllergenCountToJson(this);
}

// Daily Stats Models
@JsonSerializable()
class DailyStatsResponse {
  final List<DailyStat> dailyStats;

  DailyStatsResponse({required this.dailyStats});

  factory DailyStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DailyStatsResponseToJson(this);
}

@JsonSerializable()
class DailyStat {
  final DateTime date;
  final int scans;
  final int calories;
  final int productCount;

  DailyStat({
    required this.date,
    required this.scans,
    required this.calories,
    required this.productCount,
  });

  factory DailyStat.fromJson(Map<String, dynamic> json) =>
      _$DailyStatFromJson(json);
  Map<String, dynamic> toJson() => _$DailyStatToJson(this);
}

// Nutrition Data Models
@JsonSerializable()
class NutritionData {
  final NutritionTotals totals;
  final NutritionAverages averagePerScan;
  final MacroDistribution macroDistribution;

  NutritionData({
    required this.totals,
    required this.averagePerScan,
    required this.macroDistribution,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) =>
      _$NutritionDataFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionDataToJson(this);
}

@JsonSerializable()
class NutritionAverages {
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;

  NutritionAverages({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory NutritionAverages.fromJson(Map<String, dynamic> json) =>
      _$NutritionAveragesFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionAveragesToJson(this);
}

@JsonSerializable()
class MacroDistribution {
  final int protein;
  final int carbs;
  final int fat;

  MacroDistribution({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MacroDistribution.fromJson(Map<String, dynamic> json) =>
      _$MacroDistributionFromJson(json);
  Map<String, dynamic> toJson() => _$MacroDistributionToJson(this);
} 