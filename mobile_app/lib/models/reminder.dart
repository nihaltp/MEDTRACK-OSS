class Reminder {
  final String id;
  final String medication;
  final String patient;
  final String scheduledTime;
  final String type;
  final bool isEnabled;
  final int notificationCount;
  final String icon;
  final int snoozeCount;
  final DateTime? lastSnoozedAt;
  final DateTime remindAt;

  Reminder({
    required this.id,
    required this.medication,
    required this.patient,
    required this.scheduledTime,
    required this.type,
    this.isEnabled = true,
    required this.notificationCount,
    this.icon = '🔔',
    this.snoozeCount = 0,
    this.lastSnoozedAt,
    required this.remindAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      medication: json['medication'] as String,
      patient: json['patient'] as String,
      scheduledTime: json['scheduledTime'] as String,
      type: json['type'] as String,
      isEnabled: json['status'] != 'failed' && (json['isEnabled'] as bool? ?? true),
      notificationCount: json['notificationCount'] as int? ?? 0,
      icon: json['icon'] as String? ?? '🔔',
      snoozeCount: json['snooze_count'] as int? ?? 0,
      lastSnoozedAt: json['last_snoozed_at'] != null 
          ? DateTime.parse(json['last_snoozed_at'] as String) 
          : null,
      remindAt: DateTime.parse(json['remind_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication': medication,
      'patient': patient,
      'scheduledTime': scheduledTime,
      'type': type,
      'isEnabled': isEnabled,
      'notificationCount': notificationCount,
      'icon': icon,
      'snooze_count': snoozeCount,
      'last_snoozed_at': lastSnoozedAt?.toIso8601String(),
      'remind_at': remindAt.toIso8601String(),
    };
  }
}
