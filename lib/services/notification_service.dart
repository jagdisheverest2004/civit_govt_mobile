import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle notification background tap
  debugPrint('Notification tapped in background: ${notificationResponse.payload}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  static Future<void> initialize() async {
    final notificationService = NotificationService();
    await notificationService._initializeSettings();
  }

  Future<void> _initializeSettings() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Request permissions for iOS
    final DarwinInitializationSettings darwinInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'civic_issues',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('view', 'View Issue'),
          ],
        ),
      ],
    );

    // Initialize settings for all platforms
    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      initSettings,
      // Handle notification taps
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        switch (response.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            debugPrint('Notification tapped');
            break;
          case NotificationResponseType.selectedNotificationAction:
            debugPrint('Notification action tapped: ${response.actionId}');
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request permissions for Android (API level >= 33)
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = 
          _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
          
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }
}
  /// Show a simple notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'civic_issues_channel', // channel ID
      'Civic Issues', // channel name
      channelDescription: 'Notifications for civic issue updates',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'Civic Issue Update',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('view', 'View Issue'),
      ],
    );

    final DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'civic_issues',
      threadIdentifier: 'civic_issues',
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Show notification for issue status update
  Future<void> notifyIssueStatusUpdate({
    required String issueTitle,
    required String newStatus,
  }) async {
    await showNotification(
      title: 'Issue Status Updated',
      body: '$issueTitle is now $newStatus',
      payload: 'issue_status_update',
    );
  }

  /// Show notification for new issue nearby
  Future<void> notifyNewIssueNearby({
    required String issueTitle,
    required String location,
  }) async {
    await showNotification(
      title: 'New Issue Nearby',
      body: '$issueTitle in $location',
      payload: 'new_issue_nearby',
    );
  }

  /// Show notification for officer assignment
  Future<void> notifyOfficerAssigned({
    required String issueTitle,
    required String officerName,
  }) async {
    await showNotification(
      title: 'Officer Assigned',
      body: '$officerName has been assigned to $issueTitle',
      payload: 'officer_assigned',
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}

