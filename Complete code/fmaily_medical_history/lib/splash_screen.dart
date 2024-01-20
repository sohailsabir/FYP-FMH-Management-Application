import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/check_user.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';


class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasySplashScreen(
         logo: Image.asset("assets/logo.png"),
        logoWidth: 300,
        backgroundColor: Colors.white,
        loaderColor: kprimarycolor,
        showLoader: false,
        navigator: const CheckUser(),
        durationInSeconds: 3,
      ),
    );
  }
}
