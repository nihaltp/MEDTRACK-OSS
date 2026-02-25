import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/reminder.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminderToEdit;
  const AddReminderScreen({super.key, this.reminderToEdit});
  static const String route = '/add_reminder';

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  bool get isEditing => widget.reminderToEdit != null;

  final _formKey = GlobalKey<FormState>();
  String _medicationName = '';
  String _patientName = '';
  TimeOfDay _scheduledTime = TimeOfDay.now();
  final List<String> _type = ['Morning', 'Afternoon', 'Evening', 'Weekly'];
  bool _isEnabled = true;
  int _notificationCount = 1;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final reminder = widget.reminderToEdit!;
      _medicationName = reminder.medication;
      _patientName = reminder.patient;
      _selectedType = reminder.type;
      _isEnabled = reminder.isEnabled;
      _notificationCount = reminder.notificationCount;
      _scheduledTime = _parseTime(reminder.scheduledTime);
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final timeMatch =
          RegExp(r'\d{1,2}:\d{2}\s?[APap][Mm]').firstMatch(timeString);
      if (timeMatch == null) {
        throw const FormatException("No time found");
      }

      final timePart = timeMatch.group(0)!;
      final dateTime = DateFormat("hh:mm a").parse(timePart);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  DateTime _calculateRemindAt(TimeOfDay time) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              isEditing ? "Edit Reminder" : "Add Reminder",
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _patientName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Patient Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: "Patient Name",
                        ),
                        onSaved: (value) => _patientName = value ?? '',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: _medicationName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Medication Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(12)),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: "Medication Name"),
                        onSaved: (value) => _medicationName = value ?? '',
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Please select a type";
                          }
                          return null;
                        },
                        value: _selectedType,
                        hint: const Text("Type"),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _type.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value as String;
                          });
                        },
                        onSaved: (value) => _selectedType = value,
                      ),
                      const SizedBox(height: 15),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: const Text("Scheduled Time",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                )),
                            leading: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.blue,
                            ),
                            subtitle: Text(
                              _scheduledTime.format(context),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: TextButton(
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: _scheduledTime,
                                          initialEntryMode:
                                              TimePickerEntryMode.dial);
                                  if (timeOfDay != null) {
                                    setState(() {
                                      _scheduledTime = timeOfDay;
                                    });
                                  }
                                },
                                child: const Text(
                                  "CHANGE",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ),
                      const SizedBox(height: 15),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: const Text(
                            "Notifications",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          leading: const Icon(Icons.notification_add),
                          iconColor: Colors.blue,
                          subtitle: Text(
                              "$_notificationCount ${_notificationCount == 1 ? 'notification' : 'notifications'} before"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_notificationCount > 1) {
                                    setState(() {
                                      _notificationCount--;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                "$_notificationCount",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_notificationCount < 5) {
                                    setState(() {
                                      _notificationCount++;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedType != null) {
                            _formKey.currentState!.save();
                            final reminderId = widget.reminderToEdit?.id ?? "";
                            
                            final updatedReminder = Reminder(
                              id: reminderId,
                              medication: _medicationName,
                              patient: _patientName,
                              scheduledTime: _scheduledTime.format(context),
                              type: _selectedType!,
                              isEnabled: _isEnabled,
                              notificationCount: _notificationCount,
                              remindAt: _calculateRemindAt(_scheduledTime),
                              snoozeCount: widget.reminderToEdit?.snoozeCount ?? 0,
                              lastSnoozedAt: widget.reminderToEdit?.lastSnoozedAt,
                            );

                            Navigator.pop(context, updatedReminder);
                          }
                        },
                        child: Text(isEditing
                            ? "Update Reminder"
                            : "Add Reminder"),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
