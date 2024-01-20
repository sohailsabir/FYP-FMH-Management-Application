import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Constants/date_time.dart';
import 'firebase_authentication.dart';

Stream patientData(String patientId)async*{
  yield* FirebaseFirestore.instance.collection('User').doc(patientId).snapshots();
}

Stream<QuerySnapshot>getPatientPrescriptionData(int year,String patientId)async*{
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(patientId).collection('Prescription').where("date",isLessThanOrEqualTo: filter).orderBy('date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getPatientLabReportData(int year,String patientId)async*{
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(patientId).collection('LabReport').where("date",isLessThanOrEqualTo: filter).orderBy('date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getPatientVaccinationData(int year,String patientId)async*{
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(patientId).collection("Vaccination").where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getPatientMedicationData(int year,String patientId)async*{
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(patientId).collection("Medication").where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getPatient(int year)async*{
  String userId=await getUserId();
  yield* FirebaseFirestore.instance.collection('User').doc(userId).collection("Patient").where('Date',isNotEqualTo: '').orderBy('Date', descending: true).snapshots();
}

Future<String?> patientRequest(String patientId,String firstName, String lastName,String image,BuildContext context,String uFirstName,String uLastName)async{

  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("Patient").add({
    "Id":userId,
    "Patient id":patientId,
    "First name": firstName,
    "Last name": lastName,
    "Check": 'Not Allow',
    'Image':image,
    'Date':date,
  }).then((DocumentReference reference){
    FirebaseFirestore.instance.collection('User').doc(patientId).collection('Request').doc(reference.id).set({
      "Request id":userId,
      "Id":patientId,
      "First name": uFirstName,
      "Last name": uLastName,
      "Check": 'Not Allow',
      'Date':date,
      'Image':image,
    }).then((value){
      Navigator.pop(context);
    });
  });
  return 'Added';
}

Stream<QuerySnapshot>getAllRequest(int year)async*{
  String userId=await getUserId();
  yield* FirebaseFirestore.instance.collection('User').doc(userId).collection("Request").where('Date',isNotEqualTo: '').orderBy('Date', descending: true).snapshots();
}
Stream<QuerySnapshot>getFamilyAllRequest(int year,String uid)async*{
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Request").where('Date',isNotEqualTo: '').orderBy('Date', descending: true).snapshots();
}

Future changeAccess(String patientId,String access,String docId,BuildContext context)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(userId).collection('Request').doc(docId).update({
    'Check':access,
  }).then((value){
    FirebaseFirestore.instance.collection('User').doc(patientId).collection('Patient').doc(docId).update({
      'Check':access,
    });
  });
}
Future FamilychangeAccess(String uid,String patientId,String access,String docId,BuildContext context)async{
  FirebaseFirestore.instance.collection('User').doc(uid).collection('Request').doc(docId).update({
    'Check':access,
  }).then((value){
    FirebaseFirestore.instance.collection('User').doc(patientId).collection('Patient').doc(docId).update({
      'Check':access,
    });
  });
}

Future removePatient(String patientId,String docId,BuildContext context)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(userId).collection('Patient').doc(docId).delete().then((value){
    FirebaseFirestore.instance.collection("User").doc(patientId).collection('Request').doc(docId).delete();
  });
}

