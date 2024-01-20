

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Components/Loading/loading.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberPrescription/family_edit_prescription.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/FamilyMemberPrescription/family_member_add_prescription.dart';
import 'package:fmaily_medical_history/Screens/Prescriptions/show_prescription.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/prescription_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/Shimmer/medication_shimmer.dart';
class FamilyMemberPrescription extends StatefulWidget {
  const FamilyMemberPrescription({Key? key,required this.familyMemberId,required this.prescriptionId}) : super(key: key);
  final String familyMemberId;
  final String prescriptionId;

  @override
  _FamilyMemberPrescriptionState createState() => _FamilyMemberPrescriptionState();
}
class _FamilyMemberPrescriptionState extends State<FamilyMemberPrescription> {
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
        title: const Text("Prescriptions"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
            icon: const Icon(Icons.home),),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: kprimarycolor,
          tooltip: "Add Prescription",
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddFamilyPrescription(
                prescriptionId: widget.prescriptionId,
                familyMemberId: widget.familyMemberId)));
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  search = value;
                });
              },
            ),
          ),
          Flexible(
              child: StreamBuilder(
                stream: getFamilyPrescriptionData(year, widget.familyMemberId, widget.prescriptionId),
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
                          "No Prescription data, Press '+' button to add Prescription",
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
                        return CustomPrescriptionCard(
                            snapshot: snapshot.data,
                            index: index,
                          prescriptionId: widget.prescriptionId,
                          familyMemberId: widget.familyMemberId,
                        );
                      }
                      if(snapshot.data.docs[index]['Disease'].toString().toLowerCase().startsWith(search.toLowerCase()) ||snapshot.data.docs[index]['Doctor name'].toString().toLowerCase().startsWith(search.toLowerCase()))
                      {
                        return CustomPrescriptionCard(
                            snapshot: snapshot.data,
                            index: index,
                          prescriptionId: widget.prescriptionId,
                          familyMemberId: widget.familyMemberId,
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
class CustomPrescriptionCard extends StatelessWidget {
  const CustomPrescriptionCard({super.key, required this.snapshot,required this.index,required this.familyMemberId,required this.prescriptionId});
  final int index;
  final QuerySnapshot snapshot;
  final String familyMemberId;
  final String prescriptionId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowPrescription(imageUrl: snapshot.docs[index]['image'])));
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
                          Text(snapshot.docs[index]['Disease'].toString().toCapitalized(),
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
                              const Icon(FontAwesomeIcons.userDoctor,
                                color: medicationsIconColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text("Dr. ${snapshot.docs[index]['Doctor name']}",
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
                                FontAwesomeIcons.hospital,
                                color: medicationsIconColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(snapshot.docs[index]['Hospital name'],
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyEditPrescription(
                                    disease: snapshot.docs[index]['Disease'],
                                    hName: snapshot.docs[index]['Hospital name'],
                                    dName: snapshot.docs[index]['Doctor name'],
                                    exitingUrl: snapshot.docs[index]['image'],
                                    docId: snapshot.docs[index].id,
                                    familyMemberId: familyMemberId,
                                    prescriptionId: prescriptionId,
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
                                                    showDialog(
                                                        barrierDismissible: false,
                                                        context: context, builder: (context){
                                                      return AlertDialog(
                                                        content: Row(
                                                          children: const [
                                                            CircularProgressIndicator(color: kprimarycolor),
                                                            SizedBox(width: 15,),
                                                            Text('Please wait...'),
                                                          ],
                                                        ),

                                                      );
                                                    });
                                                    deleteFamilyPrescriptionData(snapshot.docs[index]['image'], snapshot.docs[index].id,context,familyMemberId,prescriptionId);
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
                                onTap: ()async{
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context, builder: (context){
                                    return AlertDialog(
                                      content: Row(
                                        children: const [
                                          CircularProgressIndicator(color: kprimarycolor),
                                          SizedBox(width: 15,),
                                          Text('Please wait...'),
                                        ],
                                      ),

                                    );
                                  });
                                  final uri=Uri.parse(snapshot.docs[index]['image']);
                                  final res=await http.get(uri);
                                  Navigator.pop(context);
                                  final bytes=res.bodyBytes;
                                  final temp=await getTemporaryDirectory();
                                  final path='${temp.path}/image.jpg';
                                  File(path).writeAsBytes(bytes);
                                  await Share.shareFiles([path]);
                                  Navigator.pop(context);
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
