import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Components/Shimmer/appointment_shimmer.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Screens/Appointments/appointment_status_screen.dart';
import 'package:fmaily_medical_history/Screens/Appointments/appointments.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/family_members.dart';
import 'package:fmaily_medical_history/Screens/Labreports/lab_report.dart';
import 'package:fmaily_medical_history/Screens/Medications/medications_screen.dart';
import 'package:fmaily_medical_history/Screens/Prescriptions/prescription.dart';
import 'package:fmaily_medical_history/Screens/search_screen.dart';
import 'package:fmaily_medical_history/Screens/Vaccinations/vaccination_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Controller/appointment_controller.dart';
import '../Notification/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool refresh=false;
  var healthTip=[
    'An apple a day keeps the doctor away.',
    'The greatest wealth is health.',
    'Heath is a relationship between you and your body.',
    'Drink a glass of water first thing in the morning.',
  ];
  final _random =  Random();
  var date=DateTime.now();
  storeNotificationToken()async{
    final userId=await getUserId();
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('User').doc(userId).set(
        {
          'token': token
        },SetOptions(merge: true));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeNotificationToken();


  }

  Future<void> _refresh() async {
    setState(() {
      refresh=!refresh;
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackButtonPress,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFE0E5FD),
          appBar: AppBar(
            title: const Text("Home",style: TextStyle(color: kprimarycolor),),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: (){
                ZoomDrawer.of(context)?.toggle();
              },
              icon: const Icon(Icons.menu,color: kprimarycolor,size: 35,),
            ),
            elevation: 0.0,
            actions: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchOtherScreen()));
              }, icon: const Icon(Icons.search,size: 30,color: kprimarycolor,),),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: ()async{
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>AppointmentStatus()));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.only(top: 20,left: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // border: Border.all(color: kprimarycolor,width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateFormat('d').format(date),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: kprimarycolor
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(DateFormat('MMM, yyyy').format(date),
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(DateFormat('EEEE').format(date),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),),
                                const SizedBox(
                                  height: 35,
                                ),
                                const Text("Health Tip:",
                                  style: TextStyle(
                                      color: kprimarycolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("\"${healthTip[_random.nextInt(healthTip.length)]}\"",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600
                                  ),),

                              ],
                            ),

                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            // border: Border.all(color: kprimarycolor,width: 2)
                          ),
                          child: Column(
                            children: [
                              const Text("Appointments",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kprimarycolor,
                                    fontSize: 20
                                ),),
                              const Divider(
                                thickness: 2,
                                height: 20,
                              ),
                              // Expanded(child: Center(
                              //   child: Text("No Appointment Found",style: TextStyle(
                              //     color: Colors.grey.shade600
                              //   ),),
                              // ),)
                              Flexible(child: StreamBuilder(
                                stream: refresh?getTodayAppointmentData():getTodayAppointmentData(),
                                builder: (context,AsyncSnapshot snapshot){
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return refeshShimmer();
                                  }
                                  if (snapshot.hasError) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Center(
                                        child: Text(
                                          "There was an unknown error while processing the request",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.data.docs.length == 0) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Center(
                                        child: Text(
                                          "No Today's Appointments",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  }
                                  return RefreshIndicator(
                                    color: kprimarycolor,
                                    onRefresh: _refresh,
                                    child: ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, int index){
                                          return TodayAppointmentContianer(
                                            index: index,
                                            snapshot: snapshot.data,
                                          );

                                        }
                                    ),
                                  );
                                },
                              ))
                            ],
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeAnimation(
                    1.4,
                    Row(
                      children: [
                        RepeatedButton(
                          icon: FontAwesomeIcons.capsules,
                          label: "Medications",
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const MedicationsScreen()));
                          },
                        ),
                        RepeatedButton(
                          icon: FontAwesomeIcons.filePrescription,
                          label: "Prescriptions",
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Prescription()));
                          },
                        ),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeAnimation(
                    1.6,
                    Row(
                      children: [
                        RepeatedButton(
                          icon: FontAwesomeIcons.file,
                          label: "Lab Reports",
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const LabReport()));
                          },
                        ),
                        RepeatedButton(
                          icon: Icons.vaccines,
                          label: "Vaccination",
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const VaccinationScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeAnimation(
                    1.8,
                    Row(
                      children: [
                        RepeatedButton(
                          icon: FontAwesomeIcons.calendarCheck,
                          label: "Appointments",
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Appointments()));
                          },
                        ),
                        RepeatedButton(
                          icon: Icons.family_restroom,
                          label: "Family Members",
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const FamilyMember()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> onBackButtonPress() async{
    bool exitApp=await showDialog(context: context, builder: (context){
      return  AlertDialog(
        content: const Text('Are you sure you want to close application?'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text('No',style: TextStyle(color: kprimarycolor),)),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: const Text('Yes',style: TextStyle(color: kprimarycolor)))
        ],
      );
    });
    return exitApp;
  }
}

class RepeatedButton extends StatelessWidget {
  const RepeatedButton({super.key, required this.label,required this.icon,required this.onpressed});
 final String label;
 final IconData icon;
 final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onpressed,
        child: Container(
          margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: kprimarycolor,
          borderRadius: BorderRadius.circular(12),
        ),
        // height: 138,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: Colors.white,size: 40,),
            const SizedBox(
              height: 10,
            ),
            Text(label,style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19
            ),),
          ],
        ),
    ),
      ),);
  }
}
class TodayAppointmentContianer extends StatelessWidget {
  const TodayAppointmentContianer({Key? key,required this.snapshot,required this.index}) : super(key: key);
  final QuerySnapshot snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.only(bottom: 8,left: 7),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: const Border(bottom: BorderSide(color: Colors.black12))
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.userDoctor,size: 15),
                const SizedBox(width: 10,),
                Expanded(child: Text('Dr. ${snapshot.docs[index]['Doctor name']}',maxLines: 1,overflow: TextOverflow.ellipsis,))
              ],
            ),
            Row(
              children: [
                const Icon(FontAwesomeIcons.eye,size: 15),
                const SizedBox(width: 10,),
                Expanded(child: Text('${snapshot.docs[index]['purpose']}',maxLines: 1,overflow: TextOverflow.ellipsis))
              ],
            ),
            Row(
              children: [
                const Icon(FontAwesomeIcons.clock,size: 15),
                const SizedBox(width: 10,),
                Expanded(child: Text('${snapshot.docs[index]['Appointment time']}',maxLines: 1,overflow: TextOverflow.ellipsis))
              ],
            ),

          ],
        ),
      )
    );
  }
}

