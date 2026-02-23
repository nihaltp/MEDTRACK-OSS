import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/services/notification_service.dart';
import '../../models/reminder.dart';
import 'add_reminder_screen.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});
  static const String route = '/reminders';

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final ApiService _apiService = ApiService();
  List<Reminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    setState(() => _isLoading = true);
    try {
      final List<dynamic> data = await _apiService.get('/reminders/');
      setState(() {
        _reminders = data.map((json) => Reminder.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reminders: $e')),
        );
      }
    }
  }

  Future<void> _deleteReminder(String id) async {
    try {
      await _apiService.delete('/reminders/$id');
      setState(() {
        _reminders.removeWhere((r) => r.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete reminder: $e')),
        );
      }
    }
  }

  Future<void> _editReminder(Reminder reminder) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(reminderToEdit: reminder),
      ),
    );

    if (result != null && result is Reminder) {
      try {
        final data = await _apiService.patch('/reminders/${reminder.id}', result.toJson());
        final updatedReminder = Reminder.fromJson(data);
        setState(() {
          final index = _reminders.indexWhere((r) => r.id == reminder.id);
          if (index != -1) {
            _reminders[index] = updatedReminder;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reminder updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update reminder: $e')),
          );
        }
      }
    }
  }

  Future<void> _snoozeReminder(String id) async {
    try {
      final data = await _apiService.post('/reminders/$id/snooze', {});
      final updatedReminder = Reminder.fromJson(data);
      setState(() {
        final index = _reminders.indexWhere((r) => r.id == id);
        if (index != -1) {
          _reminders[index] = updatedReminder;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Snoozed for 10 minutes (Count: ${updatedReminder.snoozeCount})')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to snooze: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _fetchReminders,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = _reminders[index];
                    return _ReminderCard(
                      reminder: reminder,
                      onDelete: () => _deleteReminder(reminder.id),
                      onEdit: () => _editReminder(reminder),
                      onSnooze: () => _snoozeReminder(reminder.id),
                      onUpdate: (updatedItem) async {
                        try {
                           await _apiService.patch('/reminders/${reminder.id}', updatedItem.toJson());
                           setState(() {
                             _reminders[index] = updatedItem;
                           });
                        } catch(e) {
                          if(mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Update failed: $e')),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, Routes.addReminder);
          if (result != null && result is Reminder) {
            try {
              final data = await _apiService.post('/reminders/', result.toJson());
              final newReminder = Reminder.fromJson(data);
              setState(() {
                _reminders.add(newReminder);
              });
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create reminder: $e')),
                );
              }
            }
          }
        },
        heroTag: 'add_reminder_fab',
        backgroundColor: const Color(0xFF0066CC),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSnooze;
  final Function(Reminder) onUpdate;

  const _ReminderCard({
    required this.reminder,
    required this.onDelete,
    required this.onEdit,
    required this.onSnooze,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(reminder.type);
    final isEnabled = reminder.isEnabled;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? typeColor.withOpacity(0.2) : Colors.grey[200]!,
          ),
          color: isEnabled ? Colors.white : Colors.grey[50],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    reminder.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.medication,
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
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: Text(
                              reminder.type,
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
                              '${reminder.scheduledTime} • ${reminder.patient}',
                              style: const TextStyle(
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
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isEnabled,
                    onChanged: (value) {
                      onUpdate(Reminder(
                        id: reminder.id,
                        medication: reminder.medication,
                        patient: reminder.patient,
                        scheduledTime: reminder.scheduledTime,
                        type: reminder.type,
                        isEnabled: value,
                        notificationCount: reminder.notificationCount,
                        icon: reminder.icon,
                        snoozeCount: reminder.snoozeCount,
                        lastSnoozedAt: reminder.lastSnoozedAt,
                        remindAt: reminder.remindAt,
                      ));
                    },
                    activeThumbColor: typeColor,
                  ),
                ),
              ],
            ),
            if (reminder.snoozeCount > 0) ...[
               const SizedBox(height: 12),
               Container(
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.snooze_rounded, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Snoozed ${reminder.snoozeCount} time${reminder.snoozeCount > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSnooze,
                    icon: const Icon(Icons.snooze_rounded, size: 16),
                    label: const Text('Snooze'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogIntakeDialog(context, reminder),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Log'),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogIntakeDialog(BuildContext context, Reminder reminder) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Medication Intake',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Did ${reminder.patient} take ${reminder.medication} today at ${reminder.scheduledTime}?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged as Taken')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Taken'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged as Skipped')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Skipped'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
