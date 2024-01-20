import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/Shimmer/medication_shimmer.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/appointment_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({Key? key}) : super(key: key);

  @override
  _AllAppointmentScreenState createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen> {
  TextEditingController searchController = TextEditingController();
  String purpose = "";
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
                    purpose="";
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
                purpose = value;
              });
            },
          ),
        ),
        Flexible(child: StreamBuilder(
          stream: getAllAppointmentData(year),
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
                    "No Appointment data, Press '+' button to add Appointment",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
                itemBuilder: (context, int index){
                  if(purpose.isEmpty)
                  {
                    return AllAppointmentContainer(
                      snapshot: snapshot.data,
                      index: index,
                    );
                  }
                  if(snapshot.data.docs[index]['purpose'].toString().toLowerCase().startsWith(purpose.toLowerCase()) ||snapshot.data.docs[index]['Doctor name'].toString().toLowerCase().startsWith(purpose.toLowerCase()))
                  {
                    return AllAppointmentContainer(
                      snapshot: snapshot.data,
                      index: index,
                    );
                  }
                  else{
                    return Container();
                  }
                }
            );
          },
        )),
      ],
    );
  }
}
class AllAppointmentContainer extends StatelessWidget {
  const AllAppointmentContainer({Key? key,required this.snapshot,required this.index}) : super(key: key);
  final int index;
  final QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final docId=snapshot.docs[index].id;
    return InkWell(
      onTap: (){

      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1,color: Colors.grey,)),
        ),
        child: Column(
          children: [

            Row(
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
                        child: Icon(FontAwesomeIcons.userDoctor,
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
                        Text("Dr. ${snapshot.docs[index]['Doctor name'].toString().toCapitalized()}",
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
                              child: Text(snapshot.docs[index]["Hospital name"].toString().toCapitalized(),
                                style: const TextStyle(
                                  color: medicationsIconColor,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            const Icon(FontAwesomeIcons.eye,
                              color: medicationsIconColor,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(snapshot.docs[index]["purpose"],
                                style: const TextStyle(
                                  color: medicationsIconColor,
                                  fontSize: 16,
                                ),
                              overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                            Text("${snapshot.docs[index]["Appointment date"]}, ",
                              style: const TextStyle(
                                color: medicationsIconColor,
                                fontSize: 16,
                              ),),
                            Expanded(
                              child: Text(snapshot.docs[index]['Appointment time'],
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
                )),
                IconButton(onPressed: ()async{
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
                                    deleteAppointments(docId);
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
                }, icon: const Icon(Icons.delete_forever,size: 30))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(snapshot.docs[index]['Date'],style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

