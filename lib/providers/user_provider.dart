import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/progress_model.dart';
import 'database_provider.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  User? _user;
  UserStats? _userStats;
  List<UserBadge> _badges = [];
  DailyStreak? _streak;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  UserStats? get userStats => _userStats;
  List<UserBadge> get badges => _badges;
  DailyStreak? get streak => _streak;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user data
  Future<void> loadUserData(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _databaseProvider.getUser(userId);
      _userStats = await _databaseProvider.getUserStats(userId);
      _badges = await _databaseProvider.getUserBadges(userId);
      _streak = await _databaseProvider.getDailyStreak(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh user stats
  Future<void> refreshUserStats(String userId) async {
    try {
      _userStats = await _databaseProvider.getUserStats(userId);
      _user = await _databaseProvider.getUser(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Refresh badges
  Future<void> refreshBadges(String userId) async {
    try {
      _badges = await _databaseProvider.getUserBadges(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Refresh streak
  Future<void> refreshStreak(String userId) async {
    try {
      _streak = await _databaseProvider.getDailyStreak(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Update user name
  Future<bool> updateUserName(String userId, String newName) async {
    try {
      await _databaseProvider.updateUser(
        userId: userId,
        name: newName,
      );
      _user = _user?.copyWith(name: newName);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Award badge (helper method)
  Future<void> awardBadgeIfNeeded({
    required String userId,
    required String badgeType,
    required String badgeName,
    required String description,
  }) async {
    try {
      // Check if badge already earned
      final alreadyEarned =
          _badges.any((badge) => badge.badgeType == badgeType);
      if (!alreadyEarned) {
        await _databaseProvider.awardBadge(
          userId: userId,
          badgeType: badgeType,
          badgeName: badgeName,
          description: description,
        );
        await refreshBadges(userId);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Check for milestone badges
  Future<void> checkMilestoneBadges(String userId) async {
    if (_userStats == null) return;

    // Check streak milestones
    if (_streak != null) {
      if (_streak!.currentStreakDays == 7) {
        await awardBadgeIfNeeded(
          userId: userId,
          badgeType: 'streak_starter',
          badgeName: 'Streak Starter',
          description: 'Completed a 7-day learning streak',
        );
      }
      if (_streak!.currentStreakDays == 30) {
        await awardBadgeIfNeeded(
          userId: userId,
          badgeType: 'streak_champion',
          badgeName: 'Streak Champion',
          description: 'Completed a 30-day learning streak',
        );
      }
    }

    // Check lesson count milestones
    if (_userStats!.lessonsCompleted == 1) {
      await awardBadgeIfNeeded(
        userId: userId,
        badgeType: 'first_steps',
        badgeName: 'First Steps',
        description: 'Completed your first lesson',
      );
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
