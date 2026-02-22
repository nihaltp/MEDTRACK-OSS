import 'package:flutter/material.dart';
import 'package:mobile_app/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: const MedTrackApp(),
    ),
  );
}
