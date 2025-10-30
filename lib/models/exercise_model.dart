import 'package:json_serializable/json_serializable.dart';

part 'exercise_model.g.dart';

enum ExerciseType {
  multipleChoice,
  fillBlank,
  listening,
  speaking,
}

@JsonSerializable()
class Exercise {
  final String exerciseId;
  final String lessonId;
  final String exerciseType; // "multiple_choice", "fill_blank", "listening", "speaking"
  final String questionText;
  final String correctAnswer;
  final List<String>? options; // for multiple-choice
  final String? audioUrl; // for listening/speaking
  final String? instructions;
  final int pointsValue; // 10 XP per correct answer

  Exercise({
    required this.exerciseId,
    required this.lessonId,
    required this.exerciseType,
    required this.questionText,
    required this.correctAnswer,
    this.options,
    this.audioUrl,
    this.instructions,
    this.pointsValue = 10,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  ExerciseType get type {
    switch (exerciseType) {
      case 'multiple_choice':
        return ExerciseType.multipleChoice;
      case 'fill_blank':
        return ExerciseType.fillBlank;
      case 'listening':
        return ExerciseType.listening;
      case 'speaking':
        return ExerciseType.speaking;
      default:
        return ExerciseType.multipleChoice;
    }
  }
}

@JsonSerializable()
class ExerciseAttempt {
  final String attemptId;
  final String userId;
  final String exerciseId;
  final String lessonId;
  final String userAnswer;
  final bool isCorrect;
  final int xpEarned;
  final DateTime attemptedAt;

  ExerciseAttempt({
    required this.attemptId,
    required this.userId,
    required this.exerciseId,
    required this.lessonId,
    required this.userAnswer,
    required this.isCorrect,
    required this.xpEarned,
    required this.attemptedAt,
  });

  factory ExerciseAttempt.fromJson(Map<String, dynamic> json) =>
      _$ExerciseAttemptFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseAttemptToJson(this);
}
