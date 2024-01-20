
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fmaily_medical_history/Screens/Appointments/all_appointment.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/all_requests.dart';

import '../main.dart';

int id = 0;
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: onselectNotification);
  }

  static void display(RemoteMessage message) async{
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "high_importance_channel",
            "high importance channel",
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            channelShowBadge: true,
            enableVibration: true,
          )

      );
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,);
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }


  static void onselectNotification(NotificationResponse details) async{

  }
}