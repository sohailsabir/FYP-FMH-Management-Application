
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/customDialog.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Constants/date_time.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:intl/intl.dart';

Future saveAppointmentData(String dName,String hName,String aDate,String time,String purpose,BuildContext context,int dateTime,int notifyId)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("Appointment").add({
    "Doctor name": dName,
    "Hospital name": hName,
    "Appointment date": aDate,
    "Appointment time": time,
    "purpose": purpose,
    "Date":date,
    "Datetime": dateTime,
    "NotifyId":notifyId,
  }).then((value){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customDialog(message: "Data saved",title: "Successfully",icon: Icons.check_circle,);
    });
  });
}

Stream<QuerySnapshot>getAllAppointmentData(int year)async*{
  final uid=await getUserId();
  DateTime datetime=DateTime.now();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Appointment").where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getUpcomingAppointmentData()async*{
  final uid=await getUserId();
  DateTime datetime=DateTime.now();
  print(datetime.microsecondsSinceEpoch);
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Appointment").where('Datetime',isGreaterThanOrEqualTo: datetime.microsecondsSinceEpoch).orderBy('Datetime',descending: false).snapshots();
}
Stream<QuerySnapshot>getTodayAppointmentData()async*{
  final uid=await getUserId();
  DateTime datetime=DateTime.now();
  String todayDate=getDateTime();
  print(datetime.microsecondsSinceEpoch);
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Appointment").where('Appointment date',isEqualTo: todayDate).where('Datetime',isGreaterThanOrEqualTo: datetime.microsecondsSinceEpoch).orderBy('Datetime',descending: false).snapshots();
}
Future deleteAppointments(String id)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(uid).collection("Appointment").doc(id).delete();
}


