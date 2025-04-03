import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodlytics/features/history/data/services/history_service.dart';
import 'package:foodlytics/features/product/domain/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _recentScans = [];
  bool _isLoading = true;
  String? _error;
  HistoryService? _historyService;

  @override
  void initState() {
    super.initState();
    _initializeHistory();
  }

  Future<void> _initializeHistory() async {
    try {
      final service = await HistoryService.getInstance();
      if (mounted) {
        setState(() {
          _historyService = service;
        });
        await _loadRecentScans();
      }
    } catch (e) {
      print('Error initializing history service: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to initialize history service';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadRecentScans() async {
    if (_historyService == null) return;

    try {
      final history = await _historyService!.getHistory();
      if (mounted) {
        setState(() {
          _recentScans = history.take(5).toList();
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      print('Error loading recent scans: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load recent scans';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodlytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Foodlytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan food products to analyze their nutritional content',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/scanner'),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Barcode'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Scans',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/history'),
                  icon: const Icon(Icons.history),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
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
              onPressed: _loadRecentScans,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_recentScans.isEmpty) {
      return Center(
        child: Text(
          'No recent scans',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _recentScans.length,
      itemBuilder: (context, index) {
        final product = _recentScans[index];
        return Card(
          child: ListTile(
            leading: product.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image_not_supported),
            title: Text(product.name),
            subtitle: Text(product.brand),
            trailing: Text(
              '${product.nutritionInfo.calories.toStringAsFixed(0)} kcal',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () => context.go('/product/${product.barcode}'),
          ),
        );
      },
    );
  }
}
