import 'package:flutter/material.dart';
import 'package:mobile_app/features/patients/add_patient_screen.dart';
import 'package:mobile_app/features/patients/widgets/patient_details_view.dart';
import 'package:mobile_app/models/patient.dart';
import 'package:mobile_app/routes.dart';
import 'theme/app_theme.dart';

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedTrack OSS',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.home,
      routes: getRoutes(),
      onGenerateRoute: (settings) {
        if (settings.name == Routes.addPatient) {
          return MaterialPageRoute<Patient>(
            builder: (context) => const AddPatientScreen(),
          );
        }
        if (settings.name == Routes.patientDetails) {
          final patient = settings.arguments as Patient;
          return MaterialPageRoute(
            builder: (context) => PatientDetailsView(patient: patient),
          );
        }
        
        // fallback for undefined routes
        return null;
      },
    );
  }

  ThemeData _buildTheme() {
    const primaryColor = Color(0xFF0066CC);
    const secondaryColor = Color(0xFF00B4D8);
    const accentColor = Color(0xFFFF6B6B);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIconColor: primaryColor,
      ),
    );
  }
}
