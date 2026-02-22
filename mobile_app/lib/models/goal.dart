import 'package:uuid/uuid.dart';

class Milestone {
  final String id;
  final String title;
  bool isCompleted;

  Milestone({
    String? id,
    required this.title,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final List<Milestone> milestones;
  final String badgeIcon;

  Goal({
    String? id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.milestones,
    this.badgeIcon = '🏆', // Default badge
  }) : id = id ?? const Uuid().v4();

  bool get isCompleted {
    if (milestones.isEmpty) return false;
    return milestones.every((m) => m.isCompleted);
  }

  double get progress {
    if (milestones.isEmpty) return 0.0;
    final completed = milestones.where((m) => m.isCompleted).length;
    return completed / milestones.length;
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      badgeIcon: json['badgeIcon'] as String? ?? '🏆',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': targetDate.toIso8601String(),
      'milestones': milestones.map((e) => e.toJson()).toList(),
      'badgeIcon': badgeIcon,
    };
  }
}
