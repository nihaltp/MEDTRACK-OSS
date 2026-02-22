import 'appointment.dart';
import 'patient_note.dart';
import 'medication_log.dart';
import 'goal.dart';
import 'symptom_log.dart';

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String condition;
  final String status; // e.g., "Critical", "Stable", "Recovering"
  final DateTime lastVisit;
  final String phoneNumber;
  final List<Appointment> appointments;
  final List<PatientNote> notes;
  final List<MedicationLog> medicationLogs;
  final List<Goal> goals;
  final List<SymptomLog> symptomLogs;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.condition,
    this.status = 'Stable',
    required this.lastVisit,
    this.phoneNumber = 'N/A',
    this.appointments = const [],
    List<PatientNote>? notes,
    this.medicationLogs = const [],
    this.goals = const [],
    this.symptomLogs = const [],
  }) : notes = List<PatientNote>.from(notes ?? []);

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      condition: json['condition'] as String,
      status: json['status'] as String? ?? 'Stable',
      lastVisit: DateTime.parse(json['lastVisit'] as String),
      phoneNumber: json['phoneNumber'] as String? ?? 'N/A',
      appointments: (json['appointments'] as List<dynamic>?)
          ?.map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => PatientNote.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      medicationLogs: (json['medicationLogs'] as List<dynamic>?)
          ?.map((e) => MedicationLog.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      goals: (json['goals'] as List<dynamic>?)
          ?.map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      symptomLogs: (json['symptomLogs'] as List<dynamic>?)
          ?.map((e) => SymptomLog.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'condition': condition,
      'status': status,
      'lastVisit': lastVisit.toIso8601String(),
      'phoneNumber': phoneNumber,
      'appointments': appointments.map((e) => e.toJson()).toList(),
      'notes': notes.map((e) => e.toJson()).toList(),
      'medicationLogs': medicationLogs.map((e) => e.toJson()).toList(),
      'goals': goals.map((e) => e.toJson()).toList(),
      'symptomLogs': symptomLogs.map((e) => e.toJson()).toList(),
    };
  }
}
