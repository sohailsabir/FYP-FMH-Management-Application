import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/date_time.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:intl/intl.dart';

import '../Components/showMessage/customDialog.dart';
import '../Components/showMessage/customMessage.dart';

Future saveMedicineData(String dName,String specialization, String cNumber,String hName,String hAddress,String disease,String mName,String takeFood, String sDate,String eDate,BuildContext context)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("Medication").add({
    "Medicine name":mName,
    "Disease":disease,
    "Doctor name": dName,
    "Specialization":specialization,
    "Contact no":cNumber,
    "Hospital name":hName,
    "Hospital address":hAddress,
    "Take medicine": takeFood,
    "Start date":sDate,
    "End date":eDate,
    "Date":date
  }).then((value){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customDialog(message: "Data saved",title: "Successfully",icon: Icons.check_circle,);
    });
  });

}

Stream<QuerySnapshot>getAllMedicationData(int year)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Medication").where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getCurrentMedicationData()async*{
  var date =  DateTime.now();
  final last15Day=date.subtract(const Duration(days: 30));
  var formatter =DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(last15Day);
  final uid=await getUserId();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Medication").where('Date',isGreaterThanOrEqualTo: formattedDate).orderBy('Date' ,descending: true).snapshots();
}

Future deleteMedication(String id)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(uid).collection("Medication").doc(id).delete();
}

Future editMedication(String dName,String specialization, String cNumber,String hName,String hAddress,String disease,String mName,String takeFood, String sDate,String eDate,BuildContext context, String id)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(uid).collection("Medication").doc(id).update({
    "Medicine name":mName,
    "Disease":disease,
    "Doctor name": dName,
    "Specialization":specialization,
    "Contact no":cNumber,
    "Hospital name":hName,
    "Hospital address":hAddress,
    "Take medicine": takeFood,
    "Start date":sDate,
    "End date":eDate,
  }
  ).then((value){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: "Data Update",title: "Successfully",icon: Icons.check_circle,);
    });
  });
}
