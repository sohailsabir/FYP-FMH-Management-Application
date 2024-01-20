import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Controller/patient_view_controller.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/view_patient_medication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Constants/constant.dart';
import '../../Components/Shimmer/medication_shimmer.dart';

class PatientMedicationScreen extends StatefulWidget {
  const PatientMedicationScreen({Key? key,required this.patientId}) : super(key: key);
  final String patientId;

  @override
  _PatientMedicationScreenState createState() => _PatientMedicationScreenState();
}

class _PatientMedicationScreenState extends State<PatientMedicationScreen> {
  bool checkCancelIcon = false;
  TextEditingController searchController = TextEditingController();
  String mName = "";
  DateTime? pickDate;
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;
  @override
  void dispose() {

    super.dispose();
    FocusManager.instance.primaryFocus!.unfocus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text("Medication"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        leading: InkWell(
          onTap: (){
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
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
                      mName="";
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
                  mName = value;
                });
                if (mName.isNotEmpty) {
                  setState(() {
                    checkCancelIcon = true;
                  });
                } else {
                  setState(() {
                    checkCancelIcon = false;
                  });
                }
              },
            ),
          ),
          Flexible(
              child: StreamBuilder(
                stream: getPatientMedicationData(year, widget.patientId),
                builder: (context, AsyncSnapshot snapshot){
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
                          "No medications data available.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,int index){
                      if(mName.isEmpty)
                      {
                        return PatientMedicationContainer(
                          snapshot: snapshot.data,
                          index: index,
                        );
                      }
                      if(snapshot.data.docs[index]['Medicine name'].toString().toLowerCase().startsWith(mName.toLowerCase()) ||snapshot.data.docs[index]['Disease'].toString().toLowerCase().startsWith(mName.toLowerCase()) || snapshot.data.docs[index]['Doctor name'].toString().toLowerCase().startsWith(mName.toLowerCase()))
                      {
                        return PatientMedicationContainer(
                          snapshot: snapshot.data,
                          index: index,
                        );
                      }
                      else{
                        return Container();
                      }
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}
class PatientMedicationContainer extends StatelessWidget {
  const PatientMedicationContainer({Key? key,required this.snapshot,required this.index}) : super(key: key);
  final int index;
  final QuerySnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPatientMedication(
            medicineName: snapshot.docs[index]['Medicine name'],
            endDate: snapshot.docs[index]['End date'],
            startDate: snapshot.docs[index]['Start date'],
            contactNo: snapshot.docs[index]['Contact no'],
            disease: snapshot.docs[index]['Disease'],
            doctorName: snapshot.docs[index]['Doctor name'],
            hAddress: snapshot.docs[index]['Hospital address'],
            hospitalName: snapshot.docs[index]['Hospital name'],
            schedule: snapshot.docs[index]['Take medicine'],
            specialization: snapshot.docs[index]['Specialization'],)));
      },
      child: FadeAnimation2(
        1.2,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.grey,
                )),
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
                      child: Icon(
                        FontAwesomeIcons.capsules,
                        color: kprimarycolor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.docs[index]['Medicine name']
                            .toString()
                            .toCapitalized(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.sick_outlined,
                            color: medicationsIconColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              snapshot.docs[index]['Disease']
                                  .toString()
                                  .toCapitalized(),
                              style: const TextStyle(
                                color: medicationsIconColor,
                                fontSize: 16,
                              ),
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
                            FontAwesomeIcons.userDoctor,
                            color: medicationsIconColor,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Dr. ${snapshot.docs[index]['Doctor name'].toString().toCapitalized()}",
                              style: const TextStyle(
                                color: medicationsIconColor,
                                fontSize: 16,
                              ),
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
                          Text(
                            "${snapshot.docs[index]["Date"].toString().toCapitalized()}, ",
                            style: const TextStyle(
                              color: medicationsIconColor,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.docs[index]["Take medicine"],
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
                  ),),

                ],
              ),),
            ],
          ),
        ),
      ),
    );
  }
}