import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    '0',
    'Schedulers',
    channelDescription: 'Sleep time scheduler notifications. ',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? tzName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName!));
  }

  Future<void> init() async{
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_stat');
    await flutterLocalNotificationsPlugin.initialize(InitializationSettings(android: initializationSettingsAndroid),
    onSelectNotification: (payload) => { log('selected notification payload: ${payload}') }
    );
  }

  Future<void> show() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Title',
      'Body',
      NotificationDetails(android: _androidNotificationDetails),
      payload: 'Notification Payload',
    );
  }

  Future<PendingNotificationRequest?> get(int id) async{
    var pending = (await flutterLocalNotificationsPlugin.pendingNotificationRequests()).where((element) => element.id == id);
    return pending.isEmpty ? null : pending.first;
  }

  Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> schedule(DateTime time) async {
    var schedule_time = tz.TZDateTime.from(time, tz.local).isAfter(tz.TZDateTime.now(tz.local))
        ? tz.TZDateTime.from(time, tz.local)
        : tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Time to go to bed 🛏️",
        "We wish you a good sleep.",
        schedule_time,
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        payload: time.toString(),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }



}