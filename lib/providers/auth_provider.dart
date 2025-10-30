import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'database_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  AuthProvider({required AuthService authService})
      : _authService = authService {
    _initializeAuth();
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _authService.userId;

  /// Initialize auth state on app startup
  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isValid = await _authService.validateCurrentSession();
      if (isValid && _authService.userId != null) {
        _isAuthenticated = true;
        // Load user profile
        _currentUser = await _databaseProvider.getUser(_authService.userId!);
      } else {
        _isAuthenticated = false;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign up with email
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (response.user != null) {
        // Create user profile in database
        await _databaseProvider.createUser(
          userId: response.user!.id,
          email: email,
          name: name,
          languagePreferences: [],
        );

        _currentUser = await _databaseProvider.getUser(response.user!.id);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Sign in with email
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = await _databaseProvider.getUser(response.user!.id);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signInWithGoogle();

      if (response.user != null) {
        // Check if user exists in database, if not create profile
        var user = await _databaseProvider.getUser(response.user!.id);
        if (user == null) {
          await _databaseProvider.createUser(
            userId: response.user!.id,
            email: response.user!.email!,
            name: response.user!.userMetadata?['name'] ?? 'User',
            languagePreferences: [],
          );
        }

        _currentUser = await _databaseProvider.getUser(response.user!.id);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String name,
    String? profilePictureUrl,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.updateUserProfile(
        name: name,
        avatarUrl: profilePictureUrl,
      );

      await _databaseProvider.updateUser(
        userId: _currentUser!.userId,
        name: name,
        profilePictureUrl: profilePictureUrl,
      );

      _currentUser = _currentUser!.copyWith(
        name: name,
        profilePictureUrl: profilePictureUrl,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update language preferences
  Future<bool> updateLanguagePreferences(List<String> languages) async {
    if (_currentUser == null) return false;

    try {
      await _databaseProvider.updateLanguagePreferences(
        userId: _currentUser!.userId,
        languages: languages,
      );

      _currentUser = _currentUser!.copyWith(
        languagePreferences: languages,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
