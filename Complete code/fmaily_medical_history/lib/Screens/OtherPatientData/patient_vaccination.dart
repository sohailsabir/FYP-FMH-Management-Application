import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Components/Shimmer/medication_shimmer.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/patient_view_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientVaccinationScreen extends StatefulWidget {
  const PatientVaccinationScreen({Key? key,required this.patientId}) : super(key: key);
  final String patientId;

  @override
  _PatientVaccinationScreenState createState() => _PatientVaccinationScreenState();
}

class _PatientVaccinationScreenState extends State<PatientVaccinationScreen> {
  TextEditingController searchController=TextEditingController();
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;
  String vName="";
  DateTime? pickDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Vaccination"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: TextField(
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
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
            stream: getPatientVaccinationData(year, widget.patientId),
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
                      "No Vaccinations data available.",
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
                      return PatientVaccinationContainer(
                        snapshot: snapshot.data,
                        index: index,
                      );
                    }
                    if(snapshot.data.docs[index]['Vaccination name'].toString().toLowerCase().startsWith(vName.toLowerCase()))
                    {
                      return PatientVaccinationContainer(
                        snapshot: snapshot.data,
                        index: index,
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
class PatientVaccinationContainer extends StatelessWidget {
  const PatientVaccinationContainer({Key? key,required this.snapshot,required this.index}) : super(key: key);
  final QuerySnapshot snapshot;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            ],
          ),
        ),
      ),
    );
  }
}


