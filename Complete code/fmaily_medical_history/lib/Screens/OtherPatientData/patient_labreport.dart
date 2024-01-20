
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Controller/patient_view_controller.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/view_patient_labreport.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Components/Loading/loading.dart';
import '../../Components/Shimmer/medication_shimmer.dart';
import '../../Constants/constant.dart';

class PatientLabReport extends StatefulWidget {
  const PatientLabReport({Key? key,required this.patientId}) : super(key: key);
  final String patientId;

  @override
  _PatientLabReportState createState() => _PatientLabReportState();
}

class _PatientLabReportState extends State<PatientLabReport> {
  TextEditingController searchController=TextEditingController();
  String search="";
  DateTime? pickDate;
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text("Lab Reports"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      search="";
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
                  search = value;
                });
              },
            ),
          ),
          Flexible(
              child: StreamBuilder(
                stream: getPatientLabReportData(year, widget.patientId),
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
                          "No Lab Report data available.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,int index){
                      if(search.isEmpty)
                      {
                        return CustomPatientLabReportCard(
                            snapshot: snapshot.data,
                            index: index
                        );
                      }
                      if(snapshot.data.docs[index]['Report title'].toString().toLowerCase().startsWith(search.toLowerCase()) ||snapshot.data.docs[index]['Laboratory name'].toString().toLowerCase().startsWith(search.toLowerCase()))
                      {
                        return CustomPatientLabReportCard(
                            snapshot: snapshot.data,
                            index: index
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
class CustomPatientLabReportCard extends StatelessWidget {
  const CustomPatientLabReportCard({super.key, required this.snapshot,required this.index});
  final int index;
  final QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowPatientLabReport(imageUrl: snapshot.docs[index]['image'])));
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 70,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ]
                      ),
                      child: CachedNetworkImage(
                          imageUrl: '${snapshot.docs[index]['image']}',
                          key: UniqueKey(),
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) => const Image(image: AssetImage('assets/ImageError.png'),),
                          placeholder: (context, url) => loadingImage),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.docs[index]['Report title'].toString().toCapitalized(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
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
                                child: Text(snapshot.docs[index]['Laboratory name'].toString().toCapitalized(),
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
                            height: 5,
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
                              Text(snapshot.docs[index]['date'],
                                style: const TextStyle(
                                  color: medicationsIconColor,
                                  fontSize: 16,
                                ),),
                            ],
                          ),
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
