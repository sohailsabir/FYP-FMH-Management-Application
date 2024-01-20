import 'package:flutter/cupertino.dart';
import 'package:fmaily_medical_history/Screens/Appointments/all_appointment.dart';
import 'package:fmaily_medical_history/Screens/Appointments/appointment_status_screen.dart';
import 'package:fmaily_medical_history/Screens/Appointments/appointments.dart';
import 'package:fmaily_medical_history/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {

  BuildContext? _context;

  Future<FlutterLocalNotificationsPlugin> initNotifies(BuildContext context) async{
    this._context = context;
    //-----------------------------| Initialize local notifications |--------------------------------------
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
    return flutterLocalNotificationsPlugin;
    //======================================================================================================
  }



  //---------------------------------| Show the notification in the specific time |-------------------------------
  Future showNotification(String title, String description, int time, int id, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id.toInt(),
        title,
        description,
        tz.TZDateTime.now(tz.local).add(Duration(milliseconds: time)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'high importance channel','high_importance_channel',
                importance: Importance.high,
                priority: Priority.high,
                playSound: true,
                enableVibration: true,
                channelShowBadge: true,
                color: Colors.cyanAccent)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Destination Screen (Simple Notification)'
    );
  }

  //================================================================================================================


  //-------------------------| Cancel the notify |---------------------------
  Future removeNotify(int notifyId, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    try{
      return await flutterLocalNotificationsPlugin.cancel(notifyId);
    }catch(e){
      return null;
    }
  }

  //==========================================================================


  //-------------| function to inicialize local notifications |---------------------------
  // Future onSelectNotification(String? payload) async {
  //   showDialog(
  //     context: _context,
  //     builder: (_) {
  //       return new AlertDialog(
  //         title: Text("PayLoad"),
  //         content: Text("Payload : $payload"),
  //       );
  //     },
  //   );
  // }
//======================================================================================



  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     print('notification payload: $payload');
  //   }
  //   await Navigator.push(
  //     _context!,
  //     MaterialPageRoute<void>(builder: (context) => AppointmentStatus()),
  //   );
  // }



  Future onDidReceiveNotificationResponse(NotificationResponse details) async{
    // try{
    //   print("ok");
    //  await Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>AppointmentStatus()));
    //
    // }
    // catch(e){
    //   await Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>AppointmentStatus()));
    //   print('Error');
    // }

  }
}