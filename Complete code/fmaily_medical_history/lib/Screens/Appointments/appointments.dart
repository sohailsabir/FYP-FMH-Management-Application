
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Screens/Appointments/all_appointment.dart';
import 'package:fmaily_medical_history/Screens/Appointments/add_appointsments.dart';
import 'package:fmaily_medical_history/Screens/Appointments/upcoming_appointment.dart';

import '../../Constants/constant.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int screenIndex=0;
  List<Widget> screen=[
    const UpcomingAppointmentScreen(),
    const AllAppointmentScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: kprimarycolor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon:const Icon(Icons.home), ),
        ],
      ),
      body: screen[screenIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: kprimarycolor,
          tooltip: "Add Appointments",
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddAppointments()));
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        color: kprimarycolor,
        child: Container(
          padding: const EdgeInsets.only(right: 60),
          child: BottomNavigationBar(
            currentIndex: screenIndex,
            onTap: (val){
              setState(() {
                screenIndex=val;
              });
            },
            backgroundColor: kprimarycolor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            selectedFontSize: 18,
            unselectedFontSize: 18,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            items: const [
              BottomNavigationBarItem(icon: SizedBox.shrink(),label: 'Upcoming'),
              BottomNavigationBarItem(icon: SizedBox.shrink(),label: 'All'),

            ],
          ),
        ),
      ),
    );
  }
}
