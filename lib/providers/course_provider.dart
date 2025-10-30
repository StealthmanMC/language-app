import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../data/courses_data.dart';

class CourseProvider extends ChangeNotifier {
  // Courses data loaded from hardcoded data
  List<Language> _languages = [];
  Map<String, Course> _courses = {};
  Map<String, Module> _modules = {};
  Map<String, Lesson> _lessons = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Language> get languages => _languages;
  List<Course> get courses => _courses.values.toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize courses from hardcoded data
  Future<void> loadCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load all hardcoded data
      CoursesData coursesData = CoursesData();
      _languages = coursesData.languages;
      _courses = coursesData.courses;
      _modules = coursesData.modules;
      _lessons = coursesData.lessons;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get language by ID
  Language? getLanguage(String languageId) {
    try {
      return _languages.firstWhere((lang) => lang.languageId == languageId);
    } catch (e) {
      return null;
    }
  }

  /// Get course for a language
  Course? getCourseForLanguage(String languageId) {
    try {
      return _courses.values.firstWhere((c) => c.languageId == languageId);
    } catch (e) {
      return null;
    }
  }

  /// Get module by ID
  Module? getModule(String moduleId) => _modules[moduleId];

  /// Get modules for a course
  List<Module> getModulesForCourse(String courseId) {
    final course = _courses.values
        .firstWhere((c) => c.courseId == courseId, orElse: () => null as Course);
    if (course == null) return [];

    return course.moduleIds
        .map((moduleId) => _modules[moduleId])
        .where((module) => module != null)
        .cast<Module>()
        .toList();
  }

  /// Get lesson by ID
  Lesson? getLesson(String lessonId) => _lessons[lessonId];

  /// Get lessons for a module
  List<Lesson> getLessonsForModule(String moduleId) {
    final module = _modules[moduleId];
    if (module == null) return [];

    return module.lessonIds
        .map((lessonId) => _lessons[lessonId])
        .where((lesson) => lesson != null)
        .cast<Lesson>()
        .toList();
  }

  /// Get next lesson after current lesson
  Lesson? getNextLesson(String currentLessonId) {
    // Find the lesson and module
    Lesson? currentLesson = _lessons[currentLessonId];
    if (currentLesson == null) return null;

    Module? module = _modules[currentLesson.moduleId];
    if (module == null) return null;

    // Find index of current lesson in module
    final lessonIndex =
        module.lessonIds.indexOf(currentLessonId);
    if (lessonIndex == -1 || lessonIndex == module.lessonIds.length - 1) {
      // No next lesson in this module, try next module
      return null;
    }

    final nextLessonId = module.lessonIds[lessonIndex + 1];
    return _lessons[nextLessonId];
  }

  /// Check if module is unlocked for user
  bool isModuleUnlocked(String moduleId, int userLevel) {
    final module = _modules[moduleId];
    if (module == null) return false;
    return module.isUnlocked(userLevel);
  }

  /// Get all unlocked modules for user
  List<Module> getUnlockedModulesForCourse(
    String courseId,
    int userLevel,
  ) {
    final modules = getModulesForCourse(courseId);
    return modules.where((module) => module.isUnlocked(userLevel)).toList();
  }

  /// Search lessons by keyword
  List<Lesson> searchLessons(String query) {
    final lowerQuery = query.toLowerCase();
    return _lessons.values
        .where((lesson) =>
            lesson.lessonName.toLowerCase().contains(lowerQuery) ||
            lesson.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
