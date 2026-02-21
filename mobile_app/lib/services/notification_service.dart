import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS/Darwin settings
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'test_channel_id', // Must match the ID used in showTestNotification
    'Test Reminders',
    description: 'Used for testing medication alerts',
    importance: Importance.max,
  );

  // Resolve the Android plugin and create the channel
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // Create the channel before initializing
  await androidImplementation?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  // Request permissions for Android 13+
  await androidImplementation?.requestNotificationsPermission();
}

Future<void> showTestNotification(String medication, String patient) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'test_channel_id', // Required for Android 8.0+
    'Test Reminders', // User-visible channel name
    channelDescription: 'Used for testing medication alerts',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    id: 0,
    title: 'Medication Test: $medication',
    body: 'Reminder for $patient',
    notificationDetails: notificationDetails,
  );
}
