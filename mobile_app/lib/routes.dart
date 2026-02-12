import 'package:mobile_app/features/home/home_screen.dart';
import 'package:mobile_app/features/medications/add_medication_screen.dart';
import 'package:mobile_app/features/medications/medications_screen.dart';
import 'package:mobile_app/features/patients/patients_screen.dart';
import 'package:mobile_app/features/reminders/reminders_screen.dart';
import 'package:mobile_app/features/schedules/schedules_screen.dart';

getRoutes() {
  return {
    HomeScreen.route: (context) => const HomeScreen(),
    PatientsScreen.route: (context) => const PatientsScreen(),
    MedicationsScreen.route: (context) => const MedicationsScreen(),
    AddMedicationScreen.route: (context) => const AddMedicationScreen(),
    SchedulesScreen.route: (context) => const SchedulesScreen(),
    RemindersScreen.route: (context) => const RemindersScreen(),
  };
}
