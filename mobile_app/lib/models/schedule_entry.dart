import 'package:flutter/material.dart';

class ScheduleEntry {
  final String medication;
  final String dosage;
  final DateTime date;
  final String time;
  final String patient;
  String status;
  Color statusColor;
  final String notes;
  int id;
  final String icon;

  ScheduleEntry({
    required this.medication,
    required this.dosage,
    required this.date,
    required this.time,
    required this.patient,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.id,
    this.notes = '',
  });
}
