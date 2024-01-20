import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/signup_screen.dart';
import 'package:fmaily_medical_history/Components/Drawer/flow_screen.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Screens/home_screen.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified(context));
  }
  checkEmailVerified(BuildContext context) async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // TODO: implement your code after email verification
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FlowScreen()));


    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onBackButtonPress,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                const CircleAvatar(
                  backgroundColor: kprimarycolor,
                  radius: 60,
                  child: Icon(Icons.mark_email_read,size: 80,color: Colors.white,),),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Check your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'We have sent you a Email on  ${auth.currentUser?.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16,),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator(color: kprimarycolor),),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets
                      .symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'Verifying email...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16,),
                    ),
                  ),
                ),
                const SizedBox(height: 57),
                Padding(
                  padding: const EdgeInsets
                      .symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                      } catch (e) {
                        showDialog(context: context, builder: (BuildContext context){
                          return customMessage(message: '$e', icon: Icons.error, title: 'Alert');
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimarycolor,
                      padding: const EdgeInsets.only(left: 60,right: 60,top: 13,bottom: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),

                    ),
                    child: const Text('Resend',style: TextStyle(fontSize: 16),),
                  ),
                ),

              ],
            ),
          ),
        ),
      )
    );
  }

  Future<bool> onBackButtonPress() async{
    FirebaseAuth auth=FirebaseAuth.instance;
    timer?.cancel();
    auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
    return false;
  }
}