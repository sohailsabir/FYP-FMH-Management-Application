import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Components/Loading/loading.dart';

Future<bool> usernameCheck(String username,BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>Center(child: spinkit,));
  final result = await FirebaseFirestore.instance
      .collection('Username')
      .where('user', isEqualTo: username)
      .get();
  return result.docs.isEmpty;
}