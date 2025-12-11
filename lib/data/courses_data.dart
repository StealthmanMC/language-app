import 'package:uuid/uuid.dart';
import '../models/course_model.dart';
import '../models/exercise_model.dart';

class CoursesData {
  static final CoursesData _instance = CoursesData._internal();
  bool _initialized = false;

  factory CoursesData() {
    return _instance;
  }

  CoursesData._internal() {
    _initializeData();
  }

  late List<Language> languages;
  late Map<String, Course> courses;
  late Map<String, Module> modules;
  late Map<String, Lesson> lessons;
  late Map<String, Exercise> exercises;

  void _initializeData() {
    if (_initialized) return;
    const uuid = Uuid();

    // Initialize languages
    final hindiLangId = uuid.v4();
    final teluguLangId = uuid.v4();

    languages = [
      Language(
        languageId: hindiLangId,
        name: 'Hindi',
        scriptType: 'Devanagari',
        description: 'Devanagari script - spoken by 260+ million native speakers',
        flagEmoji: '🇮🇳',
        isActive: true,
      ),
      Language(
        languageId: teluguLangId,
        name: 'Telugu',
        scriptType: 'Telugu',
        description: 'Telugu script - spoken by 80+ million native speakers',
        flagEmoji: '🇮🇳',
        isActive: true,
      ),
    ];

    // Initialize Hindi course
    final hindiCourseId = uuid.v4();
    final hindiModules = _createHindiModules(uuid, hindiCourseId);

    courses = {
      hindiCourseId: Course(
        courseId: hindiCourseId,
        languageId: hindiLangId,
        courseName: 'Beginner Hindi',
        description: 'Learn Hindi from scratch - Alphabet, vocabulary, and basic grammar',
        difficultyLevel: 'A1-A2',
        moduleIds: hindiModules.keys.toList(),
      ),
    };

    // Initialize Telugu course
    final teluguCourseId = uuid.v4();
    final teluguModules = _createTeluguModules(uuid, teluguCourseId);

    courses[teluguCourseId] = Course(
      courseId: teluguCourseId,
      languageId: teluguLangId,
      courseName: 'Beginner Telugu',
      description: 'Learn Telugu from scratch - Alphabet, vocabulary, and basic grammar',
      difficultyLevel: 'A1-A2',
      moduleIds: teluguModules.keys.toList(),
    );

    // Combine modules
    modules = {...hindiModules, ...teluguModules};

    // Combine lessons and exercises from all modules
    lessons = {};
    exercises = {};

    for (var module in modules.values) {
      for (var lessonId in module.lessonIds) {
        // Lessons will be populated by module creation
      }
    }

    // Populate lessons from the created modules
    _populateLessons();
  }

  /// Create Hindi modules with lessons
  Map<String, Module> _createHindiModules(Uuid uuid, String courseId) {
    Map<String, Module> hindiModules = {};

    // Module 1: Alphabet & Numbers
    final alphaModuleId = uuid.v4();
    final alphaLesson1 = _createLesson(
      uuid,
      alphaModuleId,
      'Devanagari Alphabet - Vowels',
      'Learn the 5 basic vowels (vowels) in Devanagari script',
      5,
      'अ, आ, इ, ई, उ',
      [
        VocabularyItem(
          wordId: uuid.v4(),
          nativeWord: 'अ',
          englishTranslation: 'A (as in father)',
          pronunciationGuide: 'a',
          partOfSpeech: 'vowel',
          audioUrl: 'https://storage.example.com/hindi/vowel_a.mp3',
          culturalNotes: 'The most basic sound in Sanskrit and Hindi',
        ),
        VocabularyItem(
          wordId: uuid.v4(),
          nativeWord: 'आ',
          englishTranslation: 'Aa (as in father)',
          pronunciationGuide: 'ā',
          partOfSpeech: 'vowel',
          audioUrl: 'https://storage.example.com/hindi/vowel_aa.mp3',
        ),
      ],
      'Vowels (स्वर - Svar) form the foundation of Hindi. Each vowel can be short or long.',
      ['अब (ab) - now', 'आज (aaj) - today'],
      ['Now', 'Today'],
      'In Indian culture, the alphabet is considered sacred. The first word taught to children is often "अ" (a).',
      [uuid.v4(), uuid.v4()],
    );

    hindiModules[alphaModuleId] = Module(
      moduleId: alphaModuleId,
      courseId: courseId,
      moduleName: 'Alphabet & Numbers',
      description: 'Master Devanagari script, vowels, consonants, and numbers 0-10',
      sequenceOrder: 1,
      lessonIds: [alphaLesson1],
      unlockLevel: 1,
    );

    // Module 2: Greetings & Common Phrases
    final greetingModuleId = uuid.v4();
    hindiModules[greetingModuleId] = Module(
      moduleId: greetingModuleId,
      courseId: courseId,
      moduleName: 'Greetings & Common Phrases',
      description: 'Essential greetings and polite expressions',
      sequenceOrder: 2,
      lessonIds: [uuid.v4()],
      unlockLevel: 5,
    );

    // Module 3: Family & Relationships
    final familyModuleId = uuid.v4();
    hindiModules[familyModuleId] = Module(
      moduleId: familyModuleId,
      courseId: courseId,
      moduleName: 'Family & Relationships',
      description: 'Learn vocabulary for family members and relationships',
      sequenceOrder: 3,
      lessonIds: [uuid.v4()],
      unlockLevel: 10,
    );

    // Module 4: Basic Present Tense
    final tensesModuleId = uuid.v4();
    hindiModules[tensesModuleId] = Module(
      moduleId: tensesModuleId,
      courseId: courseId,
      moduleName: 'Basic Present Tense',
      description: 'Simple present tense conjugations and usage',
      sequenceOrder: 4,
      lessonIds: [uuid.v4()],
      unlockLevel: 15,
    );

    return hindiModules;
  }

  /// Create Telugu modules with lessons
  Map<String, Module> _createTeluguModules(Uuid uuid, String courseId) {
    Map<String, Module> teluguModules = {};

    // Module 1: Alphabet & Numbers
    final alphaModuleId = uuid.v4();
    teluguModules[alphaModuleId] = Module(
      moduleId: alphaModuleId,
      courseId: courseId,
      moduleName: 'Alphabet & Numbers',
      description: 'Master Telugu script, vowels, consonants, and numbers 0-10',
      sequenceOrder: 1,
      lessonIds: [uuid.v4()],
      unlockLevel: 1,
    );

    // Module 2: Greetings & Common Phrases
    final greetingModuleId = uuid.v4();
    teluguModules[greetingModuleId] = Module(
      moduleId: greetingModuleId,
      courseId: courseId,
      moduleName: 'Greetings & Common Phrases',
      description: 'Essential greetings and polite expressions',
      sequenceOrder: 2,
      lessonIds: [uuid.v4()],
      unlockLevel: 5,
    );

    // Module 3: Family & Relationships
    final familyModuleId = uuid.v4();
    teluguModules[familyModuleId] = Module(
      moduleId: familyModuleId,
      courseId: courseId,
      moduleName: 'Family & Relationships',
      description: 'Learn vocabulary for family members and relationships',
      sequenceOrder: 3,
      lessonIds: [uuid.v4()],
      unlockLevel: 10,
    );

    // Module 4: Basic Present Tense
    final tensesModuleId = uuid.v4();
    teluguModules[tensesModuleId] = Module(
      moduleId: tensesModuleId,
      courseId: courseId,
      moduleName: 'Basic Present Tense',
      description: 'Simple present tense conjugations and usage',
      sequenceOrder: 4,
      lessonIds: [uuid.v4()],
      unlockLevel: 15,
    );

    return teluguModules;
  }

  /// Helper: Create a lesson with vocabulary and exercises
  String _createLesson(
    Uuid uuid,
    String moduleId,
    String lessonName,
    String description,
    int duration,
    String intro,
    List<VocabularyItem> vocab,
    String grammar,
    List<String> examples,
    List<String> exampleTranslations,
    String culturalContext,
    List<String> exerciseIds,
  ) {
    final lessonId = uuid.v4();
    lessons[lessonId] = Lesson(
      lessonId: lessonId,
      moduleId: moduleId,
      lessonName: lessonName,
      description: description,
      durationMinutes: duration,
      introduction: intro,
      vocabulary: vocab,
      grammarRule: grammar,
      exampleSentences: examples,
      exampleSentenceTranslations: exampleTranslations,
      culturalContext: culturalContext,
      exerciseIds: exerciseIds,
    );

    // Create exercises
    for (int i = 0; i < exerciseIds.length; i++) {
      final exerciseId = exerciseIds[i];
      exercises[exerciseId] = Exercise(
        exerciseId: exerciseId,
        lessonId: lessonId,
        exerciseType: i % 4 == 0
            ? 'multiple_choice'
            : i % 4 == 1
                ? 'fill_blank'
                : i % 4 == 2
                    ? 'listening'
                    : 'speaking',
        questionText: 'Exercise ${i + 1}',
        correctAnswer: 'Answer',
        options: ['Option 1', 'Answer', 'Option 3', 'Option 4'],
        audioUrl: 'https://storage.example.com/audio/exercise_${i + 1}.mp3',
        pointsValue: 10,
      );
    }

    return lessonId;
  }

  /// Populate lessons from modules
  void _populateLessons() {
    // This is handled during module creation
    // In a full implementation, this would load from a database
  }
}
