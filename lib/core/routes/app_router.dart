import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodlytics/features/home/presentation/screens/home_screen.dart';
import 'package:foodlytics/features/profile/presentation/screens/profile_screen.dart';
import 'package:foodlytics/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:foodlytics/features/product/presentation/screens/product_details_screen.dart';
import 'package:foodlytics/features/history/presentation/screens/history_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/product/:barcode',
      builder: (context, state) => ProductDetailsScreen(
        barcode: state.pathParameters['barcode']!,
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
