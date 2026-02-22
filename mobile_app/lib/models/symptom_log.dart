import 'package:uuid/uuid.dart';

class SymptomLog {
  final String id;
  final String date;
  final String symptomName;
  final int severity;
  final String notes;

  SymptomLog({
    String? id,
    required this.date,
    required this.symptomName,
    required this.severity,
    this.notes = '',
  }) : id = id ?? const Uuid().v4();

  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    return SymptomLog(
      id: json['id'] as String,
      date: json['date'] as String,
      symptomName: json['symptomName'] as String,
      severity: json['severity'] as int,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'symptomName': symptomName,
      'severity': severity,
      'notes': notes,
    };
  }
}
