import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(username, password);
      _token = response.accessToken;

      // Get user details
      _user = await _authService.getCurrentUser(_token!);

      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.register(email, username, password);
      // After successful registration, login the user
      await login(username, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;

    // Clear token from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null) {
      _token = savedToken;
      try {
        _user = await _authService.getCurrentUser(_token!);
      } catch (e) {
        // If token is invalid, clear it
        await logout();
      }
    }

    notifyListeners();
  }
}
