import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/login_screen.dart';
import 'package:fmaily_medical_history/Components/Drawer/flow_screen.dart';

class CheckUser extends StatefulWidget {

  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if(auth.currentUser!=null)
      {
        return const FlowScreen();
      }
    else{
      return const LoginScreen();
    }
  }
}
