import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service responsible for handling local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initializes notification plugin and requests permission
  static Future<void> init() async {
    log('Initializing NotificationService', name: 'NotificationService');

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings: settings);

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    log(
      'NotificationService initialized & permission requested',
      name: 'NotificationService',
    );
  }

  /// Shows notification when monthly spending limit is exceeded
  static Future<void> showLimitExceeded(double spent, double limit) async {
    log(
      'Triggering limit exceeded notification',
      name: 'NotificationService',
      error: {'spent': spent, 'limit': limit},
    );

    const androidDetails = AndroidNotificationDetails(
      'monthly_limit_channel',
      'Monthly Limit Alerts',
      channelDescription: 'Alerts when monthly spending exceeds limit',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notifications.show(
      id: 1,
      title: 'Monthly Limit Exceeded',
      body:
          'You spent ₹${spent.toStringAsFixed(0)} (Limit ₹${limit.toStringAsFixed(0)})',
      notificationDetails: const NotificationDetails(android: androidDetails),
    );

    log('Limit exceeded notification displayed', name: 'NotificationService');
  }
}
