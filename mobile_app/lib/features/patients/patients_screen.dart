import 'package:flutter/material.dart';
import '../../models/patient.dart';
import 'widgets/patient_card.dart';
import 'widgets/patient_details_view.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final List<Patient> _patients = [
    Patient(
      id: 'P001',
      name: 'Rajesh Kumar',
      age: 45,
      gender: 'Male',
      condition: 'Hypertension',
      status: 'Stable',
      lastVisit: DateTime.now().subtract(const Duration(days: 2)),
      phoneNumber: '+91 98765 43210',
    ),
    Patient(
      id: 'P002',
      name: 'Priya Sharma',
      age: 62,
      gender: 'Female',
      condition: 'Type 2 Diabetes',
      status: 'Recovering',
      lastVisit: DateTime.now().subtract(const Duration(days: 5)),
      phoneNumber: '+91 87654 32109',
    ),
    Patient(
      id: 'P003',
      name: 'Amit Patel',
      age: 28,
      gender: 'Male',
      condition: 'Asthma',
      status: 'Stable',
      lastVisit: DateTime.now().subtract(const Duration(days: 12)),
      phoneNumber: '+91 76543 21098',
    ),
    Patient(
      id: 'P004',
      name: 'Suresh Iyer',
      age: 75,
      gender: 'Male',
      condition: 'Post-Surgery (Knee)',
      status: 'Critical',
      lastVisit: DateTime.now().subtract(const Duration(hours: 4)),
      phoneNumber: '+91 65432 10987',
    ),
    Patient(
      id: 'P005',
      name: 'Lakshmi Narayan',
      age: 54,
      gender: 'Female',
      condition: 'Migraine',
      status: 'Stable',
      lastVisit: DateTime.now().subtract(const Duration(days: 20)),
      phoneNumber: '+91 99887 76655',
    ),
  ];

  String _searchQuery = '';

  List<Patient> get _filteredPatients {
    if (_searchQuery.isEmpty) return _patients;
    return _patients.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.condition.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Patients',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Theme.of(context).primaryColor,
            onPressed: () {
             
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: _filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = _filteredPatients[index];
                return PatientCard(
                  patient: patient,
                  onTap: () => _navigateToPatientDetails(patient),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search patients, conditions...',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[500],
              ),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _navigateToPatientDetails(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsView(patient: patient),
      ),
    );
  }
}
