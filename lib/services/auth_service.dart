import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final _secureStorage = const FlutterSecureStorage();
  final _supabase = Supabase.instance.client;

  String? get userId => _supabase.auth.currentUser?.id;
  String? get userEmail => _supabase.auth.currentUser?.email;
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user != null) {
        // Store JWT token securely
        await _storeToken(response.session?.accessToken);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _storeToken(response.session?.accessToken);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Google OAuth
  Future<AuthResponse> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://callback/',
      );

      if (response.user != null) {
        await _storeToken(response.session?.accessToken);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify email confirmation (if needed)
  Future<void> verifyEmail({required String token}) async {
    try {
      await _supabase.auth.verifyOTP(
        token: token,
        type: OtpType.signup,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String name,
    String? avatarUrl,
  }) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': name,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearToken();
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh auth session
  Future<void> refreshSession() async {
    try {
      final refreshToken = await _getStoredToken();
      if (refreshToken != null) {
        await _supabase.auth.refreshSession();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Store JWT token securely
  Future<void> _storeToken(String? token) async {
    if (token != null) {
      await _secureStorage.write(key: 'auth_token', value: token);
    }
  }

  /// Retrieve stored JWT token
  Future<String?> _getStoredToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  /// Clear stored token
  Future<void> _clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  /// Check if user is still authenticated (validate token)
  Future<bool> validateCurrentSession() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) return false;

      // Token is valid if user exists
      return _supabase.auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }
}
