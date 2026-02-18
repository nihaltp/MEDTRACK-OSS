import 'appointment.dart';

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
  });

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
    };
  }
}
