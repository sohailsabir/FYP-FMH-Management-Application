

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/patient_view_controller.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/patient_labreport.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/patient_medication.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/patient_prescription.dart';
import 'package:fmaily_medical_history/Screens/OtherPatientData/patient_vaccination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Components/Loading/loading.dart';
import '../../Components/Shimmer/medication_shimmer.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key,required this.patientId}) : super(key: key);
  final String patientId;

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool checkReadibility=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: kprimarycolor,
        elevation: 0.0,
        title: const Text('Patient Data'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: patientData(widget.patientId),
        builder: (context, AsyncSnapshot snapshot) {
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
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20,bottom: 30,left: 10,right: 10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: kprimarycolor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight:  Radius.circular(40),
                        )
                    ),
                    child: Column(
                      children:  [
                        Center(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 69,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data['Image'].toString().isNotEmpty?"${snapshot.data['Image']}":"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRKxFH_5CD60TMQ_gvjHkE5bAHCjWwPA1l3582kT5lqnbgFtPse",
                                    height: 133,
                                    width: 133,
                                    fit: BoxFit.cover,
                                    key: UniqueKey(),
                                    placeholder: (context, url) => loadingImage,
                                    errorWidget: (context, url, error) => const Image(image: AssetImage('assets/profile.jpg'),fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            )
                        ),
                      const SizedBox(height: 20,),
                        Text("${snapshot.data['First name'].toString().toCapitalized()} ${snapshot.data['Last name'].toString().toCapitalized()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                        Text("${snapshot.data['Email'].toString()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 50),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ButtonView(
                          color: kprimarycolor,
                          icon: FontAwesomeIcons.capsules,
                          label: 'Medication',
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientMedicationScreen(patientId: widget.patientId,)));
                          },
                        ),
                        const SizedBox(width: 10,),
                        ButtonView(
                          color: kprimarycolor,
                          icon: FontAwesomeIcons.filePrescription,
                          label: 'Prescription',
                          onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientPrescription(patientId: widget.patientId)));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ButtonView(
                            color: kprimarycolor,
                            icon: FontAwesomeIcons.file,
                            label: 'Lab Report',
                            onpressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientLabReport(patientId: widget.patientId)));
                            },
                        ),
                        const SizedBox(width: 10,),
                         ButtonView(
                          color: kprimarycolor,
                          icon: Icons.vaccines,
                          label: 'Vaccination',
                           onpressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientVaccinationScreen(patientId: widget.patientId)));
                           },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
class ButtonView extends StatelessWidget {
  const ButtonView({Key? key,required this.color,required this.icon,required this.label, this.onpressed}) : super(key: key);
  final String label;
  final IconData icon;
  final VoidCallback? onpressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
          onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.only(top: 40,bottom: 40),
        ),
          child: Column(
            children: [
              Icon(icon,color: Colors.white,size: 40,),
              Text(label,style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
            ],
          ),
      ),
    );
  }
}

