import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/Loading/loading.dart';
import 'package:fmaily_medical_history/Components/showMessage/customDialog.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Screens/Medications/add_medicine_screen.dart';
import 'package:fmaily_medical_history/Screens/Medications/medication_pdf_custom.dart';
import 'package:fmaily_medical_history/Services/PDF/medication_pdf.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'all_medication.dart';
import 'current_medication.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({Key? key}) : super(key: key);

  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List pdfdata = [];
  var userData;
  final PdfservicesMedication _pdfservicesMedication=PdfservicesMedication();
  int screenIndex=0;
  List<Widget> screen=[
    const CurrentMedicationScreen(),
    const AllMedicationScreen(),
  ];
  getMedicationData(int num)async{
    pdfdata=[];
    final uid=await getUserId();
    await FirebaseFirestore.instance.collection('User').doc(uid).collection('Medication').get().then((value){
      if(num==1)
        {
          for(var i in value.docs)
          {
            var checkData=i.data();
            String inputDate=checkData['Date'];
            DateTime parseDate=DateFormat('yyyy-MM-dd').parse(inputDate);
            var newDate=DateTime.now();
            var prevMonth =  DateTime(newDate.year, newDate.month-3, newDate.day);
            if(parseDate.isAfter(prevMonth))
              {
                pdfdata.add(i.data());
              }
          }
        }
      if(num==2)
      {
        for(var i in value.docs)
        {
          var checkData=i.data();
          String inputDate=checkData['Date'];
          DateTime parseDate=DateFormat('yyyy-MM-dd').parse(inputDate);
          var newDate=DateTime.now();
          var prevMonth =  DateTime(newDate.year, newDate.month-6, newDate.day);
          if(parseDate.isAfter(prevMonth))
          {
            pdfdata.add(i.data());
          }
        }
      }
      if(num==3)
      {
        for(var i in value.docs)
        {
          var checkData=i.data();
          String inputDate=checkData['Date'];
          DateTime parseDate=DateFormat('yyyy-MM-dd').parse(inputDate);
          var newDate=DateTime.now();
          var prevMonth =  DateTime(newDate.year, newDate.month-9, newDate.day);
          if(parseDate.isAfter(prevMonth))
          {
            pdfdata.add(i.data());
          }
        }
      }

    });
  }
  getUserData()async{
    final uid=await getUserId();
    await FirebaseFirestore.instance.collection('User').doc(uid).get().then((value){
    setState(() {
      userData=value.data();
    });
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    bool showFab=MediaQuery.of(context).viewInsets.bottom!=0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text("Medications"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        actions: [
          IconButton(onPressed: ()async{
            showDialog(context: context, builder: (context){
              return AlertDialog(
                titlePadding: const EdgeInsets.only(top: 2),
                title: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.cancel,color: Color(0xFFC8CDCF),),
                        onPressed: (){
                          Navigator.pop(context);
                        },

                      ),
                    ),
                    const Icon(FontAwesomeIcons.download,color: kprimarycolor,size: 40,),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(child: Text('Generate Report',style: TextStyle(
                        fontSize: 20
                    ),)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: ()async{
                        Navigator.pop(context);
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context){
                          return AlertDialog(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircularProgressIndicator(color: kprimarycolor,),
                                SizedBox(width: 15,),
                                Text('Please wait...')
                              ],
                            ),
                          );
                        });
                        await getMedicationData(1);
                        await getUserData();
                        if(pdfdata.isNotEmpty && userData.isNotEmpty)
                          {
                            final data=await _pdfservicesMedication.createPdf(pdfdata,userData,'Date of Birth');
                        _pdfservicesMedication.saveAndLanchFile(data, "MedicationReport.pdf");
                            pdfdata.clear();

                          }
                        else{
                          showDialog(context: context, builder: (context){
                            return customDialog(message: 'No data available to generate report ', icon: Icons.error, title: 'Error');
                          });
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8CDCF),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(350, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                        elevation: 0.0,
                      ),
                      child: const Text('Last Three Months'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        Navigator.pop(context);
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context){
                              return AlertDialog(
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    CircularProgressIndicator(color: kprimarycolor,),
                                    SizedBox(width: 15,),
                                    Text('Please wait...')
                                  ],
                                ),
                              );
                            });
                        await getMedicationData(2);
                        await getUserData();
                        if(pdfdata.isNotEmpty && userData.isNotEmpty)
                        {
                          final data=await _pdfservicesMedication.createPdf(pdfdata,userData,'Date of Birth');
                          _pdfservicesMedication.saveAndLanchFile(data, "MedicationReport.pdf");
                          pdfdata.clear();

                        }
                        else{
                          showDialog(context: context, builder: (context){
                            return customDialog(message: 'No data available to generate report ', icon: Icons.error, title: 'Error');
                          });
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8CDCF),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(350, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                        elevation: 0.0,
                      ),
                      child: const Text('Last Six Months'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        Navigator.pop(context);
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context){
                              return AlertDialog(
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    CircularProgressIndicator(color: kprimarycolor,),
                                    SizedBox(width: 15,),
                                    Text('Please wait...')
                                  ],
                                ),
                              );
                            });
                        await getMedicationData(3);
                        await getUserData();
                        if(pdfdata.isNotEmpty && userData.isNotEmpty)
                        {
                          final data=await _pdfservicesMedication.createPdf(pdfdata,userData,'Date of Birth');
                          _pdfservicesMedication.saveAndLanchFile(data, "MedicationReport.pdf");
                          pdfdata.clear();

                        }
                        else{
                          showDialog(context: context, builder: (context){
                            return customDialog(message: 'No data available to generate report ', icon: Icons.error, title: 'Error');
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8CDCF),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(350, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                        elevation: 0.0,
                      ),
                      child: const Text('Last Nine Months'),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const MedicationCustomPDF()));
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimarycolor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(350, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                        elevation: 0.0,
                      ),
                      child: const Text("Custom"),),
                  ),
                ],
                alignment: Alignment.bottomCenter,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                insetPadding: const EdgeInsets.all(10),

              );
            });

          }, icon: const Icon(Icons.picture_as_pdf),),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.home),),
        ],
      ),
      body: SafeArea(child: screen[screenIndex]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: Visibility(
          visible: !showFab,
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: kprimarycolor,
            tooltip: "Add Medication",
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddMedicineScreen()));
            },
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        color: kprimarycolor,
        child: Padding(
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
              BottomNavigationBarItem(icon: SizedBox.shrink(),label: 'Current'),
              BottomNavigationBarItem(icon: SizedBox.shrink(),label: 'All'),
            ],
          ),
        ),
      ),
    );
  }
}
