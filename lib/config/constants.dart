/// App-wide constants
class AppConstants {
  // API Configuration
  static const String supabaseUrl = 'https://your-supabase-url.supabase.co';
  static const String supabaseAnonKey = 'your-supabase-anon-key';

  // App Information
  static const String appName = 'Indian Language Learning';
  static const String appVersion = '1.0.0';

  // Gamification Settings
  static const int xpPerLessonCompletion = 50;
  static const int xpPerExerciseCompletion = 10;
  static const int xpBonusPerfectAccuracy = 10;
  static const double perfectAccuracyThreshold = 90.0; // Percentage

  // Level System
  static const int baseXpPerLevel = 100;

  // Module Unlock Levels
  static const int moduleOneUnlockLevel = 1;
  static const int moduleTwoUnlockLevel = 5;
  static const int moduleThreeUnlockLevel = 10;
  static const int moduleFourUnlockLevel = 15;

  // Lesson Settings
  static const int minLessonDurationMinutes = 5;
  static const int maxLessonDurationMinutes = 10;
  static const int minExercisesPerLesson = 5;
  static const int maxExercisesPerLesson = 10;
  static const int minExercisesForCompletion = 4;
  static const double minCompletionRatePercent = 80.0;

  // Badge Types
  static const String badgeTypeFirstSteps = 'first_steps';
  static const String badgeTypeWordCollector = 'word_collector';
  static const String badgeTypeGrammarMaster = 'grammar_master';
  static const String badgeTypeListener = 'listener';
  static const String badgeTypeSpeaker = 'speaker';
  static const String badgeTypeStreakStarter = 'streak_starter';
  static const String badgeTypeStreakChampion = 'streak_champion';
  static const String badgeTypePolyglotLearner = 'polyglot_learner';

  // Streak Settings
  static const int streakMilestone7Days = 7;
  static const int streakMilestone30Days = 30;
  static const int streakMilestone100Days = 100;

  // Leaderboard Settings
  static const int leaderboardTopUsersCount = 50;

  // Languages
  static const String languageHindi = 'hindi';
  static const String languageTelugu = 'telugu';

  // Exercise Types
  static const String exerciseTypeMultipleChoice = 'multiple_choice';
  static const String exerciseTypeFillBlank = 'fill_blank';
  static const String exerciseTypeListening = 'listening';
  static const String exerciseTypeSpeaking = 'speaking';

  // Accuracy Thresholds
  static const double weakAreaAccuracyThreshold = 70.0; // Below this is weak area

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;

  // Timeouts
  static const Duration authTimeout = Duration(seconds: 30);
  static const Duration databaseTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyLanguagePreferences = 'language_preferences';
}

/// Badge Definitions
class BadgeDefinition {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final String? condition;

  BadgeDefinition({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.condition,
  });

  static Map<String, BadgeDefinition> allBadges = {
    AppConstants.badgeTypeFirstSteps: BadgeDefinition(
      id: AppConstants.badgeTypeFirstSteps,
      name: 'First Steps',
      description: 'Complete your first lesson',
      condition: 'lessons_completed >= 1',
    ),
    AppConstants.badgeTypeWordCollector: BadgeDefinition(
      id: AppConstants.badgeTypeWordCollector,
      name: 'Word Collector',
      description: 'Complete 20 vocabulary exercises',
      condition: 'vocab_exercises >= 20',
    ),
    AppConstants.badgeTypeGrammarMaster: BadgeDefinition(
      id: AppConstants.badgeTypeGrammarMaster,
      name: 'Grammar Master',
      description: 'Complete 20 grammar exercises',
      condition: 'grammar_exercises >= 20',
    ),
    AppConstants.badgeTypeListener: BadgeDefinition(
      id: AppConstants.badgeTypeListener,
      name: 'Listener',
      description: 'Complete 10 listening exercises',
      condition: 'listening_exercises >= 10',
    ),
    AppConstants.badgeTypeSpeaker: BadgeDefinition(
      id: AppConstants.badgeTypeSpeaker,
      name: 'Speaker',
      description: 'Complete 5 speaking exercises',
      condition: 'speaking_exercises >= 5',
    ),
    AppConstants.badgeTypeStreakStarter: BadgeDefinition(
      id: AppConstants.badgeTypeStreakStarter,
      name: 'Streak Starter',
      description: 'Achieve a 7-day learning streak',
      condition: 'streak_days >= 7',
    ),
    AppConstants.badgeTypeStreakChampion: BadgeDefinition(
      id: AppConstants.badgeTypeStreakChampion,
      name: 'Streak Champion',
      description: 'Achieve a 30-day learning streak',
      condition: 'streak_days >= 30',
    ),
    AppConstants.badgeTypePolyglotLearner: BadgeDefinition(
      id: AppConstants.badgeTypePolyglotLearner,
      name: 'Polyglot Learner',
      description: 'Complete lessons in both Hindi and Telugu',
      condition: 'languages_learned >= 2',
    ),
  };
}
