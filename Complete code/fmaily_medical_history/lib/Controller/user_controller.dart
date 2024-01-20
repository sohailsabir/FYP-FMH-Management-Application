import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';

import '../Components/showMessage/SnackBar.dart';
import '../Components/showMessage/customMessage.dart';

Future<String?>saveUserData(String fName,String lName,String DOB,String bGroup,String email,String password,int age,String uid,BuildContext context,String username)async{
  FirebaseFirestore.instance.collection("User").doc(uid).set({
    'First name':fName,
    'Last name':lName,
    'Date of Birth':DOB,
    'Blood group':bGroup,
    'Email':email,
    'Age':age,
    'Image':'',
    'User name':username
  });
  FirebaseFirestore.instance.collection('Username').add({
    'user': username
  });
  FirebaseFirestore.instance.collection('User').doc(uid).collection('Patient').add({
    "Id":'',
    "Patient id":'',
    "First name": '',
    "Last name":'',
    "Check": '',
    'Image':'',
    'Date':'',
  });
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('User').doc(uid).set(
        {
          'token': token
        },SetOptions(merge: true));
  }
Stream<QuerySnapshot>getUserData()async*{
  String userId=await getUserId();
  await FirebaseFirestore.instance.collection('User').doc(userId).get().asStream();
}

Future editUserProfile(String fName,String lName,String dOB,String bGroup,String age,BuildContext context,)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(userId).update({
    "First name":fName,
    "Last name":lName,
    "Date of Birth":dOB,
    "Blood group":bGroup,
    'Age':age
  }).then((value){
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: customSnackBarContainer(
        title: "Successfully",
        text: "Data Update.",
      ),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  });
}

Future editUserProfileWithImage(String fName,String lName,String dOB,String bGroup,String age,BuildContext context,File image,String existingUrl)async{
  String userId= await getUserId();
  String imageUrl;

  try{
    if(existingUrl.isNotEmpty)
    {
      Reference referenceImageToUpload=FirebaseStorage.instance.refFromURL(existingUrl);
      await referenceImageToUpload.putFile(image).whenComplete(()async{
        imageUrl=await referenceImageToUpload.getDownloadURL();
        if(imageUrl.isNotEmpty)
        {
          FirebaseFirestore.instance.collection('User').doc(userId).update({
            "First name":fName,
            "Last name":lName,
            "Date of Birth":dOB,
            "Blood group":bGroup,
            'Age':age,
            'Image':imageUrl
          }).then((value){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: customSnackBarContainer(
                title: "Successfully",
                text: "Data Update.",
              ),
                behavior: SnackBarBehavior.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            );
          });

        }
      });
    }
    else{
      String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceRoot=FirebaseStorage.instance.ref();
      Reference referenceDirImages=referenceRoot.child('UserImage');
      Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
      await referenceImageToUpload.putFile(image).whenComplete(()async{
        imageUrl=await referenceImageToUpload.getDownloadURL();
        if(imageUrl.isNotEmpty)
        {
          FirebaseFirestore.instance.collection('User').doc(userId).update({
            "First name":fName,
            "Last name":lName,
            "Date of Birth":dOB,
            "Blood group":bGroup,
            'Age':age,
            'Image':imageUrl
          }).then((value){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: customSnackBarContainer(
                title: "Successfully",
                text: "Data Update.",
              ),
                behavior: SnackBarBehavior.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            );
          });
        }
      });


    }
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }

}