

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/check_user.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberLabReport/add_family_member_labreport.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberPrescription/family_member_add_prescription.dart';
import 'package:fmaily_medical_history/Screens/Labreports/add_lab_report.dart';
import 'package:fmaily_medical_history/Services/push_notification.dart';

import 'Screens/Prescriptions/add_prescription.dart';
import 'localdata.dart';

@pragma("vm:entry-point")
Future<void> _handleBackgroundMessaging(RemoteMessage message) async{

}


final Connectivity connectivity = Connectivity();
ConnectivityResult? previousResult;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessaging);


  SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]
  );
  startMonitoringConnectivity();
  runApp( MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: 'FMH App',
    home:  const CheckUser(),
  ));
}
/* new code */
void startMonitoringConnectivity() {
  connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    if (result != previousResult) {
      previousResult = result;
      handleConnectivityChange(result);
    }
  });
}
void handleConnectivityChange(ConnectivityResult connectivityResult) {
  if (connectivityResult == ConnectivityResult.none) {
    // Internet connection is not available
    print('No internet connection');
  } else {
    // Internet connection is available
    print('Internet connection available');
    uploadLocalPrescriptionData();
    uploadLocalLabReportData();
    uploadLocalFamilyPrescriptionData();
    uploadFamilyLocalLabReportData();
  }
}