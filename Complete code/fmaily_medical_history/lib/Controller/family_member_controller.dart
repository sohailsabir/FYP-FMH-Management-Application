
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/customDialog.dart';
import 'package:fmaily_medical_history/Constants/date_time.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/member_email_verify.dart';
import 'package:intl/intl.dart';
import '../Components/showMessage/SnackBar.dart';
import '../Components/showMessage/customMessage.dart';

/* Profile data */
Future registerFamilyMemberWithImage(String email, String password,String fName,String lName,String DOB,String bGroup,int age,BuildContext context,String username,String relation,File image) async {

  try {
    FirebaseApp tempApp = await Firebase.initializeApp(name: 'temporaryregister', options: Firebase.app().options);
    UserCredential result = await FirebaseAuth.instanceFor(app: tempApp).createUserWithEmailAndPassword(
        email: email, password: password);
    if(result.user!.uid.isNotEmpty)
    {
      tempApp.delete();
      uploadMemberImage(fName, lName, DOB, bGroup, email, password, age, context, relation, image, username,result.user!.uid);
    }
    return result.user!.uid;
  }on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: '${e.message}', icon: Icons.error, title: "Error");
    });
    return null;
  }
}

Future uploadMemberImage(String fName,String lName,String DOB,String bGroup,String email,String password,int age,BuildContext context,String relation,File image,String username,String uid)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('UserImage');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      if(imageUrl.isNotEmpty){
        FirebaseFirestore.instance.collection('User').doc(uid).set({
          'First name':fName,
          'Last name':lName,
          'Date of Birth':DOB,
          'Blood group':bGroup,
          'Email':email,
          'Age':age,
          'Image':imageUrl,
          'User name':username,
        }).then((value){
          FirebaseFirestore.instance.collection("User").doc(uid).collection('Patient').add({
            "Id":'',
            "Patient id":'',
            "First name": '',
            "Last name":'',
            "Check": '',
            'Image':'',
            'Date':'',
          });
        });
        String? token = await FirebaseMessaging.instance.getToken();
        FirebaseFirestore.instance.collection('User').doc(uid).set(
            {
              'token': token
            },SetOptions(merge: true));
        saveFamilyMemberData(fName, lName, DOB, bGroup, email, password, age, context, relation, imageUrl,uid,username);
      }

    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future registerFamilyMember(String email, String password,String fName,String lName,String DOB,String bGroup,int age,BuildContext context,String image,String username,String relation) async {

  try {
    FirebaseApp tempApp = await Firebase.initializeApp(name: 'temporaryregister', options: Firebase.app().options);
    UserCredential result = await FirebaseAuth.instanceFor(app: tempApp).createUserWithEmailAndPassword(
        email: email, password: password);
    if(result.user!.uid.isNotEmpty)
      {
        tempApp.delete();
        FirebaseFirestore.instance.collection('User').doc(result.user!.uid).set({
          'First name':fName,
          'Last name':lName,
          'Date of Birth':DOB,
          'Blood group':bGroup,
          'Email':email,
          'Age':age,
          'Image':image,
          'User name':username,
        });
        FirebaseFirestore.instance.collection('User').doc(result.user!.uid).collection('Patient').add({
          "Id":'',
          "Patient id":'',
          "First name": '',
          "Last name":'',
          "Check": '',
          'Image':'',
          'Date':'',
        });
        String? token = await FirebaseMessaging.instance.getToken();
        FirebaseFirestore.instance.collection('User').doc(result.user!.uid).set(
            {
              'token': token
            },SetOptions(merge: true));
        saveFamilyMemberData(fName, lName, DOB, bGroup, email, password, age, context, relation, image, result.user!.uid,username);
      }

    return result.user!.uid;
  }on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: '${e.message}', icon: Icons.error, title: "Error");
    });
    return null;
  }
}

Future saveFamilyMemberData(String fName,String lName,String DOB,String bGroup,String email,String password,int age,BuildContext context,String relation,String imageUrl,String uid,String username)async{
  String userId= await getUserId();
  String date=getDateTime();
  FirebaseFirestore.instance.collection("User").doc(userId).collection('Family member').doc(uid).set({
    'First name':fName,
    'Last name':lName,
    'Date of Birth':DOB,
    'Blood group':bGroup,
    'Email':email,
    'Password':password,
    'Age':age,
    'Image':imageUrl,
    'Relation':relation,
    'User id':uid,
    'Date':date,
    'User name':username,
  }).then((value){
    FirebaseFirestore.instance.collection('Username').add({
      'user':username
    }).then((value){
      Navigator.pop(context);
      showDialog(context: context, builder: (context){
        return customDialog(message: "Member has been registered successfully!",title: "Congratulation",icon: Icons.check_circle,);
      });
    });
  });
}

Stream<QuerySnapshot>getFamilyMember()async*{
  final uid=await getUserId();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').orderBy('Date' ,descending: true).snapshots();
}
/* Medication */

Future saveFamilyMedicineData(String dName,String specialization, String cNumber,String hName,String hAddress,String disease,String mName,String takeFood, String sDate,String eDate,BuildContext context,String mUid,fUid)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(fUid).collection('Medication').add({
    "Medicine name":mName,
    "Disease":disease,
    "Doctor name": dName,
    "Specialization":specialization,
    "Contact no":cNumber,
    "Hospital name":hName,
    "Hospital address":hAddress,
    "Take medicine": takeFood,
    "Start date":sDate,
    "End date":eDate,
    "Date":date
  }).then((DocumentReference doc){
    FirebaseFirestore.instance.collection("User").doc(userId).collection("Family member").doc(mUid).collection('Medication').doc(doc.id).set({
      "Medicine name":mName,
      "Disease":disease,
      "Doctor name": dName,
      "Specialization":specialization,
      "Contact no":cNumber,
      "Hospital name":hName,
      "Hospital address":hAddress,
      "Take medicine": takeFood,
      "Start date":sDate,
      "End date":eDate,
      "Date":date
    }).then((value){
      Navigator.pop(context);
      showDialog(context: context, builder: (context){
        return customDialog(message: "Data saved",title: "Successfully",icon: Icons.check_circle,);
      });
    });
  });


}

Stream<QuerySnapshot>getFamilyAllMedicationData(int year,String mId)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Family member").doc(mId).collection('Medication').where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Stream<QuerySnapshot>getFamilyCurrentMedicationData(String mId)async*{
  var date =  DateTime.now();
  final last15Day=date.subtract(const Duration(days: 30));
  var formatter =DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(last15Day);
  final uid=await getUserId();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Family member").doc(mId).collection('Medication').where('Date',isGreaterThanOrEqualTo: formattedDate).orderBy('Date' ,descending: true).snapshots();
}

Future deleteFamilyMedication(String id,String familyMemberId,String medicationId)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(uid).collection("Family member").doc(medicationId).collection('Medication').doc(id).delete().then((value){
    FirebaseFirestore.instance.collection('User').doc(familyMemberId).collection('Medication').doc(id).delete();
  });

}

Future editFamilyMedication(String dName,String specialization, String cNumber,String hName,String hAddress,String disease,String mName,String takeFood, String sDate,String eDate,BuildContext context, String id,String medicationId,String familyMemberId)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(familyMemberId).collection('Medication').doc(id).update({
    "Medicine name":mName,
    "Disease":disease,
    "Doctor name": dName,
    "Specialization":specialization,
    "Contact no":cNumber,
    "Hospital name":hName,
    "Hospital address":hAddress,
    "Take medicine": takeFood,
    "Start date":sDate,
    "End date":eDate,}).then((value){
    FirebaseFirestore.instance.collection("User").doc(uid).collection("Family member").doc(medicationId).collection('Medication').doc(id).update({
      "Medicine name":mName,
      "Disease":disease,
      "Doctor name": dName,
      "Specialization":specialization,
      "Contact no":cNumber,
      "Hospital name":hName,
      "Hospital address":hAddress,
      "Take medicine": takeFood,
      "Start date":sDate,
      "End date":eDate,
    }
    ).then((value){
      Navigator.pop(context);
      showDialog(context: context, builder: (context){
        return customMessage(message: "Data Update",title: "Successfully",icon: Icons.check_circle,);
      });
    });
  });
}

/* Vaccination */

Future saveFamilyVaccinationData(String vName,String hName,String vDate,String time,BuildContext context,String vId,String fId)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(fId).collection("Vaccination").add({
    "Vaccination name": vName,
    "Hospital name": hName,
    "Vaccination date": vDate,
    "Vaccination time": time,
    "Date":date
  }).then((DocumentReference doc){
    FirebaseFirestore.instance.collection("User").doc(userId).collection("Family member").doc(vId).collection('Vaccination').doc(doc.id).set({
      "Vaccination name": vName,
      "Hospital name": hName,
      "Vaccination date": vDate,
      "Vaccination time": time,
      "Date":date
    }).then((value){
      Navigator.pop(context);
      showDialog(context: context, builder: (context){
        return customDialog(message: "Data saved",title: "Successfully",icon: Icons.check_circle,);
      });
    });
  });

}

Stream<QuerySnapshot>getFamilyAllVaccinationData(int year,String vId)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection("Family member").doc(vId).collection('Vaccination').where("Date",isLessThanOrEqualTo: filter).orderBy('Date' ,descending: true).snapshots();
}

Future deleteFamilyVaccination(String id,String fId,String vid)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(fId).collection("Vaccination").doc(id).delete().then((value){
    FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(vid).collection('Vaccination').doc(id).delete();
  });
}

Future editFamilyVaccination(String vName,String hName,String vDate,String vTime, String id,String vId,String fId)async{
  final uid=await getUserId();
  await FirebaseFirestore.instance.collection("User").doc(fId).collection("Vaccination").doc(id).update({
    "Vaccination name":vName,
    "Hospital name": hName,
    "Vaccination date": vDate,
    "Vaccination time": vTime,
  }
  ).then((value){
    FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(vId).collection('Vaccination').doc(id).update({
      "Vaccination name":vName,
      "Hospital name": hName,
      "Vaccination date": vDate,
      "Vaccination time": vTime,
    });
  });
}

/* Prescription */

Future uploadFamilyPrescriptionImage(File image,String dName,String hName, String disease,BuildContext context,String fId,String pId)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('Prescriptions');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await saveFamilyPrescriptionData(dName,hName,disease,imageUrl,context,fId,pId);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future saveFamilyPrescriptionData(String dName,String hName, String disease,String imageUrl,BuildContext context,String fId,String pid)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(fId).collection('Prescription').add({
    "Doctor name":dName,
    "Disease":disease,
    "Hospital name": hName,
    "image":imageUrl,
    "date":date
  }).then((DocumentReference doc){
    FirebaseFirestore.instance.collection("User").doc(userId).collection("Family member").doc(pid).collection('Prescription').doc(doc.id).set({
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
  });

}

Stream<QuerySnapshot>getFamilyPrescriptionData(int year,String fId,String pId)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(pId).collection('Prescription').where("date",isLessThanOrEqualTo: filter).orderBy('date' ,descending: true).snapshots();
}

Future updateFamilyPrescriptionImage(File image,String dName,String hName, String disease,BuildContext context,String existingUrl,String docId,String fId,String pId)async{
  String imageUrl;
  Reference referenceImageToUpload=FirebaseStorage.instance.refFromURL(existingUrl);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await editPrescriptionData(dName,hName,disease,imageUrl,context,docId,fId,pId);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future editPrescriptionData(String dName,String hName, String disease,String imageUrl,BuildContext context,String docId,String fId,String pid)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(fId).collection("Prescription").doc(docId).update({
    "Doctor name":dName,
    "Disease":disease,
    "Hospital name": hName,
    "image":imageUrl,
  }).then((value){
    FirebaseFirestore.instance.collection('User').doc(userId).collection('Family member').doc(pid).collection('Prescription').doc(docId).update(
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
  });

}

Future deleteFamilyPrescriptionData(String ref, String docId,BuildContext context,String fId,String pId)async{
  String userId= await getUserId();
  await FirebaseStorage.instance.refFromURL(ref).delete().whenComplete((){
    FirebaseFirestore.instance.collection("User").doc(fId).collection('Prescription').doc(docId).delete();
    FirebaseFirestore.instance.collection("User").doc(userId).collection('Family member').doc(pId).collection('Prescription').doc(docId).delete();
  });
  Navigator.pop(context);
  Navigator.pop(context);
}

/* Lab Report */

Future uploadFamilyLabReport(File image,String reportTitle,String lName,BuildContext context,String fId,String rId)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('LabReport');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await saveFamilyLabReportData(reportTitle,lName,imageUrl,context,fId,rId);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future saveFamilyLabReportData(String reportTitle,String lName,String imageUrl,BuildContext context,String fId,String rId)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(fId).collection("LabReport").add({
    "Report title":reportTitle,
    "Laboratory name":lName,
    "image":imageUrl,
    "date":date
  }).then((DocumentReference doc){
    FirebaseFirestore.instance.collection("User").doc(userId).collection('Family member').doc(rId).collection("LabReport").doc(doc.id).set({
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
  });

}

Stream<QuerySnapshot>getFamilyLabReportData(int year,String fId,String rId)async*{
  final uid=await getUserId();
  String filter=(year+1).toString();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(rId).collection('LabReport').where("date",isLessThanOrEqualTo: filter).orderBy('date' ,descending: true).snapshots();
}

Future updateFamilyLabReport(File image,String reportTitle,String lName,BuildContext context,String existingUrl,String docId,String fId,String rId)async{
  String imageUrl;
  Reference referenceImageToUpload=FirebaseStorage.instance.refFromURL(existingUrl);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await editFamilyLabReportData(reportTitle,lName,imageUrl,context,docId,fId,rId);
    });
  }on FirebaseException catch(e){
    Navigator.pop(context);
    showDialog(context: context, builder: (context){
      return customMessage(message: 'Something went wrong', icon: Icons.error, title: "Error");
    });
  }
}

Future editFamilyLabReportData(String reportTitle,String lName,String imageUrl,BuildContext context,String docId,String fId,String rId)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(fId).collection('LabReport').doc(docId).update({
    "Report title":reportTitle,
    "Laboratory name":lName,
    "image":imageUrl,
  });
  FirebaseFirestore.instance.collection('User').doc(userId).collection('Family member').doc(rId).collection('LabReport').doc(docId).update(
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

Future deleteFamilyLabReportData(String ref, String docId,BuildContext context,String fId,String rId)async{
  String userId= await getUserId();
  await FirebaseStorage.instance.refFromURL(ref).delete().whenComplete((){
    FirebaseFirestore.instance.collection("User").doc(fId).collection('LabReport').doc(docId).delete();
    FirebaseFirestore.instance.collection("User").doc(userId).collection('Family member').doc(rId).collection('LabReport').doc(docId).delete();
  });
  Navigator.pop(context);
  Navigator.pop(context);
}

/*User Profile Edit */

Future editFamilyMemberProfile(String fName,String lName,String dOB,String bGroup,String relation,String age,BuildContext context,String docId,String fId)async{
  String userId= await getUserId();
  FirebaseFirestore.instance.collection('User').doc(fId).update({
    "First name":fName,
    "Last name":lName,
    "Date of Birth":dOB,
    "Blood group":bGroup,
    'Relation':relation,
    'Age':age
  });
  FirebaseFirestore.instance.collection('User').doc(userId).collection('Family member').doc(docId).update(
      {
        "First name":fName,
        "Last name":lName,
        "Date of Birth":dOB,
        "Blood group":bGroup,
        'Relation':relation,
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

Future editFamilyMemberProfileWithImage(String fName,String lName,String dOB,String bGroup,String relation,String age,BuildContext context,String docId,String fId,File image,String existingUrl)async{
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
            FirebaseFirestore.instance.collection('User').doc(fId).update({
              "First name":fName,
              "Last name":lName,
              "Date of Birth":dOB,
              "Blood group":bGroup,
              'Relation':relation,
              'Age':age,
              'Image':imageUrl
            });
            FirebaseFirestore.instance.collection('User').doc(userId).collection('Family member').doc(docId).update(
                {
                  "First name":fName,
                  "Last name":lName,
                  "Date of Birth":dOB,
                  "Blood group":bGroup,
                  'Relation':relation,
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
          FirebaseFirestore.instance.collection('User').doc(fId).update({
            "First name":fName,
            "Last name":lName,
            "Date of Birth":dOB,
            "Blood group":bGroup,
            'Relation':relation,
            'Age':age,
            'Image':imageUrl
          });
          FirebaseFirestore.instance.collection('User').doc(userId).collection('Family member').doc(docId).update(
              {
                "First name":fName,
                "Last name":lName,
                "Date of Birth":dOB,
                "Blood group":bGroup,
                'Relation':relation,
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

/* Refresh Member profile */

Stream refreshMemberData(String memberId)async*{
  final uid=await getUserId();
  yield* FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(memberId).snapshots();
}



/* New add code*/

Future uploadLocallyFamilyPrescriptionImage(File image,String dName,String hName, String disease,String fId,String pId)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('Prescriptions');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await saveLocallyFamilyPrescriptionData(dName,hName,disease,imageUrl,fId,pId);
    });
  }on FirebaseException catch(e){

  }
}

Future saveLocallyFamilyPrescriptionData(String dName,String hName, String disease,String imageUrl,String fId,String pid)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(fId).collection('Prescription').add({
    "Doctor name":dName,
    "Disease":disease,
    "Hospital name": hName,
    "image":imageUrl,
    "date":date
  }).then((DocumentReference doc) {
    FirebaseFirestore.instance.collection("User").doc(userId).collection(
        "Family member").doc(pid).collection('Prescription').doc(doc.id).set({
      "Doctor name": dName,
      "Disease": disease,
      "Hospital name": hName,
      "image": imageUrl,
      "date": date
    });
  });

}

Future uploadLocallyFamilyLabReport(File image,String reportTitle,String lName,String fId,String rId)async{
  String imageUrl;
  String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('LabReport');
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  try{
    await referenceImageToUpload.putFile(image).whenComplete(()async{
      imageUrl=await referenceImageToUpload.getDownloadURL();
      await saveLocallyFamilyLabReportData(reportTitle,lName,imageUrl,fId,rId);
    });
  }on FirebaseException catch(e){

  }
}

Future saveLocallyFamilyLabReportData(String reportTitle,String lName,String imageUrl,String fId,String rId)async{
  String date=getDateTime();
  String userId= await getUserId();
  FirebaseFirestore.instance.collection("User").doc(fId).collection("LabReport").add({
    "Report title":reportTitle,
    "Laboratory name":lName,
    "image":imageUrl,
    "date":date
  }).then((DocumentReference doc){
    FirebaseFirestore.instance.collection("User").doc(userId).collection('Family member').doc(rId).collection("LabReport").doc(doc.id).set({
      "Report title":reportTitle,
      "Laboratory name":lName,
      "image":imageUrl,
      "date":date
    });
  });

}