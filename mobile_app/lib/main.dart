import 'package:flutter/material.dart';
import 'package:mobile_app/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(const MedTrackApp());
}
