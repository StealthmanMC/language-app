import 'package:flutter/material.dart';
import '../models/progress_model.dart';
import '../models/exercise_model.dart';
import 'database_provider.dart';

class ProgressProvider extends ChangeNotifier {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Map<String, LessonProgress> _lessonProgress = {};
  List<ExerciseAttempt> _exerciseAttempts = [];
  Map<String, List<WeakArea>> _weakAreasByLanguage = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Current lesson session data
  List<ExerciseAttempt> _currentSessionAttempts = [];
  int _currentSessionXp = 0;

  // Getters
  Map<String, LessonProgress> get lessonProgress => _lessonProgress;
  List<ExerciseAttempt> get exerciseAttempts => _exerciseAttempts;
  Map<String, List<WeakArea>> get weakAreasByLanguage => _weakAreasByLanguage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ExerciseAttempt> get currentSessionAttempts => _currentSessionAttempts;
  int get currentSessionXp => _currentSessionXp;

  /// Load user progress
  Future<void> loadUserProgress(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final completedLessons =
          await _databaseProvider.getCompletedLessons(userId);
      _lessonProgress = {for (var lesson in completedLessons) lesson.lessonId: lesson};

      // Load weak areas from user stats if available
      final userStats = await _databaseProvider.getUserStats(userId);
      if (userStats != null) {
        // Group weak areas by language
        for (var weakArea in userStats.weakAreas) {
          _weakAreasByLanguage.putIfAbsent(weakArea.lessonId, () => []);
          _weakAreasByLanguage[weakArea.lessonId]!.add(weakArea);
        }
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if lesson is completed
  bool isLessonCompleted(String lessonId) {
    return _lessonProgress.containsKey(lessonId) &&
        _lessonProgress[lessonId]!.isCompleted;
  }

  /// Get lesson progress
  LessonProgress? getLessonProgress(String lessonId) => _lessonProgress[lessonId];

  /// Get weak areas for language
  List<WeakArea> getWeakAreasForLanguage(String languageId) {
    return _weakAreasByLanguage[languageId] ?? [];
  }

  /// Start new lesson session
  void startNewLessonSession() {
    _currentSessionAttempts = [];
    _currentSessionXp = 0;
    notifyListeners();
  }

  /// Record exercise attempt in current session
  void recordExerciseAttempt({
    required String exerciseId,
    required String lessonId,
    required String userAnswer,
    required bool isCorrect,
    int xpEarned = 0,
  }) {
    final attempt = ExerciseAttempt(
      attemptId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '', // Set by caller
      exerciseId: exerciseId,
      lessonId: lessonId,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
      xpEarned: xpEarned,
      attemptedAt: DateTime.now(),
    );

    _currentSessionAttempts.add(attempt);
    _currentSessionXp += xpEarned;
    notifyListeners();
  }

  /// Calculate lesson accuracy from current session
  double calculateSessionAccuracy() {
    if (_currentSessionAttempts.isEmpty) return 0.0;
    final correct = _currentSessionAttempts.where((a) => a.isCorrect).length;
    return (correct / _currentSessionAttempts.length) * 100;
  }

  /// Check if lesson is completed (enough exercises answered)
  bool isLessonComplete() {
    // Lesson is complete if ≥80% of exercises are answered
    // Typically means 4+ out of 5 exercises
    return _currentSessionAttempts.length >= 4;
  }

  /// Complete lesson and save to database
  Future<bool> completeLessonSession({
    required String userId,
    required String lessonId,
    required String languageId,
  }) async {
    if (!isLessonComplete()) return false;

    try {
      final accuracy = calculateSessionAccuracy();

      // Record lesson completion to database
      await _databaseProvider.recordLessonCompletion(
        userId: userId,
        lessonId: lessonId,
        languageId: languageId,
        accuracy: accuracy,
        xpEarned: _currentSessionXp,
      );

      // Update local progress
      _lessonProgress[lessonId] = LessonProgress(
        progressId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        lessonId: lessonId,
        languageId: languageId,
        isCompleted: true,
        accuracy: accuracy,
        xpEarned: _currentSessionXp,
        attempts: 1,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Update daily streak
      await _databaseProvider.updateDailyStreak(userId);

      // Mark exercises with <70% accuracy as weak areas
      for (var attempt in _currentSessionAttempts) {
        if (!attempt.isCorrect) {
          // Track this exercise as weak area
          // This would be synced to database in full implementation
        }
      }

      _currentSessionAttempts = [];
      _currentSessionXp = 0;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get exercises to practice weak areas for language
  List<String> getWeakAreaExerciseIds(String languageId, {int limit = 10}) {
    final weakAreas = getWeakAreasForLanguage(languageId);
    return weakAreas.take(limit).map((w) => w.exerciseId).toList();
  }

  /// Get user accuracy for language
  double getLanguageAccuracy(String languageId) {
    final lessons = _lessonProgress.values
        .where((l) => l.languageId == languageId && l.isCompleted)
        .toList();

    if (lessons.isEmpty) return 0.0;

    final totalAccuracy =
        lessons.fold(0.0, (sum, lesson) => sum + lesson.accuracy);
    return totalAccuracy / lessons.length;
  }

  /// Get total lessons completed for language
  int getCompletedLessonsCount(String languageId) {
    return _lessonProgress.values
        .where((l) => l.languageId == languageId && l.isCompleted)
        .length;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
