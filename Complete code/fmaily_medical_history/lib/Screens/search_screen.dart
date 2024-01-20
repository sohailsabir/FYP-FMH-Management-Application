import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/all_patients.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/all_requests.dart';

import 'OtherPatientData/family_member_request.dart';
class SearchOtherScreen extends StatefulWidget {
  const SearchOtherScreen({Key? key}) : super(key: key);

  @override
  _SearchOtherScreenState createState() => _SearchOtherScreenState();
}

class _SearchOtherScreenState extends State<SearchOtherScreen> {
  String? patientId;
  bool isLoading=false;
   Map<String,dynamic>?userMap;
  TextEditingController search=TextEditingController();
  void onSearch()async{
    setState(() {
      isLoading=true;
    });
    FirebaseFirestore _firestore=FirebaseFirestore.instance;
    await _firestore.collection('User').where('User name', isEqualTo: search.text).get().then((value){
      setState(() {
        patientId=value.docs[0].id;
        userMap=value.docs[0].data();
        isLoading=false;
      });
      print(userMap);
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: backColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Search Peoples"),
          backgroundColor: kprimarycolor,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'All Patients',),
              Tab(text: 'Requests',),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllPatientScreen(),
            AllRequestScreen(),
          ],
        ),
      ),
    );
  }
}
