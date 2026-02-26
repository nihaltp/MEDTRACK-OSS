import 'package:flutter/material.dart';
import 'package:mobile_app/models/dependent.dart';
import 'package:mobile_app/routes.dart';
import 'package:mobile_app/services/profile_provider.dart';
import '../../models/medication.dart';
import '../../models/audit_log_entry.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/features/medications/widgets/medication_card.dart';
import 'package:mobile_app/features/medications/widgets/medication_error_boundary.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});
  static const String route = '/medications';

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  // Mock medication data
  List<Medication> medications = [
    Medication(
      id: 1,
      name: 'Lisinopril',
      dosage: '10 mg',
      frequency: 'Once daily',
      frequencyWeekly: [true, true, true, true, true, true, true],
      purpose: 'Blood pressure control',
      icon: '💊',
      color: const Color(0xFFFF6B6B),
      nextDue: '2:00 PM',
      isActive: true,
      pillsRemaining: 30,
    ),
    Medication(
      id: 2,
      name: 'Metformin',
      dosage: '500 mg',
      frequency: 'Twice daily',
      frequencyWeekly: [true, false, true, false, true, false, true],
      purpose: 'Diabetes management',
      icon: '💉',
      color: const Color(0xFF00B4D8),
      nextDue: '1:30 PM',
      isActive: true,
      pillsRemaining: 45,
    ),
    Medication(
      id: 3,
      name: 'Atorvastatin',
      dosage: '20 mg',
      frequency: 'Once daily',
      frequencyWeekly: [true, true, true, true, true, true, true],
      purpose: 'Cholesterol control',
      icon: '⚕️',
      color: const Color(0xFF4CAF50),
      nextDue: '8:00 PM',
      isActive: true,
      pillsRemaining: 15,
    ),
    Medication(
      id: 4,
      name: 'Aspirin',
      dosage: '81 mg',
      frequency: 'Once daily',
      frequencyWeekly: [true, true, true, true, true, true, true],
      purpose: 'Blood thinner',
      icon: '💊',
      color: const Color(0xFFFFC107),
      nextDue: 'Tomorrow 8:00 AM',
      isActive: false,
      pillsRemaining: 5,
    ),
  ];

  String _filterValue = 'All';
  bool _isLoading = false;
  bool _hasError = false;

  void _fetchMedications() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    // Simulate loading/error detection
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = false; // Set to true to test error boundary
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeds = _filterValue == 'All'
        ? medications
        : _filterValue == 'Active'
            ? medications.where((m) => m.isActive).toList()
            : medications.where((m) => !m.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isActive: _filterValue == 'All',
                    onTap: () {
                      setState(() => _filterValue = 'All');
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Active',
                    isActive: _filterValue == 'Active',
                    onTap: () {
                      setState(() => _filterValue = 'Active');
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Inactive',
                    isActive: _filterValue == 'Inactive',
                    onTap: () {
                      setState(() => _filterValue = 'Inactive');
                    },
                  ),
                ],
              ),
            ),
          ),
          // Medications List
          Expanded(
            child: MedicationErrorBoundary(
              hasError: _hasError,
              onRetry: _fetchMedications,
              child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                final activeProfileId = profileProvider.activeProfile?.id;

                // Mock filtering logic for medications
                final profileMeds = filteredMeds.where((m) {
                  bool matchesProfile = false;
                  if (activeProfileId == 'D001' && (m.id == 1 || m.id == 2)) {
                    matchesProfile = true;
                  }
                  if (activeProfileId == 'D002' && m.id == 3) {
                    matchesProfile = true;
                  }
                  if (activeProfileId == 'D003' && m.id == 4) {
                    matchesProfile = true;
                  }

                  if ([1, 2, 3, 4].contains(m.id) == false) {
                    matchesProfile = true;
                  }
                  return matchesProfile;
                }).toList();

                if (profileMeds.isEmpty) {
                  return const Center(
                      child: Text("No medications found for this dependent."));
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: profileMeds.length,
                  itemBuilder: (context, index) {
                    final medication = profileMeds[index];
                    return MedicationCard(
                      medication: medication,
                      onEdit: () => _editMedication(context, medication),
                      onTakeDose: () {
                        setState(() {
                          if (medication.pillsRemaining > 0) {
                            medication.pillsRemaining--;

                            // Create Audit Log
                            final primaryCaregiverId = profileProvider
                                .activeProfile?.primaryCaregiverId;
                            final primaryCaregiver = profileProvider.profiles
                                .firstWhere((p) => p.id == primaryCaregiverId,
                                    orElse: () => Dependent(
                                        id: '-1',
                                        name: 'Primary Caregiver',
                                        relation: 'Caregiver'));
                            final caregiverName = primaryCaregiver.name;
                            final aLog = AuditLogEntry(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                timestamp: DateTime.now(),
                                action:
                                    "Administered ${medication.dosage} of ${medication.name}",
                                caregiverName: caregiverName,
                                type: "medication");

                            // Attach to active dependent profile
                            if (profileProvider.activeProfile != null) {
                              profileProvider.activeProfile!.activityFeed
                                  .add(aLog);
                            }

                            // Show a quick snackbar confirmation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Dose taken. ${medication.pillsRemaining} pills remaining."),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Cannot take dose: Out of pills!"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        });
                      },
                    );
                  },
                );
              }),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            Routes.addMedication,
          );

          if (result != null && result is Medication) {
            setState(() {
              medications.add(result);
              // Reset filter to 'All' or 'Active' to ensure the new med is visible if it matches
              if (_filterValue == 'Inactive') {
                _filterValue = 'All';
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${result.name} added successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        heroTag: 'add_medication_fab',
        backgroundColor: const Color(0xFF0066CC),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _editMedication(
      BuildContext context, Medication medicationToEdit) async {
    final updatedMedication = await Navigator.pushNamed(
        context, Routes.addMedication,
        arguments: medicationToEdit);

    if (updatedMedication != null && updatedMedication is Medication) {
      setState(() {
        int index = medications.indexWhere((m) => m.id == updatedMedication.id);
        if (index != -1) {
          medications[index] = updatedMedication;
        }
      });
    } else if (updatedMedication == 'delete') {
      setState(() {
        medications.removeWhere((m) => m.id == medicationToEdit.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medicationToEdit.name} deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0066CC) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF0066CC) : Colors.grey[300]!,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}
