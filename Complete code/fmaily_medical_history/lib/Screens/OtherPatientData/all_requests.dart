import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Components/Loading/loading.dart';
import '../../Components/Shimmer/medication_shimmer.dart';
import '../../Constants/constant.dart';
import '../../Controller/patient_view_controller.dart';
import '../../Services/push_notification.dart';


class AllRequestScreen extends StatefulWidget {
  const AllRequestScreen({Key? key}) : super(key: key);

  @override
  _AllRequestScreenState createState() => _AllRequestScreenState();
}

class _AllRequestScreenState extends State<AllRequestScreen> {
  TextEditingController searchController = TextEditingController();
  String pName = "";
  bool checkCancelIcon = false;
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextField(
            controller: searchController,
            cursorColor: kprimarycolor,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: kprimarycolor,
              ),
              suffixIcon: checkCancelIcon
                  ? IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: kprimarycolor,
                ),
                onPressed: () {
                  setState(() {
                    checkCancelIcon = false;
                    searchController.clear();
                    pName = "";
                    FocusManager.instance.primaryFocus!.unfocus();
                  });
                },
              )
                  : null,
              hintText: "Search...",
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
                pName = value;
              });
              if (pName.isNotEmpty) {
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
              stream: getAllRequest(year),
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
                        "No Request data",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,int index){
                    if(pName.isEmpty)
                    {
                      return  PatientRequestContainer(
                        snapshot: snapshot.data,
                        index: index,
                      );
                    }
                    if(snapshot.data.docs[index]['First name'].toString().toLowerCase().startsWith(pName.toLowerCase())||snapshot.data.docs[index]['Last name'].toString().toLowerCase().startsWith(pName.toLowerCase()))
                    {
                      return PatientRequestContainer(
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
class PatientRequestContainer extends StatefulWidget {
  const PatientRequestContainer({Key? key,required this.index,required this.snapshot}) : super(key: key);
  final QuerySnapshot snapshot;
  final int index;

  @override
  State<PatientRequestContainer> createState() => _PatientRequestContainerState();
}

class _PatientRequestContainerState extends State<PatientRequestContainer> {
  String? accessType;
  List<DropdownMenuItem<String>> get access{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Allow", child: Text("Allow")),
      const DropdownMenuItem(value: "Not Allow", child: Text("Not Allow")),
    ];
    return menuItems;
  }
  bool checkSelect=false;

  @override
  Widget build(BuildContext context) {
final docId=widget.snapshot.docs[widget.index].id;
    return InkWell(
      onTap: (){

      },
      child: Card(
        elevation: 4.0,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          leading: CircleAvatar(
            radius: 30,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: CachedNetworkImage(
                    imageUrl: widget.snapshot.docs[widget.index]['Image'].toString().isNotEmpty?"${widget.snapshot.docs[widget.index]['Image']}":"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRKxFH_5CD60TMQ_gvjHkE5bAHCjWwPA1l3582kT5lqnbgFtPse",
                    height: 180,
                    width: 180,
                    key: UniqueKey(),
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) => const Image(image: AssetImage('assets/ImageError.png'),),
                    placeholder: (context, url) => loadingImage),
              ),
            ),
          ),
          title: Text("${widget.snapshot.docs[widget.index]['First name'].toString().toCapitalized()} ${widget.snapshot.docs[widget.index]['Last name'].toString().toCapitalized()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          subtitle: Text('${widget.snapshot.docs[widget.index]['Check']}',style: TextStyle(
              color: widget.snapshot.docs[widget.index]['Check'].toString()=='Not Allow'?Colors.red:Colors.green,
              fontStyle: FontStyle.italic,
            fontSize: 12,
          ),),
          trailing: ElevatedButton(
            onPressed: (){
              showDialog(context: context, builder: (context){
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    title: const Text('Change Access'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              value: accessType,
                              items: access,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                hintText: "Select Access type",
                                hintStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: const Icon(FontAwesomeIcons.lock,color: Colors.black,size: 16,),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black ,width: 2.3), borderRadius: BorderRadius.circular(25),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black, width: 2.3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black, width: 2.3),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onChanged: (value){
                                setState(() {
                                  accessType=value;
                                  checkSelect=true;
                                });
                              },

                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: !checkSelect?null:()async{
                                showDialog(
                                  context: context,
                                  builder: (context)=>spinkit,
                                  barrierDismissible: false,
                                );
                                changeAccess(widget.snapshot.docs[widget.index]['Request id'], accessType!,docId, context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                              ),
                              child: const Text("No",style: TextStyle(
                                fontSize: 14,
                              ),),
                            ),
                          ),
                        ],)
                      ],
                    ),
                  );
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimarycolor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            ),
            child: const Text("Give access"),
          ),
        ),
      ),
    );
  }
}