import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Screens/Appointments/appointments.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/family_members.dart';
import 'package:fmaily_medical_history/Screens/Labreports/lab_report.dart';
import 'package:fmaily_medical_history/Screens/Medications/medications_screen.dart';
import 'package:fmaily_medical_history/Screens/Prescriptions/prescription.dart';
import 'package:fmaily_medical_history/Screens/profile.dart';
import 'package:fmaily_medical_history/Screens/search_screen.dart';
import 'package:fmaily_medical_history/Screens/Vaccinations/vaccination_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Loading/loading.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  var snapshot;
  String image="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kprimarycolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Center(
                child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 39,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,size: 70,color: kprimarycolor,),
                      ),
                ),
              ),
              const SizedBox(
                height: 16,),
              Center(
                child: Text("${user!.email}",
                  style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(
                height: 20,
                color: Colors.white,
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Profile()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.account_box,color: Colors.white,size: 25,),
                          SizedBox(width: 20,),
                          Text("Profile",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        ZoomDrawer.of(context)?.toggle();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.home,color: Colors.white,size: 25,),
                          SizedBox(width: 20,),
                          Text("Home",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MedicationsScreen()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(FontAwesomeIcons.capsules,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Medications",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Prescription()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(FontAwesomeIcons.filePrescription,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Prescriptions",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LabReport()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(FontAwesomeIcons.file,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Lab Reports",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const VaccinationScreen()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.vaccines,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Vaccinations",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Appointments()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(FontAwesomeIcons.calendarCheck,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Appointments",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const FamilyMember()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.family_restroom,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Family Members",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchOtherScreen()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.search,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Search Others",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        logout(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.logout,color: drawerMenuColor,size: 25,),
                          SizedBox(width: 20,),
                          Text("Logout",style: TextStyle(
                            color: drawerMenuColor,
                            fontSize: 18,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
