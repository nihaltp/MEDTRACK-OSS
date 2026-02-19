import 'package:flutter/material.dart';
import 'package:mobile_app/models/medication.dart';
import 'dart:math';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});
  static const String route = '/add_medication';

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _purposeController = TextEditingController();
  final _iconController = TextEditingController();

  List<bool> selectedDays = [true, true, true, true, true, true, true];
  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _purposeController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medication name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Enter medication name',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dosageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a dosage';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Enter dosage',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _frequencyController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the frequency';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Enter frequency',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _purposeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the purpose';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Enter purpose',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _iconController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Enter an Icon (e.g. 💊, 💉)',
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 7; i++)
                        GestureDetector(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color:
                                    selectedDays[i]
                                        ? Colors.greenAccent
                                        : Colors.grey.shade200,
                                size: 30,
                                semanticLabel: days[i],
                              ),
                              Text(
                                days[i][0],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              selectedDays[i] = !selectedDays[i];
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!selectedDays.contains(true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select at least one day')),
              );
              return;
            }

            final newMedication = Medication(
              id: Random().nextInt(100000), // Simple random ID
              name: _nameController.text,
              dosage: _dosageController.text,
              frequency: _frequencyController.text,
              frequencyWeekly: selectedDays,
              purpose: _purposeController.text,
              icon:
                  _iconController.text.isNotEmpty ? _iconController.text : '💊',
              color: Colors.primaries[Random().nextInt(
                Colors.primaries.length,
              )], // Random color
              nextDue: 'Scheduled', // Default value
              isActive: true,
            );

            Navigator.pop(context, newMedication);
          }
        },
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.check),
      ),
    );
  }
}
