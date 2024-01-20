import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/add_family_member.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/family_member_home.dart';
import 'package:fmaily_medical_history/Screens/FamilyMembers/view_member_profile.dart';

import '../../Components/Shimmer/medication_shimmer.dart';

class FamilyMember extends StatefulWidget {
  const FamilyMember({Key? key}) : super(key: key);

  @override
  _FamilyMemberState createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text("Family Members"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home))
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: kprimarycolor,
          tooltip: "Add Family Member",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFamilyMember()));
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: getFamilyMember(),
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
                  "No data, Press '+' button to add family member",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,int index){
             return CustomFamilyMemberCard(index: index, snapshot: snapshot.data);
            },
          );
        },
      ),
    );
  }
}
class CustomFamilyMemberCard extends StatelessWidget {
  const CustomFamilyMemberCard({super.key, required this.index,required this.snapshot});
  final int index;
  final QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FamilyMemberData(snapshot: snapshot.docs[index],)));
      },
      child: FadeAnimation2(
        1.2,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: kprimarycolor,
                    radius: 35,
                    child: Text('${snapshot.docs[index]['First name'][0].toString().toCapitalized()}${snapshot.docs[index]['Last name'][0].toString().toCapitalized()}',style: const TextStyle(fontSize: 25, color: Colors.white),),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text('${snapshot.docs[index]['First name'].toString().toCapitalized().trim()} ${snapshot.docs[index]['Last name'].toString().toCapitalized()}',
                    style: const TextStyle(
                    fontSize: 20,),
                      maxLines: 1,
                    ),

                  ),
                  IconButton(onPressed: (){
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewMemberProfile(snapshot: snapshot.docs[index])));
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
                  }, icon: const Icon(Icons.more_vert,size: 35,))


                ],
              ),),
            ],
          ),
        ),
      ),
    );
  }
}

