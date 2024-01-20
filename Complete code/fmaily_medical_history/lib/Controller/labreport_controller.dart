import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';

import '../Components/showMessage/SnackBar.dart';
import '../Components/showMessage/customMessage.dart';
import '../Constants/date_time.dart';

Future uploadLabReport(File image,String reportTitle,String lName,BuildContext context)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('LabReport');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await saveLabReportData(reportTitle,lName,imageUrl,context);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future saveLabReportData(String reportTitle,String lName,String imageUrl,BuildContext context)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("LabReport").add({
    "Report title":reportTitle,
    "Laboratory name":lName,
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
        ),
    );
  });
}

Stream<QuerySnapshot>getLabReportData(int year)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection('LabReport').where("date",isLessThanOrEqualTo: filter).orderBy('date' ,descending: true).snapshots();
}

Future updateLabReport(File image,String reportTitle,String lName,BuildContext context,String existingUrl,String docId)async{
  String imageUrl;
  Reference referenceImageToUpload=FirebaseStorage.instance.refFromURL(existingUrl);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await editLabReportData(reportTitle,lName,imageUrl,context,docId);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future editLabReportData(String reportTitle,String lName,String imageUrl,BuildContext context,String docId)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(userId).collection('LabReport').doc(docId).update(
      {
        "Report title":reportTitle,
        "Laboratory name":lName,
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
        ),
    );
  });
}


Future deleteLabReportData(String ref, String docId,BuildContext context)async{
  String userId= await getUserId();
  await FirebaseStorage.instance.refFromURL(ref).delete().whenComplete((){
    FirebaseFirestore.instance.collection("User").doc(userId).collection('LabReport').doc(docId).delete();
  });
  Navigator.pop(context);
  Navigator.pop(context);
}

/*new added code */
Future uploadLocallyLabReport(File image,String reportTitle,String lName)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('LabReport');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await saveLocallyLabReportData(reportTitle,lName,imageUrl);
    });
  }on FirebaseException catch(e){

  }
}

Future saveLocallyLabReportData(String reportTitle,String lName,String imageUrl)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(userId).collection("LabReport").add({
    "Report title":reportTitle,
    "Laboratory name":lName,
    "image":imageUrl,
    "date":date
  });
}