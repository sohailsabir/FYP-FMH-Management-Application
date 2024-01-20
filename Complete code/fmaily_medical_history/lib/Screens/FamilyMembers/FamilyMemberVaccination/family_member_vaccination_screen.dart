import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Components/Shimmer/medication_shimmer.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberMedication/family_medication_pdf.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberVaccination/AddFamilyMemberVaccination.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberVaccination/family_edit_vaccination.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberVaccination/family_vaccination_pdf.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/showMessage/customDialog.dart';
import '../../../Controller/family_member_controller.dart';
import '../../../Controller/firebase_authentication.dart';
import '../../../Services/PDF/vaccination_pdf.dart';

class FamilyVaccinationScreen extends StatefulWidget {
  const FamilyVaccinationScreen({Key? key,required this.familyMemberId,required this.vaccinationId}) : super(key: key);
  final String familyMemberId;
  final String vaccinationId;

  @override
  _FamilyVaccinationScreenState createState() => _FamilyVaccinationScreenState();
}

class _FamilyVaccinationScreenState extends State<FamilyVaccinationScreen> {
  List pdfdata = [];
  var userData;
  final PdfserviceVaccination _pdfserviceVaccination =PdfserviceVaccination();
  TextEditingController searchController=TextEditingController();
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;
  String vName="";
  DateTime? pickDate;
  getMedicationData(int num)async{
    pdfdata=[];
    final uid=await getUserId();
    await FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(widget.familyMemberId).collection('Vaccination').get().then((value){
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
    await FirebaseFirestore.instance.collection('User').doc(uid).collection('Family member').doc(widget.familyMemberId).get().then((value){
      setState(() {
        userData=value.data();
      });
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Vaccination"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        actions: [
          IconButton(
              onPressed: ()async{
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
                              final data=await _pdfserviceVaccination.createPdf(pdfdata,userData,'Date of Birth');
                              _pdfserviceVaccination.saveAndLanchFile(data, "VaccinationReport.pdf");
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
                              final data=await _pdfserviceVaccination.createPdf(pdfdata,userData,'Date of Birth');
                              _pdfserviceVaccination.saveAndLanchFile(data, "MedicationReport.pdf");
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
                              final data=await _pdfserviceVaccination.createPdf(pdfdata,userData,'Date of Birth');
                              _pdfserviceVaccination.saveAndLanchFile(data, "MedicationReport.pdf");
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
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> FamilyVaccinationCustomPDF(familyId: widget.familyMemberId)));
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
              },
              icon: const Icon(Icons.picture_as_pdf)),
          IconButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: kprimarycolor,
          tooltip: "Add Vaccination",
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFamilyVaccination(vaccinationId: widget.vaccinationId, familyMemberId: widget.familyMemberId)));
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextField(
              cursorColor: kprimarycolor,
              controller: searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: kprimarycolor,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(FontAwesomeIcons.calendarDays,color: kprimarycolor,),
                  onPressed: ()async{
                    setState(() {
                      searchController.clear();
                      vName="";
                      FocusManager.instance.primaryFocus!.unfocus();
                    });
                    pickDate= await showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text("Select Year"),
                        content: SizedBox(
                          width: 300,
                          height: 300,
                          child: Theme(
                            data: ThemeData(
                                colorScheme: const ColorScheme.light(primary: kprimarycolor),
                                buttonTheme: const ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary,
                                  buttonColor: kprimarycolor,
                                )
                            ),
                            child: YearPicker(
                              firstDate: DateTime(2022),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              selectedDate: selectedYear,
                              onChanged: (DateTime dateTime){
                                setState(() {
                                  selectedYear=dateTime;
                                  year=selectedYear.year;
                                });
                                Navigator.pop(context);
                              },


                            ),
                          ),

                        ),
                      );
                    });
                  },
                ),
                hintText: "Search Here",
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
              onChanged: (value) {
                setState(() {
                  vName = value;
                });

              },
            ),
          ),
          Flexible(child: StreamBuilder(
            stream: getFamilyAllVaccinationData(year,widget.vaccinationId),
            builder: (context,AsyncSnapshot snapshot){
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
              if (snapshot.data.docs.length == 0) {
                return Container(
                  padding: const EdgeInsets.all(50),
                  child: const Center(
                    child: Text(
                      "No Vaccinations data, Press '+' button to add Vaccinations",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,int index){
                    if(vName.isEmpty)
                    {
                      return VaccinationContainer(
                        snapshot: snapshot.data,
                        index: index,
                        familyMemberId: widget.familyMemberId,
                        vaccinationId: widget.vaccinationId,
                      );
                    }
                    if(snapshot.data.docs[index]['Vaccination name'].toString().toLowerCase().startsWith(vName.toLowerCase()))
                    {
                      return VaccinationContainer(
                        snapshot: snapshot.data,
                        index: index,
                        familyMemberId: widget.familyMemberId,
                        vaccinationId: widget.vaccinationId,
                      );
                    }
                    else{
                      return Container();
                    }



                  });
            },
          )),
        ],
      ),
    );
  }
}
class VaccinationContainer extends StatelessWidget {
  const VaccinationContainer({Key? key,required this.snapshot,required this.index,required this.familyMemberId,required this.vaccinationId}) : super(key: key);
  final QuerySnapshot snapshot;
  final int index;
  final String vaccinationId;
  final String familyMemberId;
  @override
  Widget build(BuildContext context) {
    final docId=snapshot.docs[index].id;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyEditVaccination(
          hName: snapshot.docs[index]['Hospital name'],
          vName: snapshot.docs[index]['Vaccination name'],
          vDate: snapshot.docs[index]['Vaccination date'],
          id: snapshot.docs[index].id,
          vtime: snapshot.docs[index]["Vaccination time"],
          vaccinationId: vaccinationId,
          familyMemberId: familyMemberId,
        )));
      },
      child: FadeAnimation2(
        1.2,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1,color: Colors.grey,)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: backColor,
                    radius: 30,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 28,
                      child: Icon(Icons.vaccines,
                        size: 35,
                        color: kprimarycolor,),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.docs[index]['Vaccination name'].toString().toCapitalized(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.hospital,
                            color: medicationsIconColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(snapshot.docs[index]['Hospital name'].toString().toCapitalized(),
                              style: const TextStyle(
                                color: medicationsIconColor,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.calendar,
                            color: medicationsIconColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("${snapshot.docs[index]['Date']}, ",
                            style: const TextStyle(
                              color: medicationsIconColor,
                              fontSize: 16,
                            ),),
                          Expanded(
                            child: Text(snapshot.docs[index]['Vaccination time'],
                              style: const TextStyle(
                                color: medicationsIconColor,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                            ),
                          ),
                        ],
                      ),
                    ],
                  )),

                ],
              )),
              IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        contentPadding: EdgeInsets.zero,
                        content: SizedBox(
                          width: 340,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyEditVaccination(
                                    hName: snapshot.docs[index]['Hospital name'],
                                    vName: snapshot.docs[index]['Vaccination name'],
                                    vDate: snapshot.docs[index]['Vaccination date'],
                                    id: snapshot.docs[index].id,
                                    vtime: snapshot.docs[index]["Vaccination time"],
                                    vaccinationId: vaccinationId,
                                    familyMemberId: familyMemberId,
                                  )));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15,top: 15),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit,size: 30,color: kprimarycolor,),
                                      SizedBox(width: 15,),
                                      Text("Edit",style: TextStyle(fontSize: 18,color: kprimarycolor),)
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                      insetPadding: const EdgeInsets.all(10),
                                      contentPadding: const EdgeInsets.only(left: 40,right: 40,bottom: 30,top: 30),
                                      content:  Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text("Are you sure you want to delete ?"),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    deleteFamilyVaccination(snapshot.docs[index].id, familyMemberId, vaccinationId);
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  child: const Text("Yes",style: TextStyle(
                                                    fontSize: 14,
                                                  ),),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: kprimarycolor,
                                                  ),
                                                  child: const Text("No",style: TextStyle(
                                                    fontSize: 14,
                                                  ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    );
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15,top: 8),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete_forever_rounded,size: 30,color: kprimarycolor,),
                                      SizedBox(width: 15,),
                                      Text("Delete",style: TextStyle(fontSize: 18,color: kprimarycolor),)
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                  Share.share("Vaccination Data\nVaccination: ${snapshot.docs[index]["Vaccination name"]}\nHospital: ${snapshot.docs[index]['Hospital name']}\nDate: ${snapshot.docs[index]['Vaccination date']}\nTime: ${snapshot.docs[index]['Vaccination time']}",subject: "Vaccination Data");
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15,top: 8),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.share,size: 30,color: kprimarycolor,),
                                      SizedBox(width: 15,),
                                      Text("Share",style: TextStyle(fontSize: 18,color: kprimarycolor),)
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15,top: 8,bottom: 10),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.cancel,size: 30,color: kprimarycolor,),
                                      SizedBox(width: 15,),
                                      Text("Cancel",style: TextStyle(fontSize: 18,color: kprimarycolor),)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    size: 25,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}


