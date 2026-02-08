import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/patients/patients_screen.dart';
import 'features/medications/medications_screen.dart';
import 'features/medications/add_medication_screen.dart';
import 'features/schedules/schedules_screen.dart';
import 'features/reminders/reminders_screen.dart';
import 'theme/app_theme.dart';

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedTrack OSS',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/patients': (context) => const PatientsScreen(),
        '/medications': (context) => const MedicationsScreen(),
        '/add_medication': (context) => const AddMedicationScreen(),
        '/schedules': (context) => const SchedulesScreen(),
        '/reminders': (context) => const RemindersScreen(),
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
