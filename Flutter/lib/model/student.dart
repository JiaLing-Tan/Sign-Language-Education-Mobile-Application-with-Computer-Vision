import 'package:fingo/model/progress.dart';

class Student {
  final String id;
  final DateTime createdAt;
  String name;
  int level;
  int exp;
  List<Progress> progress;
  DateTime? lastClaimed;
  int streakDay;
  String? profilePic;
  int coins;
  int nextTopic;

  Student(
      {required this.id,
      required this.createdAt,
      required this.name,
      this.level = 1,
      this.exp = 0,
      this.progress = const [],
      this.lastClaimed,
      this.streakDay = 0,
      this.profilePic,
      this.coins = 0,
      this.nextTopic = 1});

  // Convert from JSON (Supabase response)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        name: json['name'] as String,
        level: json['level'] as int,
        exp: json['exp'] as int,
        lastClaimed: json['last_claimed'] != null
            ? DateTime.parse(json['last_claimed'] as String)
            : null,
        streakDay: json['streak_day'] as int,
        profilePic: json['profile_picture'] as String?,
        coins: json['coins'] as int,
        nextTopic: json['next_topic'] as int);
  }

  // Convert to JSON (for sending to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'exp': exp,
      'last_claimed': lastClaimed?.toIso8601String(),
      'streak_day': streakDay,
      'profile_picture': profilePic,
      'coins': coins,
      'next_topic': nextTopic
      // Note: id and created_at are handled by Supabase
    };
  }

  // Create a copy of the user with modified fields
  Student copyWith(
      {String? id,
      DateTime? createdAt,
      String? name,
      int? level,
      int? exp,
      List<Progress>? progress,
      DateTime? lastClaimed,
      int? streakDay,
      String? profilePic,
      int? coins,
      int? nextTopic}) {
    return Student(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        level: level ?? this.level,
        exp: exp ?? this.exp,
        progress: progress ?? this.progress,
        lastClaimed: lastClaimed ?? this.lastClaimed,
        streakDay: streakDay ?? this.streakDay,
        profilePic: profilePic ?? this.profilePic,
        coins: coins ?? this.coins,
        nextTopic: nextTopic ?? this.nextTopic);
  }
}
