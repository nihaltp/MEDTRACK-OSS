import 'package:mobile_app/features/medications/medications_screen.dart';
import 'package:mobile_app/features/patients/patients_screen.dart';
import 'package:mobile_app/features/schedules/schedules_screen.dart';

class ApiConstants {
  // Base URL for the FastAPI backend
  // Assume running locally on default FastAPI port
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // Endpoints
  static final String patients = PatientsScreen.route;
  static final String medications = MedicationsScreen.route;
  static final String schedules = SchedulesScreen.route;
}
