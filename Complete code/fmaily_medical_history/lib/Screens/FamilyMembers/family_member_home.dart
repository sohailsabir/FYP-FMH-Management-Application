import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/view_member_profile.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/family_member_request.dart';

import '../../Animations/fade_animation.dart';
import '../../Components/Loading/loading.dart';
import '../../Components/Shimmer/medication_shimmer.dart';
import 'FamilyMemberLabReport/family_member_labreport_screen.dart';
import 'FamilyMemberMedication/family_member_medication_screen.dart';
import 'FamilyMemberPrescription/family_member_prescription_screen.dart';
import 'FamilyMemberVaccination/family_member_vaccination_screen.dart';



class FamilyMemberData extends StatefulWidget {
   const FamilyMemberData({super.key, required this.snapshot});

  final QueryDocumentSnapshot snapshot;

  @override
  _FamilyMemberDataState createState() => _FamilyMemberDataState();
}

class _FamilyMemberDataState extends State<FamilyMemberData> {
  File? imageFile;
  String? imageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.snapshot['Image'].toString().isNotEmpty)
      {
        imageUrl=widget.snapshot['Image'];
      }
    else{
      imageUrl='https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRKxFH_5CD60TMQ_gvjHkE5bAHCjWwPA1l3582kT5lqnbgFtPse';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text("Member Profile"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        elevation: 0.0,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyRequestScreen(id: widget.snapshot.id,)));
          }, icon: Icon(Icons.notifications_active))
        ],
      ),
      body: StreamBuilder(
        stream: refreshMemberData(widget.snapshot.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingListPage();
          }
          if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(50),
              child: const Center(
                child: Text(
                  "There was an unknown error while processing the request",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: const BoxDecoration(
                        color: kprimarycolor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          FadeAnimation2(1.1,  CircleAvatar(
                            radius: 52,
                            backgroundColor: kprimarycolor,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: "${snapshot.data['Image']}",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  key: UniqueKey(),
                                  placeholder: (context, url) => loadingImage,
                                  errorWidget: (context, url, error) => const Image(image: AssetImage('assets/profile.jpg'),fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),),
                          FadeAnimation2(1.1, Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 16.0),
                              child:  Text(
                                '${snapshot.data['First name'].toString().toCapitalized().trim()} ${snapshot.data['Last name'].toString().toCapitalized() }',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),),
                          FadeAnimation2(1.1, Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:  Text(
                                '${snapshot.data['Relation'].toString().toCapitalized()}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),),
                          FadeAnimation2(1.1, Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewMemberProfile(snapshot: widget.snapshot,)));
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                  decoration: const BoxDecoration(
                                    color: kprimarycolor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: const Text(
                                    'View Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                FadeAnimation2(1.1, CustomButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FamilyVaccinationScreen(
                      familyMemberId: widget.snapshot['User id'],
                      vaccinationId: widget.snapshot.id,)));
                  },
                  label: "Vaccination",
                )),
                FadeAnimation2(1.2, CustomButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyMedicationsScreen(
                      familyMemberId: widget.snapshot['User id'],
                      medicationId: widget.snapshot.id,)));
                  },
                  label: "Medications",
                ),),
                FadeAnimation2(1.3, CustomButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FamilyMemberPrescription(
                      familyMemberId: widget.snapshot['User id'],
                      prescriptionId: widget.snapshot.id,
                    )));
                  },
                  label: "Prescriptions",
                ),),
                FadeAnimation2(1.4, CustomButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyLabReport(
                      familyMemberId: widget.snapshot['User id'],
                      reportId: widget.snapshot.id,
                    )));
                  },
                  label: "LabReport",
                ),)

              ],
            ),
          );
        }
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: kprimarycolor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
