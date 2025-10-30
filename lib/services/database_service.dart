import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/progress_model.dart';
import '../models/social_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  final _supabase = Supabase.instance.client;

  /// USERS TABLE OPERATIONS

  /// Create user profile in database
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String name,
    required List<String> languagePreferences,
  }) async {
    try {
      await _supabase.from('users').insert({
        'id': userId,
        'email': email,
        'name': name,
        'language_preferences': languagePreferences,
        'total_xp': 0,
        'current_level': 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get user profile
  Future<User?> getUserProfile(String userId) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', userId).single();
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    List<String>? languagePreferences,
    String? profilePictureUrl,
  }) async {
    try {
      await _supabase.from('users').update({
        if (name != null) 'name': name,
        if (languagePreferences != null)
          'language_preferences': languagePreferences,
        if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  /// PROGRESS OPERATIONS

  /// Record lesson completion
  Future<void> recordLessonCompletion({
    required String userId,
    required String lessonId,
    required String languageId,
    required double accuracy,
    required int xpEarned,
  }) async {
    try {
      await _supabase.from('lesson_progress').insert({
        'user_id': userId,
        'lesson_id': lessonId,
        'language_id': languageId,
        'is_completed': true,
        'accuracy': accuracy,
        'xp_earned': xpEarned,
        'attempts': 1,
        'completed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Update user XP and level
      await _updateUserXP(userId, xpEarned);
    } catch (e) {
      rethrow;
    }
  }

  /// Get lesson progress
  Future<LessonProgress?> getLessonProgress({
    required String userId,
    required String lessonId,
  }) async {
    try {
      final response = await _supabase
          .from('lesson_progress')
          .select()
          .eq('user_id', userId)
          .eq('lesson_id', lessonId)
          .maybeSingle();

      if (response == null) return null;
      return LessonProgress.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Get all completed lessons for a user
  Future<List<LessonProgress>> getCompletedLessons(String userId) async {
    try {
      final response = await _supabase
          .from('lesson_progress')
          .select()
          .eq('user_id', userId)
          .eq('is_completed', true)
          .order('completed_at', ascending: false);

      return (response as List)
          .map((item) => LessonProgress.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get user stats (aggregated progress data)
  Future<UserStats?> getUserStats(String userId) async {
    try {
      final response = await _supabase
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .single();

      return UserStats.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// STREAK OPERATIONS

  /// Get or create daily streak
  Future<DailyStreak?> getDailyStreak(String userId) async {
    try {
      final response = await _supabase
          .from('daily_streaks')
          .select()
          .eq('user_id', userId)
          .eq('language_id', null) // Global streak
          .maybeSingle();

      if (response == null) return null;
      return DailyStreak.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Update daily streak (called after lesson completion)
  Future<void> updateDailyStreak(String userId) async {
    try {
      final currentStreak = await getDailyStreak(userId);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (currentStreak == null) {
        // Create new streak
        await _supabase.from('daily_streaks').insert({
          'user_id': userId,
          'language_id': null,
          'current_streak_days': 1,
          'last_activity_date': today.toIso8601String(),
          'longest_streak_days': 1,
          'updated_at': now.toIso8601String(),
        });
      } else {
        final lastActivityDate = DateTime.parse(
            currentStreak.lastActivityDate.toIso8601String());
        final lastActivityMidnight = DateTime(
          lastActivityDate.year,
          lastActivityDate.month,
          lastActivityDate.day,
        );

        // Check if streak continues
        final oneDayAgo = today.subtract(const Duration(days: 1));
        final streakContinues =
            lastActivityMidnight.isAtSameMomentAs(oneDayAgo) ||
                lastActivityMidnight.isAtSameMomentAs(today);

        int newStreakDays = streakContinues
            ? currentStreak.currentStreakDays + 1
            : 1; // Reset if broken

        int newLongestStreak = newStreakDays >
                currentStreak.longestStreakDays
            ? newStreakDays
            : currentStreak.longestStreakDays;

        await _supabase.from('daily_streaks').update({
          'current_streak_days': newStreakDays,
          'longest_streak_days': newLongestStreak,
          'last_activity_date': today.toIso8601String(),
          'updated_at': now.toIso8601String(),
        }).eq('user_id', userId);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// BADGES

  /// Award badge to user
  Future<void> awardBadge({
    required String userId,
    required String badgeType,
    required String badgeName,
    required String description,
  }) async {
    try {
      await _supabase.from('user_badges').insert({
        'user_id': userId,
        'badge_type': badgeType,
        'badge_name': badgeName,
        'description': description,
        'earned_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get user badges
  Future<List<UserBadge>> getUserBadges(String userId) async {
    try {
      final response = await _supabase
          .from('user_badges')
          .select()
          .eq('user_id', userId)
          .order('earned_at', ascending: false);

      return (response as List)
          .map((item) => UserBadge.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// LEADERBOARD

  /// Get global leaderboard (top 50 by weekly XP)
  Future<List<LeaderboardEntry>> getGlobalLeaderboard({
    int limit = 50,
    String? userId,
  }) async {
    try {
      final response = await _supabase
          .from('leaderboard_global')
          .select()
          .order('rank', ascending: true)
          .limit(limit);

      final entries = (response as List)
          .map((item) => LeaderboardEntry.fromJson(item))
          .toList();

      // Mark current user if provided
      if (userId != null) {
        for (var entry in entries) {
          if (entry.userId == userId) {
            entries[entries.indexOf(entry)] = LeaderboardEntry(
              userId: entry.userId,
              userName: entry.userName,
              userInitial: entry.userInitial,
              rank: entry.rank,
              totalXp: entry.totalXp,
              level: entry.level,
              isCurrentUser: true,
            );
          }
        }
      }

      return entries;
    } catch (e) {
      return [];
    }
  }

  /// Get friends leaderboard
  Future<List<LeaderboardEntry>> getFriendsLeaderboard(String userId) async {
    try {
      final response = await _supabase
          .from('leaderboard_friends')
          .select()
          .eq('user_id', userId)
          .order('total_xp', ascending: false);

      return (response as List)
          .map((item) => LeaderboardEntry.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// INTERNAL HELPERS

  /// Update user XP and recalculate level
  Future<void> _updateUserXP(String userId, int xpGained) async {
    try {
      // Get current user data
      final user = await getUserProfile(userId);
      if (user == null) return;

      final newXp = user.totalXp + xpGained;
      final newLevel = _calculateLevel(newXp);

      await _supabase.from('users').update({
        'total_xp': newXp,
        'current_level': newLevel,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  /// Calculate level from total XP
  /// Formula: Level = 1 + (totalXP / 100)
  int _calculateLevel(int totalXp) {
    return 1 + (totalXp ~/ 100);
  }
}
