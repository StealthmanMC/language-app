import 'package:json_serializable/json_serializable.dart';

part 'social_model.g.dart';

@JsonSerializable()
class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? userInitial; // last initial if anonymous
  final int rank;
  final int totalXp;
  final int level;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.userInitial,
    required this.rank,
    required this.totalXp,
    required this.level,
    required this.isCurrentUser,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardEntryToJson(this);
}

@JsonSerializable()
class Friend {
  final String friendId;
  final String userId;
  final String friendUserId;
  final String friendName;
  final String friendEmail;
  final int friendXp;
  final int friendLevel;
  final DateTime addedAt;

  Friend({
    required this.friendId,
    required this.userId,
    required this.friendUserId,
    required this.friendName,
    required this.friendEmail,
    required this.friendXp,
    required this.friendLevel,
    required this.addedAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) =>
      _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}

@JsonSerializable()
class Challenge {
  final String challengeId;
  final String creatorUserId;
  final String challengedUserId;
  final String lessonId;
  final String? lessonName;
  final DateTime createdAt;
  final DateTime expiresAt; // 7 days from creation
  final String? creatorAnswer; // challenge creator's result
  final String? challengedAnswer; // challenged user's result
  final int? creatorXpEarned;
  final int? challengedXpEarned;
  final String status; // "pending", "completed", "expired"
  final String? winnerId; // null if incomplete

  Challenge({
    required this.challengeId,
    required this.creatorUserId,
    required this.challengedUserId,
    required this.lessonId,
    this.lessonName,
    required this.createdAt,
    required this.expiresAt,
    this.creatorAnswer,
    this.challengedAnswer,
    this.creatorXpEarned,
    this.challengedXpEarned,
    required this.status,
    this.winnerId,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
}

@JsonSerializable()
class FriendInvite {
  final String inviteId;
  final String inviterId;
  final String inviterName;
  final String inviterEmail;
  final String inviteCode;
  final DateTime createdAt;
  final DateTime expiresAt; // 30 days from creation
  final bool isUsed;

  FriendInvite({
    required this.inviteId,
    required this.inviterId,
    required this.inviterName,
    required this.inviterEmail,
    required this.inviteCode,
    required this.createdAt,
    required this.expiresAt,
    required this.isUsed,
  });

  factory FriendInvite.fromJson(Map<String, dynamic> json) =>
      _$FriendInviteFromJson(json);
  Map<String, dynamic> toJson() => _$FriendInviteToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
