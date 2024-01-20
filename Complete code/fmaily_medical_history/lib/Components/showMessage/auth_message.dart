import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/constant.dart';

class AuthenticationMessage extends StatelessWidget {
  const AuthenticationMessage({
    Key? key,
    required this.e,
  }) : super(key: key);

  final FirebaseAuthException e;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 2),
      title: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.cancel,color: Color(0xFFC8CDCF),),
              onPressed: (){
                Navigator.pop(context);
              },

            ),
          ),
          Icon(Icons.error,
            color: kprimarycolor,size: 50,),
          SizedBox(
            height: 10,
          ),
          Center(child: Text("Alert",style: TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text("${e.message}",
        style: TextStyle(
            color: Colors.grey,
            fontSize: 16
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("OK"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC8CDCF),
              foregroundColor: Colors.black,
              minimumSize: Size(350, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
              elevation: 0.0,
            ),),
        ),
      ],
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.all(10),

    );
  }
}