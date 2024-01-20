
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/customDialog.dart';
import '../Constants/date_time.dart';
import 'firebase_authentication.dart';

Future saveVaccinationData(String vName,String hName,String vDate,String time,BuildContext context)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("Vaccination").add({
    "Vaccination name": vName,
    "Hospital name": hName,
    "Vaccination date": vDate,
    "Vaccination time": time,
    "Date":date
  }).then((value){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customDialog(message: "Data saved",title: "Successfully",icon: Icons.check_circle,);
    });
  });
}

Stream<QuerySnapshot>getAllVaccinationData(int year)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Vaccination").where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Future deleteVaccination(String id)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(uid).collection("Vaccination").doc(id).delete();
}

Future editVaccination(String vName,String hName,String vDate,String vTime, String id)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(uid).collection("Vaccination").doc(id).update({
    "Vaccination name":vName,
    "Hospital name": hName,
    "Vaccination date": vDate,
    "Vaccination time": vTime,
  }
  );
}
