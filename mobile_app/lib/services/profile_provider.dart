import 'package:flutter/material.dart';
import '../models/dependent.dart';
import '../models/emergency_profile.dart';

class ProfileProvider with ChangeNotifier {
  // Mock data for caregivers
  final List<Dependent> _profiles = [
    Dependent(
      id: 'D001',
      name: 'Rajesh Kumar',
      relation: 'Self',
      emergencyProfile: EmergencyProfile(
          bloodType: 'O+',
          allergies: ['Penicillin', 'Peanuts'],
          emergencyContactName: 'Priya Sharma',
          emergencyContactPhone: '+91 87654 32109'),
      primaryCaregiverId: 'D002', // Son is primary caregiver
    ),
    Dependent(
      id: 'D002',
      name: 'Aarav Kumar',
      relation: 'Son',
      emergencyProfile: EmergencyProfile(
          bloodType: 'A-',
          allergies: ['Latex'],
          emergencyContactName: 'Rajesh Kumar',
          emergencyContactPhone: '+91 98765 43210'),
      primaryCaregiverId: "D001", // father is primary caregiver
    ),
    Dependent(
        id: 'D003',
        name: 'Meera Devi',
        relation:
            'Mother'), // Intentionally has no emergency profile for testing
  ];

  Dependent? _activeProfile;

  ProfileProvider() {
    if (_profiles.isNotEmpty) {
      _activeProfile = _profiles.first;
    }
  }

  List<Dependent> get profiles => _profiles;
  Dependent? get activeProfile => _activeProfile;

  void setActiveProfile(String id) {
    try {
      _activeProfile = _profiles.firstWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      // Profile not found
    }
  }

  void addProfile(Dependent profile) {
    _profiles.add(profile);
    notifyListeners();
  }
}
