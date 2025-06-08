import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/scanner/presentation/screens/scanner_screen.dart';
import 'features/history/presentation/screens/history_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/product/presentation/screens/product_details_screen.dart';
import 'features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'features/chatbot/presentation/screens/chatbot_screen.dart';
import 'features/analytics/presentation/screens/analytics_dashboard_screen.dart';
import 'core/presentation/screens/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = Provider.of<AuthProvider>(context);
          
          final router = GoRouter(
            initialLocation: '/',
            redirect: (context, state) {
              final isAuthenticated = authProvider.isAuthenticated;
              final isLoading = authProvider.isLoading;
              
              // Show loading screen while checking auth status
              if (isLoading) return null;
              
              // Redirect to login if not authenticated and not already on auth screens
              if (!isAuthenticated && 
                  state.uri.path != '/login' && 
                  state.uri.path != '/register') {
                return '/login';
              }
              
              // Redirect to home if authenticated and on auth screens
              if (isAuthenticated && 
                  (state.uri.path == '/login' || 
                   state.uri.path == '/register' || 
                   state.uri.path == '/')) {
                return '/home';
              }
              
              return null;
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const AuthWrapper(),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/register',
                builder: (context, state) => const RegisterScreen(),
              ),
              
              // Main routes with bottom navigation
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: MainLayout(
                    currentIndex: 0,
                    child: const HomeScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: '/leaderboard',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: MainLayout(
                    currentIndex: 1,
                    child: const LeaderboardScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: MainLayout(
                    currentIndex: 3,
                    child: const ProfileScreen(),
                  ),
                ),
              ),
              
              GoRoute(
                path: '/chatbot',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: MainLayout(
                    currentIndex: 2,
                    child: const ChatbotScreen(),
                  ),
                ),
              ),
              
              // Other routes without bottom navigation
              GoRoute(
                path: '/scanner',
                builder: (context, state) => const ScannerScreen(),
              ),
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsDashboardScreen(),
              ),
              GoRoute(
                path: '/product/:barcode',
                builder: (context, state) {
                  final barcode = state.pathParameters['barcode']!;
                  return ProductDetailsScreen(barcode: barcode);
                },
              ),
            ],
          );

          return MaterialApp.router(
            title: 'Foodlytics',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // Check auth status when the app starts
        auth.checkAuthStatus();

        if (auth.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (auth.isAuthenticated) {
          return MainLayout(
            currentIndex: 0,
            child: const HomeScreen(),
          );
        }

        return const LoginScreen();
      },
    );
  }
}
