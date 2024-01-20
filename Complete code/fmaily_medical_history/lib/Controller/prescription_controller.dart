import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/SnackBar.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import '../Constants/date_time.dart';
Future uploadImage(File image,String dName,String hName, String disease,BuildContext context)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('Prescriptions');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await savePrescriptionData(dName,hName,disease,imageUrl,context);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future savePrescriptionData(String dName,String hName, String disease,String imageUrl,BuildContext context)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("Prescription").add({
    "Doctor name":dName,
    "Disease":disease,
    "Hospital name": hName,
    "image":imageUrl,
    "date":date
  }).then((value){
    Navigator.pop(context);
    Navigator.pop(context);
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: customSnackBarContainer(
       title: "Successfully",
       text: "Data Saved.",
     ),
       behavior: SnackBarBehavior.fixed,
       backgroundColor: Colors.transparent,
       elevation: 0.0,

     )
   );
  });
}

Stream<QuerySnapshot>getPrescriptionData(int year)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection('Prescription').where("date",isLessThanOrEqualTo: filter).orderBy('date' ,descending: true).snapshots();
}

Future updateImage(File image,String dName,String hName, String disease,BuildContext context,String existingUrl,String docId)async{
  String imageUrl;
  Reference referenceImageToUpload=FirebaseStorage.instance.refFromURL(existingUrl);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await editPrescriptionData(dName,hName,disease,imageUrl,context,docId);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future editPrescriptionData(String dName,String hName, String disease,String imageUrl,BuildContext context,String docId)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(userId).collection('Prescription').doc(docId).update(
    {
      "Doctor name":dName,
      "Disease":disease,
      "Hospital name": hName,
      "image":imageUrl,
    }
  ).then((value){
    Navigator.pop(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: customSnackBarContainer(
          title: "Successfully",
          text: "Data Update.",
        ),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0.0,

        )
    );
  });
}

Future deletePrescriptionData(String ref, String docId,BuildContext context)async{
  String userId= await getUserId();
    await FirebaseStorage.instance.refFromURL(ref).delete().whenComplete((){
      FirebaseFirestore.instance.collection("User").doc(userId).collection('Prescription').doc(docId).delete();
    });
    Navigator.pop(context);
    Navigator.pop(context);
}

/*new add code */

Future uploadImageLocaly(File image,String dName,String hName, String disease,)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('Prescriptions');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await savePrescriptionDataLocally(dName,hName,disease,imageUrl);
    });
  }on FirebaseException catch(e){

  }
}
Future savePrescriptionDataLocally(String dName,String hName, String disease,String imageUrl)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("Prescription").add({
    "Doctor name":dName,
    "Disease":disease,
    "Hospital name": hName,
    "image":imageUrl,
    "date":date
  });
}

