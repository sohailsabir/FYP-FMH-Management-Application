import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/customDialog.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Services/PDF/vaccination_pdf.dart';
import 'package:intl/intl.dart';

import '../../../Controller/firebase_authentication.dart';


class FamilyVaccinationCustomPDF extends StatefulWidget {
  const FamilyVaccinationCustomPDF({Key? key,required this.familyId}) : super(key: key);
  final String familyId;

  @override
  _FamilyVaccinationCustomPDFState createState() => _FamilyVaccinationCustomPDFState();
}

class _FamilyVaccinationCustomPDFState extends State<FamilyVaccinationCustomPDF> {
  List pdfdata = [];
  var userData;
  final PdfserviceVaccination _pdfserviceVaccination=PdfserviceVaccination();
  DateTime? pickDate1;
  DateTime? pickDate2;
  TextEditingController startDate=TextEditingController();
  TextEditingController endDate=TextEditingController();
  getMedicationData(var sDate,var eDate)async{
    pdfdata=[];
    final uid=await getUserId();
    await FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(widget.familyId).collection('Vaccination').get().then((value){
      for(var i in value.docs)
      {
        var checkData=i.data();
        String inputDate=checkData['Date'];
        DateTime parseDate=DateFormat('yyyy-MM-dd').parse(inputDate);
        if(parseDate.isAfter(sDate) && parseDate.isBefore(eDate))
        {
          pdfdata.add(i.data());
        }
      }

    });
  }
  getUserData()async{
    final uid=await getUserId();
    await FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(widget.familyId).get().then((value){
      setState(() {
        userData=value.data();
      });
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Custom Generated Report",style: TextStyle(
          color: kprimarycolor,
        ),),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: kprimarycolor
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40,),
                const Text('Start Date',style: TextStyle(
                  color: kprimarycolor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: startDate,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.calendar_today_rounded,
                      color: kprimarycolor,
                    ),
                    hintText: "Start Date",
                    hintStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: kprimarycolor, width: 2.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        const BorderSide(color: kprimarycolor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 2.3, color: kprimarycolor),
                    ),
                  ),
                  onTap: ()async{
                    pickDate1=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now(),
                      builder: ((context, child){
                        return Theme(data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: kprimarycolor,
                            onPrimary: Colors.white,
                            onSurface: kprimarycolor,
                          ),
                        ), child: child!);
                      }),
                    );
                    if(pickDate1!=null)
                    {
                      setState(() {
                        startDate.text=DateFormat('yyyy-MM-dd').format(pickDate1!);
                      });
                    }
                  },
                ),
                const SizedBox(height: 15,),
                const Text('End Date',style: TextStyle(
                  color: kprimarycolor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: endDate,
                  readOnly: true,
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(
                      Icons.calendar_today_rounded,
                      color: kprimarycolor,
                    ),
                    hintText: "End Date",
                    hintStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: kprimarycolor, width: 2.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        const BorderSide(color: kprimarycolor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 2.3, color: kprimarycolor),
                    ),
                  ),
                  onTap: ()async{
                    pickDate2=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now(),
                      builder: ((context, child){
                        return Theme(data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: kprimarycolor,
                            onPrimary: Colors.white,
                            onSurface: kprimarycolor,
                          ),
                        ), child: child!);
                      }),
                    );
                    if(pickDate2!=null)
                    {
                      setState(() {
                        endDate.text=DateFormat('yyyy-MM-dd').format(pickDate2!);
                      });
                    }
                  },
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: startDate.text.isNotEmpty && endDate.text.isNotEmpty?()async{
              var sDate=  DateTime(pickDate1!.year, pickDate1!.month, pickDate1!.day-1);
              var eDate=  DateTime(pickDate2!.year, pickDate2!.month, pickDate2!.day+1);
              if(sDate.isBefore(eDate))
              {
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

                await getMedicationData(sDate,eDate);
                await getUserData();
                if(pdfdata.isNotEmpty && userData.isNotEmpty)
                {
                  final data=await _pdfserviceVaccination.createPdf(pdfdata,userData,'Date of Birth');
                  _pdfserviceVaccination.saveAndLanchFile(data, "MedicationReport.pdf");
                  pdfdata.clear();

                }
                else{
                  showDialog(context: context, builder: (context){
                    return customDialog(message: 'No data available to generate report ', icon: Icons.error, title: 'Error');
                  });
                }
              }
              else{
                showDialog(context: context, builder: (context){
                  return customDialog(message: "Start date can't after the End date", icon: Icons.error, title: 'Alert');
                });
              }
            }:null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimarycolor,
                foregroundColor: Colors.white,
                minimumSize: const Size(350, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                elevation: 0.0,
              ),
              child: const Text("Continue"),),
          ),
        ],
      ),
    );
  }
}
