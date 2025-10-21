import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = IOSInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onSelectNotification: (payload) {
        // Handle notification tap
        debugPrint('Notification tapped: $payload');
      },
    );
  }

  /// Show a simple notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'civic_issues_channel',
      'Civic Issues',
      channelDescription: 'Notifications for civic issue updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = IOSNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
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

