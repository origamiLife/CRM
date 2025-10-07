import 'dart:io';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  ///  State fields for stateful widgets in this page.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // Model for webNav component.
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotifications() async {
    if(_isInitialized) return;

    // 1. กำหนด Timezone ก่อน Initialize
    configureLocalTimezone(); // เรียกฟังก์ชันกำหนด Timezone

    // ... (โค้ด Android/iOS InitializationSettings เดิม) ...
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // init
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _isInitialized = true; // ตั้งค่าเป็น true เมื่อ Initialize เสร็จ
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'origami_channel', // channel id
      'origami', // channel name
      channelDescription: 'Detail notification channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker text',
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,  // ใส่ title
      body,   // ใส่ body
      platformDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'origami_channel', // channel id ต้องตรงกับ showNotification
      'origami', // channel name
      channelDescription: 'Detail notification channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker text',
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // matchDateTimeComponents: DateTimeComponents.time, // เพื่อให้ซ้ำทุกวันเวลาเดียวกัน
    );
  }


  void configureLocalTimezone() {
    tz.TZDateTime.now(tz.local);
    final String timeZoneName = 'Asia/Bangkok'; // หรือใช้ flutter_native_timezone เพื่อหา Timezone ปัจจุบันของอุปกรณ์
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  // Future<void> scheduleNotification(DateTime scheduledTime) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     1, // ID (ต้องไม่ซ้ำ)
  //     'แจ้งเตือนตามเวลา',
  //     'การแจ้งเตือนที่กำหนดไว้ล่วงหน้า',
  //     tz.TZDateTime.from(scheduledTime, tz.local), // ใช้ tz.local ที่กำหนดไว้
  //     const NotificationDetails(),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     // uiLocalNotificationDateInterpretation:
  //     // UILocalNotificationDateInterpretation.absoluteTime,
  //     // payload: 'scheduled_notification_data',
  //   );
  // }

  // ยกเลิกการแจ้งเตือนด้วย ID เฉพาะ
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

// ยกเลิกการแจ้งเตือนทั้งหมด
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

