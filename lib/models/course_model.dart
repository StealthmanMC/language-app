import 'package:json_serializable/json_serializable.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Language {
  final String languageId;
  final String name; // "Hindi" / "Telugu"
  final String scriptType; // "Devanagari" / "Telugu"
  final String description;
  final String flagEmoji;
  final bool isActive;

  Language({
    required this.languageId,
    required this.name,
    required this.scriptType,
    required this.description,
    required this.flagEmoji,
    this.isActive = true,
  });

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

@JsonSerializable()
class Course {
  final String courseId;
  final String languageId;
  final String courseName;
  final String description;
  final String difficultyLevel; // "A1", "A2"
  final List<String> moduleIds; // ordered list of module IDs

  Course({
    required this.courseId,
    required this.languageId,
    required this.courseName,
    required this.description,
    required this.difficultyLevel,
    required this.moduleIds,
  });

  factory Course.fromJson(Map<String, dynamic> json) =>
      _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable()
class Module {
  final String moduleId;
  final String courseId;
  final String moduleName;
  final String description;
  final int sequenceOrder;
  final List<String> lessonIds; // ordered list of lesson IDs
  final int unlockLevel; // required level to access

  Module({
    required this.moduleId,
    required this.courseId,
    required this.moduleName,
    required this.description,
    required this.sequenceOrder,
    required this.lessonIds,
    required this.unlockLevel,
  });

  factory Module.fromJson(Map<String, dynamic> json) =>
      _$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  bool isUnlocked(int userLevel) => userLevel >= unlockLevel;
}

@JsonSerializable()
class VocabularyItem {
  final String wordId;
  final String nativeWord; // Hindi/Telugu script
  final String englishTranslation;
  final String pronunciationGuide; // transliteration
  final String partOfSpeech; // noun, verb, etc.
  final String audioUrl; // cloud storage link
  final String? exampleSentence;
  final String? exampleSentenceTranslation;
  final String? culturalNotes;

  VocabularyItem({
    required this.wordId,
    required this.nativeWord,
    required this.englishTranslation,
    required this.pronunciationGuide,
    required this.partOfSpeech,
    required this.audioUrl,
    this.exampleSentence,
    this.exampleSentenceTranslation,
    this.culturalNotes,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) =>
      _$VocabularyItemFromJson(json);
  Map<String, dynamic> toJson() => _$VocabularyItemToJson(this);
}

@JsonSerializable()
class Lesson {
  final String lessonId;
  final String moduleId;
  final String lessonName;
  final String description;
  final int durationMinutes;
  final String introduction;
  final List<VocabularyItem> vocabulary;
  final String grammarRule;
  final List<String> exampleSentences; // native language
  final List<String> exampleSentenceTranslations; // English
  final String culturalContext;
  final List<String> exerciseIds; // ordered list of exercise IDs

  Lesson({
    required this.lessonId,
    required this.moduleId,
    required this.lessonName,
    required this.description,
    required this.durationMinutes,
    required this.introduction,
    required this.vocabulary,
    required this.grammarRule,
    required this.exampleSentences,
    required this.exampleSentenceTranslations,
    required this.culturalContext,
    required this.exerciseIds,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
