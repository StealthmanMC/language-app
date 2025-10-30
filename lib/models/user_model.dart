import 'package:json_serializable/json_serializable.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String userId;
  final String email;
  final String name;
  final List<String> languagePreferences; // ["hindi", "telugu"]
  final int totalXp;
  final int currentLevel;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.languagePreferences,
    this.totalXp = 0,
    this.currentLevel = 1,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? userId,
    String? email,
    String? name,
    List<String>? languagePreferences,
    int? totalXp,
    int? currentLevel,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      languagePreferences: languagePreferences ?? this.languagePreferences,
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
