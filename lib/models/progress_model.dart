import 'package:json_serializable/json_serializable.dart';

part 'progress_model.g.dart';

@JsonSerializable()
class LessonProgress {
  final String progressId;
  final String userId;
  final String lessonId;
  final String languageId;
  final bool isCompleted;
  final double accuracy; // percentage (0-100)
  final int xpEarned;
  final int attempts;
  final DateTime? completedAt;
  final DateTime updatedAt;

  LessonProgress({
    required this.progressId,
    required this.userId,
    required this.lessonId,
    required this.languageId,
    required this.isCompleted,
    required this.accuracy,
    required this.xpEarned,
    required this.attempts,
    this.completedAt,
    required this.updatedAt,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) =>
      _$LessonProgressFromJson(json);
  Map<String, dynamic> toJson() => _$LessonProgressToJson(this);
}

@JsonSerializable()
class DailyStreak {
  final String streakId;
  final String userId;
  final String? languageId; // null for global streak
  final int currentStreakDays;
  final DateTime lastActivityDate;
  final int longestStreakDays;
  final DateTime updatedAt;

  DailyStreak({
    required this.streakId,
    required this.userId,
    this.languageId,
    required this.currentStreakDays,
    required this.lastActivityDate,
    required this.longestStreakDays,
    required this.updatedAt,
  });

  factory DailyStreak.fromJson(Map<String, dynamic> json) =>
      _$DailyStreakFromJson(json);
  Map<String, dynamic> toJson() => _$DailyStreakToJson(this);

  bool get isBroken {
    final now = DateTime.now();
    final lastActivityMidnight = DateTime(
      lastActivityDate.year,
      lastActivityDate.month,
      lastActivityDate.day,
    );
    final nowMidnight = DateTime(now.year, now.month, now.day);
    final oneDayAgo = nowMidnight.subtract(const Duration(days: 1));

    return lastActivityMidnight.isBefore(oneDayAgo);
  }
}

@JsonSerializable()
class UserBadge {
  final String badgeId;
  final String userId;
  final String badgeName;
  final String badgeType; // enum: first_steps, word_collector, etc.
  final String description;
  final String? iconUrl;
  final DateTime earnedAt;

  UserBadge({
    required this.badgeId,
    required this.userId,
    required this.badgeName,
    required this.badgeType,
    required this.description,
    this.iconUrl,
    required this.earnedAt,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) =>
      _$UserBadgeFromJson(json);
  Map<String, dynamic> toJson() => _$UserBadgeToJson(this);
}

@JsonSerializable()
class WeakArea {
  final String exerciseId;
  final String lessonId;
  final String exerciseName;
  final double accuracy; // <70%
  final int attempts;
  final DateTime lastAttemptedAt;

  WeakArea({
    required this.exerciseId,
    required this.lessonId,
    required this.exerciseName,
    required this.accuracy,
    required this.attempts,
    required this.lastAttemptedAt,
  });

  factory WeakArea.fromJson(Map<String, dynamic> json) =>
      _$WeakAreaFromJson(json);
  Map<String, dynamic> toJson() => _$WeakAreaToJson(this);
}

@JsonSerializable()
class UserStats {
  final String userId;
  final int totalXp;
  final int currentLevel;
  final int lessonsCompleted;
  final int currentStreak;
  final int longestStreak;
  final double overallAccuracy;
  final List<WeakArea> weakAreas; // top 3
  final List<UserBadge> badges;
  final DateTime lastActivityDate;

  UserStats({
    required this.userId,
    required this.totalXp,
    required this.currentLevel,
    required this.lessonsCompleted,
    required this.currentStreak,
    required this.longestStreak,
    required this.overallAccuracy,
    required this.weakAreas,
    required this.badges,
    required this.lastActivityDate,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  /// Calculate XP required to reach next level
  int get xpToNextLevel {
    return 100 * (currentLevel + 1);
  }

  /// Calculate XP progress towards next level
  int get xpProgressToNextLevel {
    final xpThreshold = 100 * currentLevel;
    return (totalXp - xpThreshold).clamp(0, xpToNextLevel);
  }

  /// Calculate percentage progress to next level
  double get percentToNextLevel {
    if (xpToNextLevel == 0) return 1.0;
    return (xpProgressToNextLevel / xpToNextLevel).clamp(0, 1);
  }
}
