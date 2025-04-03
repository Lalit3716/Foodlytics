import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodlytics/features/product/domain/models/product.dart';
import 'package:foodlytics/features/product/data/services/product_service.dart';
import 'package:foodlytics/features/history/data/services/history_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String barcode;

  const ProductDetailsScreen({
    super.key,
    required this.barcode,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _productService = ProductService();
  Product? _product;
  bool _isLoading = true;
  String? _error;
  HistoryService? _historyService;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadProduct();
  }

  Future<void> _initializeAndLoadProduct() async {
    try {
      final service = await HistoryService.getInstance();
      if (mounted) {
        setState(() {
          _historyService = service;
        });
        await _loadProduct();
      }
    } catch (e) {
      print('Error initializing history service: $e');
      await _loadProduct(); // Still try to load product even if history fails
    }
  }

  Future<void> _loadProduct() async {
    try {
      final cachedProduct =
          await _historyService!.getProductFromHistory(widget.barcode);
      if (cachedProduct != null) {
        setState(() {
          _product = cachedProduct;
          _isLoading = false;
        });
      }

      final product = await _productService.getProduct(widget.barcode);
      if (mounted) {
        setState(() {
          _product = product;
          _isLoading = false;
        });

        // Save to history if available
        if (product != null && _historyService != null) {
          await _historyService!.addToHistory(product);
        }
      }
    } catch (e) {
      print('Error loading product: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load product details';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProduct,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _product == null
                  ? const Center(
                      child: Text('Product not found'),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: _product!.imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: _product!.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _product!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _product!.brand,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 16),
                                _buildHealthScoreSection(),
                                const SizedBox(height: 24),
                                _buildNutritionSection(),
                                const SizedBox(height: 24),
                                _buildIngredientsSection(),
                                const SizedBox(height: 24),
                                _buildAllergensSection(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildHealthScoreSection() {
    final score = _product!.healthScore;
    final color = _getHealthScoreColor(score);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _getHealthScoreDescription(score),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Text(
              score.toStringAsFixed(0),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getHealthScoreDescription(double score) {
    if (score >= 80) return 'Excellent nutritional value';
    if (score >= 60) return 'Good nutritional value';
    if (score >= 40) return 'Fair nutritional value';
    return 'Poor nutritional value';
  }

  Widget _buildNutritionSection() {
    final nutrition = _product!.nutritionInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Facts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Serving Size: ${_product!.servingSize}${_product!.servingUnit}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: nutrition.protein,
                      title: '${nutrition.protein.toStringAsFixed(1)}g',
                      color: const Color(0xFF2196F3),
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: nutrition.carbs,
                      title: '${nutrition.carbs.toStringAsFixed(1)}g',
                      color: const Color(0xFF4CAF50),
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: nutrition.fat,
                      title: '${nutrition.fat.toStringAsFixed(1)}g',
                      color: const Color(0xFFFF9800),
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartLegendItem('Protein', const Color(0xFF2196F3)),
                    _buildChartLegendItem('Carbs', const Color(0xFF4CAF50)),
                    _buildChartLegendItem('Fat', const Color(0xFFFF9800)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildNutritionRow(
          'Calories',
          '${nutrition.calories.toStringAsFixed(1)} kcal',
          Icons.local_fire_department,
        ),
        _buildNutritionRow(
          'Protein',
          '${nutrition.protein.toStringAsFixed(1)}g',
          Icons.fitness_center,
        ),
        _buildNutritionRow(
          'Carbohydrates',
          '${nutrition.carbs.toStringAsFixed(1)}g',
          Icons.grain,
        ),
        _buildNutritionRow(
          'Fat',
          '${nutrition.fat.toStringAsFixed(1)}g',
          Icons.water_drop,
        ),
        _buildNutritionRow(
          'Fiber',
          '${nutrition.fiber.toStringAsFixed(1)}g',
          Icons.eco,
        ),
        _buildNutritionRow(
          'Sugar',
          '${nutrition.sugar.toStringAsFixed(1)}g',
          Icons.cake,
        ),
        _buildNutritionRow(
          'Sodium',
          '${nutrition.sodium.toStringAsFixed(1)}mg',
          Icons.water_drop,
        ),
      ],
    );
  }

  Widget _buildChartLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: _product!.ingredients
                .map((ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergensSection() {
    if (_product!.allergens.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergens',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _product!.allergens
                .map((allergen) => Chip(
                      label: Text(
                        allergen,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
