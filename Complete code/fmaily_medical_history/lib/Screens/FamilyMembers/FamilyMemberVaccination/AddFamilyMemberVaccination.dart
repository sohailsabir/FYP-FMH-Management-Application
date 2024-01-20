import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:intl/intl.dart';

import '../../../Components/Loading/loading.dart';



class AddFamilyVaccination extends StatefulWidget {
  const AddFamilyVaccination({Key? key,required this.vaccinationId,required this.familyMemberId}) : super(key: key);
  final String familyMemberId;
  final String vaccinationId;

  @override
  _AddFamilyVaccinationState createState() => _AddFamilyVaccinationState();
}

class _AddFamilyVaccinationState extends State<AddFamilyVaccination> {
  TextEditingController date=TextEditingController();
  TextEditingController time=TextEditingController();
  TextEditingController vName=TextEditingController();
  TextEditingController hName=TextEditingController();
  final _form=GlobalKey<FormState>();
  DateTime? pickDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kprimarycolor,
        title: const Text("Add Vaccination"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: kprimarycolor,width: 2)
              ),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    const Center(
                      child: CircleAvatar(
                        backgroundColor: kprimarycolor,
                        radius: 75,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: Icon(Icons.vaccines,size: 100,color: kprimarycolor,),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(

                      decoration: const InputDecoration(
                        labelText: "Vaccination name*",
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
                          return "Please enter vaccination name";
                        }
                        return null;
                      },
                      controller: vName,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: hName,
                      decoration: const InputDecoration(
                        labelText: "Hospital/Clinic name*",
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
                          return "Please enter hospital name";
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
                              controller: date,
                              readOnly: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: kprimarycolor,
                                ),
                                hintText: "Date",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please Enter Date";
                                }
                                return null;
                              },
                              onTap: ()async{
                                pickDate=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1965),lastDate: DateTime.now(),
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
                                if(pickDate!=null)
                                {
                                  setState(() {
                                    date.text=DateFormat('yyyy-MM-dd').format(pickDate!);
                                  });
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: time,
                              readOnly: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.timer,
                                  color: kprimarycolor,
                                ),
                                hintText: "Time",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please Enter Time";
                                }
                                return null;
                              },
                              onTap:() async{
                                TimeOfDay? pickTime=await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
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
                                if(pickTime!=null)
                                {
                                  setState(() {
                                    time.text=pickTime.format(context);
                                  });
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
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
                    saveFamilyVaccinationData(vName.text, hName.text, date.text, time.text,context,widget.vaccinationId,widget.familyMemberId).then((value){
                      vName.clear();
                      hName.clear();
                      date.clear();
                      time.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimarycolor,
                  padding: const EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Add",style: TextStyle(
                  fontSize: 18,
                ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimarycolor,
                  padding: const EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Cancel",style: TextStyle(
                  fontSize: 18,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
