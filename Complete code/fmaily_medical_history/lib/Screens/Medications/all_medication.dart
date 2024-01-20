import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Screens/Medications/edit_medication_screen.dart';
import 'package:fmaily_medical_history/Controller/medication_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../Constants/constant.dart';
import '../../Components/Shimmer/medication_shimmer.dart';

class AllMedicationScreen extends StatefulWidget {
  const AllMedicationScreen({Key? key}) : super(key: key);

  @override
  _AllMedicationScreenState createState() => _AllMedicationScreenState();
}

class _AllMedicationScreenState extends State<AllMedicationScreen> {
  bool checkCancelIcon = false;
  TextEditingController searchController = TextEditingController();
  String mName = "";
  DateTime? pickDate;
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Column(
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
              stream: getAllMedicationData(year),
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
                        "No medications data, Press '+' button to add medications",
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
                      return AllMedicationContainer(
                        snapshot: snapshot.data,
                        index: index,
                      );
                    }
                    if(snapshot.data.docs[index]['Medicine name'].toString().toLowerCase().startsWith(mName.toLowerCase()) ||snapshot.data.docs[index]['Disease'].toString().toLowerCase().startsWith(mName.toLowerCase())||snapshot.data.docs[index]['Doctor name'].toString().toLowerCase().startsWith(mName.toLowerCase()))
                    {
                      return AllMedicationContainer(
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
    );
  }
}
class AllMedicationContainer extends StatelessWidget {
  const AllMedicationContainer({Key? key,required this.snapshot,required this.index}) : super(key: key);
  final int index;
  final QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final docId=snapshot.docs[index].id;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditMedication(medicineName: snapshot.docs[index]['Medicine name'], endDate: snapshot.docs[index]['End date'], startDate: snapshot.docs[index]['Start date'], contactNo: snapshot.docs[index]['Contact no'], disease: snapshot.docs[index]['Disease'], doctorName: snapshot.docs[index]['Doctor name'], hAddress: snapshot.docs[index]['Hospital address'], hospitalName: snapshot.docs[index]['Hospital name'], schedule: snapshot.docs[index]['Take medicine'], specialization: snapshot.docs[index]['Specialization'],docId: docId,)));
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
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.zero,
                            content: SizedBox(
                              width: 340,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditMedication(medicineName: snapshot.docs[index]['Medicine name'], endDate: snapshot.docs[index]['End date'], startDate: snapshot.docs[index]['Start date'], contactNo: snapshot.docs[index]['Contact no'], disease: snapshot.docs[index]['Disease'], doctorName: snapshot.docs[index]['Doctor name'], hAddress: snapshot.docs[index]['Hospital address'], hospitalName: snapshot.docs[index]['Hospital name'], schedule: snapshot.docs[index]['Take medicine'], specialization: snapshot.docs[index]['Specialization'],docId: docId,)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 15, top: 15),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.edit,
                                            size: 30,
                                            color: kprimarycolor,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kprimarycolor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
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
                                                        deleteMedication(docId);
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
                                      padding: const EdgeInsets.only(left: 15, top: 8),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.delete_forever_rounded,
                                            size: 30,
                                            color: kprimarycolor,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kprimarycolor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Share.share("Medication Data\nMedicine name: ${snapshot.docs[index]["Medicine name"]}\nDisease: ${snapshot.docs[index]['Disease']}\nDoctor name: Dr. ${snapshot.docs[index]['Doctor name']}",subject: "Medication Data");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 15, top: 8),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.share,
                                            size: 30,
                                            color: kprimarycolor,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Share",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kprimarycolor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 8, bottom: 10),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.cancel,
                                            size: 30,
                                            color: kprimarycolor,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kprimarycolor),
                                          )
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