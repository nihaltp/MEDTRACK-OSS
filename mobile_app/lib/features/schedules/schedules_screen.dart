import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/models/reminder.dart';
import 'package:mobile_app/models/schedule_entry.dart';
import 'package:mobile_app/features/reminders/reminders_screen.dart';
import 'package:mobile_app/routes.dart';
import 'package:mobile_app/services/csv_export_service.dart';
import 'package:intl/intl.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});
  static const String route = '/schedules';

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  // Date filter range
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  // Mock schedule data updated with dates
  final List<ScheduleEntry> schedules = [
    ScheduleEntry(
      id: 1,
      medication: 'Lisinopril',
      dosage: '10 mg',
      date: DateTime.now(),
      time: '08:00 AM',
      patient: 'John Doe',
      status: 'Completed',
      statusColor: const Color(0xFF4CAF50),
      icon: '💊',
      notes: 'Taken with water',
    ),
    ScheduleEntry(
      id: 2,
      medication: 'Metformin',
      dosage: '500 mg',
      date: DateTime.now(),
      time: '12:30 PM',
      patient: 'John Doe',
      status: 'Pending',
      statusColor: const Color(0xFFFFC107),
      icon: '💉',
    ),
    ScheduleEntry(
      id: 3,
      medication: 'Lisinopril',
      dosage: '10 mg',
      date: DateTime.now(),
      time: '08:00 PM',
      patient: 'John Doe',
      status: 'Upcoming',
      statusColor: const Color(0xFF00B4D8),
      icon: '💊',
    ),
    ScheduleEntry(
      id: 4,
      medication: 'Atorvastatin',
      dosage: '20 mg',
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '09:00 PM',
      patient: 'Jane Smith',
      status: 'Completed',
      statusColor: const Color(0xFF4CAF50),
      icon: '⚕️',
    ),
    ScheduleEntry(
      id: 5,
      medication: 'Aspirin',
      dosage: '81 mg',
      date: DateTime.now().add(const Duration(days: 1)),
      time: 'Tomorrow 08:00 AM',
      patient: 'Michael Johnson',
      status: 'Upcoming',
      statusColor: const Color(0xFF00B4D8),
      icon: '💊',
    ),
  ];

  void markAsTaken(int id) {
    setState(() {
      final index = schedules.indexWhere((s) => s.id == id);
      if (index != -1) {
        schedules[index].status = 'Completed';
        schedules[index].statusColor = const Color(0xFF4CAF50);
      }
    });
  }

  String _filterValue = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredSchedules = _filterValue == 'All'
        ? schedules
        : schedules.where((s) => s.status == _filterValue).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Schedules'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _exportCsv(context),
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    label: 'All',
                    isActive: _filterValue == 'All',
                    color: const Color(0xFF0066CC),
                    onTap: () {
                      setState(() => _filterValue = 'All');
                    },
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Completed',
                    isActive: _filterValue == 'Completed',
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      setState(() => _filterValue = 'Completed');
                    },
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Pending',
                    isActive: _filterValue == 'Pending',
                    color: const Color(0xFFFFC107),
                    onTap: () {
                      setState(() => _filterValue = 'Pending');
                    },
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Upcoming',
                    isActive: _filterValue == 'Upcoming',
                    color: const Color(0xFF00B4D8),
                    onTap: () {
                      setState(() => _filterValue = 'Upcoming');
                    },
                  ),
                ],
              ),
            ),
          ),
          // Schedules List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredSchedules.length,
              itemBuilder: (context, index) {
                final schedule = filteredSchedules[index];
                return _ScheduleCard(
                  schedule: schedule,
                  onMarkAsTaken: () => markAsTaken(schedule.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    // Filter by date range
    final filtered = schedules.where((s) {
      return s.date.isAfter(_startDate.subtract(const Duration(seconds: 1))) &&
          s.date.isBefore(_endDate.add(const Duration(seconds: 1)));
    }).toList();

    if (filtered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data found for the selected range')),
      );
      return;
    }

    try {
      await CsvExportService.exportAdherenceReport(filtered);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.grey[300]!,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? color : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleEntry schedule;
  final VoidCallback onMarkAsTaken;

  const _ScheduleCard({required this.schedule, required this.onMarkAsTaken});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  decoration: BoxDecoration(
                    color: schedule.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    schedule.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                // Schedule Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.medication,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.dosage,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  decoration: BoxDecoration(
                    color: schedule.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    schedule.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: schedule.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    schedule.time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    schedule.patient,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Action Button
            schedule.status == 'Pending'
                ? ElevatedButton.icon(
                    onPressed: () {
                      onMarkAsTaken();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Medication marked as taken!')),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Mark as Taken'),
                  )
                : schedule.status == 'Upcoming'
                    ? OutlinedButton.icon(
                        onPressed: () {
                          final String type = schedule.time.contains('AM')
                              ? 'Morning'
                              : DateFormat("hh:mm a")
                                          .parse(schedule.time)
                                          .hour <
                                      6
                                  ? 'Afternoon'
                                  : 'Evening';
                          final newReminder = Reminder(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            medication: schedule.medication,
                            patient: schedule.patient,
                            scheduledTime: schedule.time,
                            type: type,
                            isEnabled: true,
                            notificationCount: 0,
                            icon: schedule.icon,
                            remindAt: DateFormat("hh:mm a")
                                .parse(schedule.time)
                                .add(const Duration(minutes: -15)),
                          );
                          setReminder(context, newReminder);
                        },
                        icon: const Icon(Icons.notifications_rounded, size: 18),
                        label: const Text('Set Reminder'),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: schedule.statusColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: schedule.statusColor,
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }

  Future<void> setReminder(BuildContext context, Reminder newReminder) async {
    final updatedReminder = await Navigator.pushNamed(
        context, Routes.addReminder,
        arguments: newReminder);

    if (updatedReminder != null && updatedReminder is Reminder) {
      reminders.value = [...reminders.value, updatedReminder];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Reminder set for ${updatedReminder.scheduledTime}')),
      );
    }
  }
}
