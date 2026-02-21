import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import '../../models/reminder.dart';
import 'add_reminder_screen.dart';

// Mock reminder data
final ValueNotifier<List<Reminder>> reminders = ValueNotifier([
  Reminder(
    id: 1,
    medication: 'Lisinopril',
    patient: 'John Doe',
    scheduledTime: '08:00 AM',
    type: 'Morning',
    isEnabled: true,
    notificationCount: 3,
    icon: '📱',
  ),
  Reminder(
    id: 2,
    medication: 'Metformin',
    patient: 'John Doe',
    scheduledTime: '12:30 PM',
    type: 'Afternoon',
    isEnabled: true,
    notificationCount: 2,
    icon: '🔔',
  ),
  Reminder(
    id: 3,
    medication: 'Atorvastatin',
    patient: 'Jane Smith',
    scheduledTime: '09:00 PM',
    type: 'Evening',
    isEnabled: false,
    notificationCount: 0,
    icon: '🌙',
  ),
  Reminder(
    id: 4,
    medication: 'Aspirin',
    patient: 'Michael Johnson',
    scheduledTime: '08:00 AM',
    type: 'Morning',
    isEnabled: true,
    notificationCount: 1,
    icon: '⏰',
  ),
  Reminder(
    id: 5,
    medication: 'Blood Pressure Check',
    patient: 'John Doe',
    scheduledTime: '05:00 PM',
    type: 'Weekly',
    isEnabled: true,
    notificationCount: 2,
    icon: '💓',
  ),
]);

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});
  static const String route = '/reminders';

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Badge.count(
                count: reminders.value.where((r) => r.isEnabled).length,
                child: const Icon(Icons.notifications_rounded),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: reminders,
        builder: (context, value, child) {
          return reminders.value.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reminders set',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount:
                      reminders.value.length, // Added .value to fix access
                  itemBuilder: (context, index) {
                    final reminder = reminders.value[index]; // Added .value
                    return _ReminderCard(
                      reminder: reminder,
                      onUpdate: (updatedItem) {
                        setState(() {
                          reminders.value[index] = updatedItem;
                        });
                      },
                    );
                  },
                );
        }, // This closing brace for the builder was missing
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            Routes.addReminder,
          );
          if (result != null && result is Reminder) {
            setState(() {
              reminders.value = [...reminders.value, result];
            });
          }
        },
        heroTag: 'add_reminder_fab',
        backgroundColor: const Color(0xFF0066CC),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _ReminderCard extends StatefulWidget {
  final Reminder reminder;
  final Function(Reminder) onUpdate;

  const _ReminderCard({required this.reminder, required this.onUpdate});

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
  late bool _isEnabled;
  late Reminder _currentReminder;

  @override
  void initState() {
    super.initState();
    _currentReminder = widget.reminder;
    _isEnabled = widget.reminder.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(_currentReminder.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isEnabled ? typeColor.withOpacity(0.2) : Colors.grey[200]!,
          ),
          color: _isEnabled ? Colors.white : Colors.grey[50],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _currentReminder.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                // Reminder Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentReminder.medication,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              _currentReminder.type,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: typeColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_currentReminder.scheduledTime} • ${_currentReminder.patient}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Toggle
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                        _currentReminder = Reminder(
                            id: _currentReminder.id,
                            medication: _currentReminder.medication,
                            patient: _currentReminder.patient,
                            scheduledTime: _currentReminder.scheduledTime,
                            type: _currentReminder.type,
                            notificationCount:
                                _currentReminder.notificationCount);
                      });
                      widget.onUpdate(_currentReminder);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Reminder ${value ? 'enabled' : 'disabled'}',
                          ),
                        ),
                      );
                    },
                    activeThumbColor: typeColor,
                  ),
                ),
              ],
            ),
            if (_currentReminder.notificationCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_currentReminder.notificationCount} notification${_currentReminder.notificationCount > 1 ? 's' : ''} before the reminder',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final updatedReminder = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddReminderScreen(
                            existingReminder: widget.reminder,
                          ),
                        ),
                      );
                      if (updatedReminder != null &&
                          updatedReminder is Reminder) {
                        setState(() {
                          _currentReminder = updatedReminder;
                        });
                        widget.onUpdate(updatedReminder);
                      }
                    },
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test reminder sent!')),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Test'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Morning':
        return const Color(0xFFFFC107);
      case 'Afternoon':
        return const Color(0xFF00B4D8);
      case 'Evening':
        return const Color(0xFF9C27B0);
      case 'Weekly':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF0066CC);
    }
  }
}
