import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/Loading/loading.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/check_patient.dart';

import '../../Controller/firebase_authentication.dart';
import '../../Controller/patient_view_controller.dart';
import 'package:http/http.dart' as http;
class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  TextEditingController searchController=TextEditingController();
  Map<String,dynamic>?userMap;
  String? patientId;
  String? token;
  bool isLoading=false;
  bool checkButton=false;
  bool checkWidget=false;
  String text="Add";
  bool checkId=false;
  String? username;
  String? pFirstName;
  String? pLastName;
  Future onSearch()async{
    setState(() {
      isLoading=true;
    });
    try{
      FirebaseFirestore _firestore=FirebaseFirestore.instance;
      await _firestore.collection('User').where('User name', isEqualTo: searchController.text.trim()).get().then((value){
        setState(() {
          patientId=value.docs[0].id;
          userMap=value.docs[0].data();
          token=userMap!['token'];
        });
        print(token);
      });
        String uid=await getUserId();
        _firestore.collection('User').doc(uid).get().then((value){
          setState(() {
            username =value['User name'];
            pFirstName=value['First name'];
            pLastName=value['Last name'];
          });
        });
    } catch(e){
      setState(() {
        isLoading=false;
        searchController.clear();
      });
      showDialog(context: context, builder: (context){
        return customMessage(message: "No Patient Found with this Username.", icon: Icons.error, title: 'Sorry');
      });
    }
  }

  sendNotification(String title, String token,String username)async{

    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try{
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAgJ0siRs:APA91bHQnxv3LzVTJFJyMbvq0IELZAmlPcEj-goZ2r58d-W15P3sO7yURHQM8viR6jKSr9oDOFevlGI5TjFLRMEWyypwF8yYpoPxSTaGi-NU4pfpd5MjQ8WsbGg66OVzmoVuZiFq1Woy'
      },
          body: jsonEncode(<String,dynamic>{
            'notification': <String,dynamic> {'title': title,'body': "${username} request you see data"},
            'priority': 'high',
            'data': data,
            'to': '$token'
          })
      );


      if(response.statusCode == 200){
        print("Yeh notification is sended");
      }else{
        print("Error");
      }

    }catch(e){

    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Find Patients',style: TextStyle(
          color: kprimarycolor,
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: kprimarycolor
        ),
      ),
      body: isLoading?spinkit:Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: TextField(
                    controller: searchController,
                    cursorColor: kprimarycolor,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: kprimarycolor,
                      ),
                      hintText: "Search here...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black12, width: 1.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(width: 1.8, color: Colors.black12),
                      ),
                    ),
                    onChanged: (value){
                      if(value.isEmpty)
                        {
                          setState(() {
                              checkButton=false;
                          });
                        }
                      else{
                        setState(() {
                          checkButton=true;
                        });
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 30),
                child: ElevatedButton(
                    onPressed: checkButton?()async{
                      setState(() {
                        checkId=false;
                        text="Add";
                      });
                      await onSearch();
                      final valid=await patientCheck(patientId!, context);
                      setState(() {
                        isLoading=false;
                        checkWidget=true;
                      });
                      if(!valid){
                        setState(() {
                          text='Added';
                          checkId=true;
                        });
                      }
                      else{
                        setState(() {
                          text='Add';
                        });
                      }
                    }:null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: kprimarycolor,
                      padding: const EdgeInsets.symmetric(vertical: 13,horizontal: 15)
                    ), 
                    child: const Text('Search'),
                ),
              )
            ],
          ),
          SizedBox(height: checkWidget?50:300,),
          checkWidget?Card(
            margin: const EdgeInsets.only(left: 15,right: 15),
            elevation: 5.0,
            child: ListTile(
              tileColor: kprimarycolor.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: userMap!['Image'].toString().isNotEmpty?"${userMap!['Image']}":"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRKxFH_5CD60TMQ_gvjHkE5bAHCjWwPA1l3582kT5lqnbgFtPse",
                        height: 180,
                        width: 180,
                        key: UniqueKey(),
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => const Image(image: AssetImage('assets/ImageError.png'),),
                        placeholder: (context, url) => loadingImage),
                  ),
                ),
              ),
              title: Text("${userMap!['First name'].toString().toCapitalized()} ${userMap!['Last name'].toString().toCapitalized()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              trailing: ElevatedButton(
                onPressed: checkId?null:()async{
                  showDialog(
                    context: context,
                    builder: (context)=>spinkit,
                    barrierDismissible: false,
                  );
                  await patientRequest(patientId!, userMap!['First name'], userMap!['Last name'],userMap!['Image'],context,pFirstName!,pLastName!).then((value){
                    setState(() {
                      isLoading=false;
                      text= "Added";
                      checkId=true;
                    });
                  });
                  sendNotification('Request', token!, username!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimarycolor,
                ),
                child: Text(text),
              ),
            ),
          ):Container(),
          checkWidget?Container():Column(
            children: const [
              Text("Search Patient by Username.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey,
                ),
              ),
              Text("Username can be found within the Patient profile.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey,
                ),
              )
            ],
          ),
          const SizedBox(height: 1,)
        ],
      ),
    );
  }
}

