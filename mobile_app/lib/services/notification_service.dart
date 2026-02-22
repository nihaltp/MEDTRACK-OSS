import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton pattern to ensure only one instance of the service exists
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Define platform-specific settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/Darwin settings
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    // Define and create the Android Notification Channel (Required for Android 8.0+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'test_channel_id', // Must match the ID used in showTestNotification
      'Test Reminders',
      description: 'Used for testing medication alerts',
      importance: Importance.max,
    );

    // Resolve the Android plugin and create the channel
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Create the channel before initializing
    await androidImpl?.createNotificationChannel(channel);

    await _plugin.initialize(settings: initSettings);

    // Request permissions for Android 13+
    await androidImpl?.requestNotificationsPermission();
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

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch &
          0x7fffffff, // Unique ID for each notification so there will be no conflicts
      title: 'Medication Test: $medication',
      body: 'Reminder for $patient',
      notificationDetails: notificationDetails,
    );
  }
}
