import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String patientId;
  final DateTime date;
  final TimeOfDay time;
  final String type;
  final String? notes;
  final String status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.date,
    required this.time,
    required this.type,
    this.notes,
    this.status = 'Scheduled',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'type': type,
      'notes': notes,
      'status': status,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      type: json['type'],
      notes: json['notes'],
      status: json['status'],
    );
  }
}
