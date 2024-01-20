import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/login_screen.dart';
import 'package:fmaily_medical_history/Components/showMessage/SnackBar.dart';
import 'package:path_provider/path_provider.dart';
import '../Components/Loading/loading.dart';
import '../Components/showMessage/auth_message.dart';

Future<User?>createAccount(String email, String password,BuildContext context)async{
  FirebaseAuth auth=FirebaseAuth.instance;
  try{
   User? user=(await auth.createUserWithEmailAndPassword(email: email, password: password)).user;
   if(User!=null)
     {
       return user;
     }
   else{
     Navigator.pop(context);
     return user;
   }
  }on FirebaseAuthException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (BuildContext context){
      return AuthenticationMessage(e: e);
    });
    return null;
  }
}

Future<User?>loginUser(String email,String password,BuildContext context)async{
  FirebaseAuth auth=FirebaseAuth.instance;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>Center(child: spinkit,));
  try{
    User? user=(await auth.signInWithEmailAndPassword(email: email, password: password)).user;
    if(user!=null)
    {
      Navigator.pop(context);
      return user;
    }
    else{
      Navigator.pop(context);
      return user;
    }
  } on FirebaseAuthException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (BuildContext context){
      return AuthenticationMessage(e: e);
    });
    return null;
  }
}

Future<String>getUserId()async{
  FirebaseAuth auth=FirebaseAuth.instance;
  return (auth.currentUser!.uid);
}

Future logout(BuildContext context)async{
  FirebaseAuth auth=FirebaseAuth.instance;
  try{
    auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }

  }on FirebaseAuthException catch(e){
    showDialog(context: context, builder: (BuildContext context){
      return AuthenticationMessage(e: e);
    });
  }
}

Future resetPassword(BuildContext context,String email)async{
  try{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=>Center(child: spinkit,));
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: customSnackBarContainer(
              title: "Email Send Successfully!",
              text: "Please check your email inbox for reset password.",
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height-160),

          ),);
    });

  }on FirebaseAuthException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (BuildContext context){
      return AuthenticationMessage(e: e);
    });
  }

}