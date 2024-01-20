import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Controller/patient_view_controller.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/add_patient.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/dashboard.dart';
import '../../Components/Loading/loading.dart';
import '../../Components/Shimmer/medication_shimmer.dart';
import '../../Constants/constant.dart';

class AllPatientScreen extends StatefulWidget {
  const AllPatientScreen({Key? key}) : super(key: key);

  @override
  _AllPatientScreenState createState() => _AllPatientScreenState();
}

class _AllPatientScreenState extends State<AllPatientScreen> {
  TextEditingController searchController = TextEditingController();
  String username='xyz';
  Map<String,dynamic>?userMap;
  String pName = "";
  bool checkCancelIcon = false;
  DateTime selectedYear = DateTime.now();
  int year=DateTime.now().year;

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
              stream: getPatient(year),
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
                        "No Patient data",
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
                      return  PatientContainer(
                        snapshot: snapshot.data,
                        index: index,
                      );
                    }
                    if(snapshot.data.docs[index]['First name'].toString().toLowerCase().startsWith(pName.toLowerCase())||snapshot.data.docs[index]['Last name'].toString().toLowerCase().startsWith(pName.toLowerCase()))
                    {
                      return PatientContainer(
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
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPatient()));
          },
          child: Container(
            width: 180,
            margin: const EdgeInsets.only(top: 10,bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: kprimarycolor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.account_box,color: Colors.white,size: 30,),
                Text("Add Patient",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class PatientContainer extends StatefulWidget {
  const PatientContainer({Key? key,required this.index,required this.snapshot}) : super(key: key);
  final QuerySnapshot snapshot;
  final int index;

  @override
  State<PatientContainer> createState() => _PatientContainerState();
}

class _PatientContainerState extends State<PatientContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.snapshot.docs[widget.index]['Check']=='Not Allow')
          {
            showDialog(context: context, builder: (context){
              return customMessage(message: 'You are not allow to see data ', icon: Icons.error, title: "Not Access");
            });
          }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen(patientId: widget.snapshot.docs[widget.index]['Patient id'])));
        }
      },
      child: Card(
        elevation: 4.0,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
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
          title: Text("${widget.snapshot.docs[widget.index]['First name'].toString().toCapitalized()} ${widget.snapshot.docs[widget.index]['Last name'].toString().toCapitalized()}",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          subtitle: Text('${widget.snapshot.docs[widget.index]['Check']}',
            style:TextStyle(
              color: widget.snapshot.docs[widget.index]['Check'].toString()=='Not Allow'?Colors.red:Colors.green,
              fontStyle: FontStyle.italic
          ),),
          trailing: IconButton(
            onPressed: ()async{
              showDialog(
                context: context,
                builder: (context)=>spinkit,
                barrierDismissible: false,
              );
              await removePatient(widget.snapshot.docs[widget.index]['Patient id'], widget.snapshot.docs[widget.index].id, context).then((value){
                Navigator.pop(context);
              });
            },
            icon: Icon(Icons.remove_circle_outlined,color: Colors.red,),
          ),
        ),
      ),
    );
  }
}

