import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/Loading/loading.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:intl/intl.dart';

import '../../../Controller/family_member_controller.dart';

class AddFamilyMedicineScreen extends StatefulWidget {
  const AddFamilyMedicineScreen({Key? key,required this.medicationId,required this.familyMemberId}) : super(key: key);
  final String familyMemberId;
  final String medicationId;

  @override
  _AddFamilyMedicineScreenState createState() => _AddFamilyMedicineScreenState();
}

class _AddFamilyMedicineScreenState extends State<AddFamilyMedicineScreen> {


  String takeFood="";
  DateTime? pickDate1;
  DateTime? pickDate2;

  TextEditingController dName=TextEditingController();
  TextEditingController dSpecialization=TextEditingController();
  TextEditingController dNumber=TextEditingController();
  TextEditingController dHospital=TextEditingController();
  TextEditingController dHAddress=TextEditingController();
  TextEditingController disease=TextEditingController();
  TextEditingController medicine=TextEditingController();
  TextEditingController startDate=TextEditingController();
  TextEditingController endDate=TextEditingController();


  final _form=GlobalKey<FormState>();
  bool check=false;
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kprimarycolor,
        title: const Text("Add Medicine"),
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
                  // border: Border.all(color: kprimarycolor,width: 2)
                ),
                child: Column(
                  children: [
                    const Center(
                      child: Text("Doctor Details",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kprimarycolor,
                      ),),
                    ),
                    TextFormField(
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
                    TextFormField(
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
                    TextFormField(
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
                    TextFormField(
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
                    TextFormField(
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
                  children: [
                    const Center(
                      child: Text("Disease",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kprimarycolor,
                      ),),
                    ),
                    TextFormField(
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
                            child: RadioListTile(
                                title: const Text("Before Food",style:
                                TextStyle(color: kprimarycolor,fontWeight: FontWeight.bold),),
                                value: "Before food",
                                groupValue: takeFood,
                                activeColor: kprimarycolor,
                                onChanged: (val){
                                  setState(() {
                                    takeFood=val!;
                                  });
                                }
                            ),
                          ),
                          Expanded(
                              child: RadioListTile(
                                  title: const Text("After Food",
                                    style: TextStyle(color: kprimarycolor,fontWeight: FontWeight.bold),),
                                  value: "After food",
                                  groupValue: takeFood,
                                  activeColor: kprimarycolor,
                                  onChanged: (val){
                                    setState(() {
                                      takeFood=val!;
                                    });
                                  })
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                              onTap: ()async{
                                pickDate1=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now(),
                                  builder: ((context, child){
                                    return Theme(data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: kprimarycolor,
                                        onPrimary: Colors.white,
                                        onSurface: kprimarycolor,
                                      ),
                                    ), child: child!);
                                  }),
                                );
                                if(pickDate1!=null)
                                {
                                  setState(() {
                                    startDate.text=DateFormat('yyyy-MM-dd').format(pickDate1!);
                                    check=true;
                                  });
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
                              onTap: check?()async{
                                pickDate2=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: pickDate1!, lastDate: DateTime(3000),
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
                                  });
                                }
                              }:null,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kprimarycolor,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Cancel",style: TextStyle(
                            fontSize: 20
                        ),),

                      ),
                    ),
                    const SizedBox(width: 50,),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          FocusManager.instance.primaryFocus!.unfocus();

                          if(!_form.currentState!.validate())
                          {
                            return;
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (context)=>spinkit,
                              barrierDismissible: false,

                            );
                            saveFamilyMedicineData(dName.text, dSpecialization.text, dNumber.text, dHospital.text, dHAddress.text, disease.text, medicine.text, takeFood, startDate.text, endDate.text,context,widget.medicationId,widget.familyMemberId).then((value){
                              dName.clear();
                              dSpecialization.clear();
                              dNumber.clear();
                              dHospital.clear();
                              dHAddress.clear();
                              disease.clear();
                              medicine.clear();
                              setState(() {
                                takeFood="";
                              });

                              startDate.clear();
                              endDate.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kprimarycolor,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Save",
                          style: TextStyle(
                              fontSize: 20
                          ),),

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
