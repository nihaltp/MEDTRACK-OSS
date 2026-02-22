import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/schedule_entry.dart';

class CsvExportService {
  static Future<void> exportAdherenceReport(List<ScheduleEntry> entries) async {
    final List<List<dynamic>> rows = [];

    // Header
    rows.add([
      'Date',
      'Medication Name',
      'Dosage',
      'Scheduled Time',
      'Taken (Yes/No)',
      'Notes'
    ]);

    // Data Rows
    for (var entry in entries) {
      rows.add([
        DateFormat('yyyy-MM-dd').format(entry.date),
        entry.medication,
        entry.dosage,
        entry.time,
        entry.status == 'Completed' ? 'Yes' : 'No',
        entry.notes,
      ]);
    }

    // Convert to CSV string
    String csvData = const ListToCsvConverter().convert(rows);

    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final String path = '${directory.path}/medication_adherence_report.csv';
    final File file = File(path);

    // Write CSV to file
    await file.writeAsString(csvData);

    // Share the file
    await Share.shareXFiles([XFile(path)], subject: 'Medication Adherence Report');
  }
}
