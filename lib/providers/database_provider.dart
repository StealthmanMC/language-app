import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/progress_model.dart';
import '../models/social_model.dart';

class DatabaseProvider {
  final DatabaseService _databaseService = DatabaseService();

  /// USER OPERATIONS

  Future<void> createUser({
    required String userId,
    required String email,
    required String name,
    required List<String> languagePreferences,
  }) async {
    return _databaseService.createUserProfile(
      userId: userId,
      email: email,
      name: name,
      languagePreferences: languagePreferences,
    );
  }

  Future<User?> getUser(String userId) async {
    return _databaseService.getUserProfile(userId);
  }

  Future<void> updateUser({
    required String userId,
    String? name,
    List<String>? languagePreferences,
    String? profilePictureUrl,
  }) async {
    return _databaseService.updateUserProfile(
      userId: userId,
      name: name,
      languagePreferences: languagePreferences,
      profilePictureUrl: profilePictureUrl,
    );
  }

  Future<void> updateLanguagePreferences({
    required String userId,
    required List<String> languages,
  }) async {
    return _databaseService.updateUserProfile(
      userId: userId,
      languagePreferences: languages,
    );
  }

  /// PROGRESS OPERATIONS

  Future<void> recordLessonCompletion({
    required String userId,
    required String lessonId,
    required String languageId,
    required double accuracy,
    required int xpEarned,
  }) async {
    return _databaseService.recordLessonCompletion(
      userId: userId,
      lessonId: lessonId,
      languageId: languageId,
      accuracy: accuracy,
      xpEarned: xpEarned,
    );
  }

  Future<LessonProgress?> getLessonProgress({
    required String userId,
    required String lessonId,
  }) async {
    return _databaseService.getLessonProgress(
      userId: userId,
      lessonId: lessonId,
    );
  }

  Future<List<LessonProgress>> getCompletedLessons(String userId) async {
    return _databaseService.getCompletedLessons(userId);
  }

  Future<UserStats?> getUserStats(String userId) async {
    return _databaseService.getUserStats(userId);
  }

  /// STREAK OPERATIONS

  Future<DailyStreak?> getDailyStreak(String userId) async {
    return _databaseService.getDailyStreak(userId);
  }

  Future<void> updateDailyStreak(String userId) async {
    return _databaseService.updateDailyStreak(userId);
  }

  /// BADGE OPERATIONS

  Future<void> awardBadge({
    required String userId,
    required String badgeType,
    required String badgeName,
    required String description,
  }) async {
    return _databaseService.awardBadge(
      userId: userId,
      badgeType: badgeType,
      badgeName: badgeName,
      description: description,
    );
  }

  Future<List<UserBadge>> getUserBadges(String userId) async {
    return _databaseService.getUserBadges(userId);
  }

  /// LEADERBOARD OPERATIONS

  Future<List<LeaderboardEntry>> getGlobalLeaderboard({
    int limit = 50,
    String? userId,
  }) async {
    return _databaseService.getGlobalLeaderboard(
      limit: limit,
      userId: userId,
    );
  }

  Future<List<LeaderboardEntry>> getFriendsLeaderboard(String userId) async {
    return _databaseService.getFriendsLeaderboard(userId);
  }
}
