import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';

Future<bool> patientCheck(String username,BuildContext context) async {
  final userId=await getUserId();
  final result = await FirebaseFirestore.instance
      .collection('User').doc(userId).collection('Patient')
      .where('Patient id', isEqualTo: username)
      .get();
  return result.docs.isEmpty;
}