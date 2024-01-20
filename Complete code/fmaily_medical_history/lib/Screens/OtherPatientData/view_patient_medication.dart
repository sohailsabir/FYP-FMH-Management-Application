import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:intl/intl.dart';

class ViewPatientMedication extends StatefulWidget {
  const ViewPatientMedication({Key? key,required this.medicineName,required this.endDate,required this.startDate, required this.contactNo,required this.disease, required this.doctorName,required this.hAddress,required this.hospitalName,required this.schedule,required this.specialization}) : super(key: key);
  final String specialization;
  final String contactNo;
  final String hospitalName;
  final String hAddress;
  final String disease;
  final String medicineName;
  final String schedule;
  final String startDate;
  final String endDate;
  final String doctorName;
  @override
  _ViewPatientMedicationState createState() => _ViewPatientMedicationState();
}

class _ViewPatientMedicationState extends State<ViewPatientMedication> {
  TextEditingController dName=TextEditingController();
  TextEditingController dSpecialization=TextEditingController();
  TextEditingController dNumber=TextEditingController();
  TextEditingController dHospital=TextEditingController();
  TextEditingController dHAddress=TextEditingController();
  TextEditingController disease=TextEditingController();
  TextEditingController medicine=TextEditingController();
  TextEditingController startDate=TextEditingController();
  TextEditingController endDate=TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String takeFood="";
  DateTime? pickDate1;
  DateTime? pickDate2;
  bool textReadOnly=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    takeFood=widget.schedule;
    dName.text=widget.doctorName;
    dSpecialization.text=widget.specialization;
    dNumber.text=widget.contactNo;
    dHospital.text=widget.hospitalName;
    dHAddress.text=widget.hAddress;
    disease.text=widget.disease;
    medicine.text=widget.medicineName;
    startDate.text=widget.startDate;
    endDate.text=widget.endDate;
  }
  final _form=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kprimarycolor,
        title: const Text("Medication Detail"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Center(
                      child:  Text("Doctor Details",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kprimarycolor,
                      ),),
                    ),
                    TextFormField(
                      autofocus: true,
                      readOnly: textReadOnly,
                      controller: dName,
                      decoration: const InputDecoration(
                        labelText: "Doctor name*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter doctor name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      readOnly: textReadOnly,
                      controller: dSpecialization,
                      decoration: const InputDecoration(
                        labelText: "Specialization",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      readOnly: textReadOnly,
                      keyboardType: TextInputType.number,
                      controller: dNumber,
                      decoration: const InputDecoration(
                        labelText: "Contact no",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      readOnly: textReadOnly,
                      controller: dHospital,
                      decoration: const InputDecoration(
                        labelText: "Clinic/Hospital name",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      readOnly: textReadOnly,
                      controller: dHAddress,
                      decoration: const InputDecoration(
                        labelText: "Clinic/Hospital address",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: kprimarycolor,width: 2)
                ),
                child: Column(
                  children:  [
                    const Center(
                      child: Text("Disease",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kprimarycolor,
                      ),),
                    ),
                    TextFormField(
                      readOnly: textReadOnly,
                      controller: disease,
                      decoration: const InputDecoration(
                        labelText: "Disease*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return "Please enter disease";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: kprimarycolor,width: 2)
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text("Medicine Details",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kprimarycolor,
                      ),),
                    ),
                    TextFormField(
                      controller: medicine,
                      readOnly: textReadOnly,

                      decoration: const InputDecoration(
                        labelText: "Medicine name*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter medicine name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey,width: 1)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: startDate,
                              readOnly: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: kprimarycolor,
                                ),
                                hintText: "Start Date",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please Enter Start Date";
                                }
                                return null;
                              },
                              onTap: ()async{
                                if(!textReadOnly)
                                {
                                  pickDate1=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now(),
                                      builder: ((context, child){
                                        return Theme(data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: kprimarycolor,
                                            onPrimary: Colors.white,
                                            onSurface: kprimarycolor,
                                          ),
                                        ), child: child!);
                                      })
                                  );
                                  if(pickDate1!=null)
                                  {
                                    setState(() {
                                      startDate.text=DateFormat('yyyy-MM-dd').format(pickDate1!);
                                    });
                                  }

                                }

                              },
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: endDate,
                              readOnly: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: kprimarycolor,
                                ),
                                hintText: "End Date",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please Enter End Date";
                                }
                                return null;
                              },
                              onTap: ()async{
                                if(!textReadOnly)
                                {
                                  pickDate2=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: dateFormat.parse(widget.startDate), lastDate: DateTime.now(),
                                      builder: ((context, child){
                                        return Theme(data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: kprimarycolor,
                                            onPrimary: Colors.white,
                                            onSurface: kprimarycolor,
                                          ),
                                        ), child: child!);
                                      })
                                  );
                                  if(pickDate2!=null)
                                  {
                                    setState(() {
                                      endDate.text=DateFormat('yyyy-MM-dd').format(pickDate2!);
                                      if(pickDate2!.isBefore(pickDate1!))
                                      {
                                        showDialog(context: context, builder: (context){
                                          return const AlertDialog(
                                            title: Text("Error"),
                                          );
                                        });
                                        endDate.text='';
                                      }
                                    });
                                  }
                                }

                              },
                            ),
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
    ) ;
  }
}
