import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/Loading/loading.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Controller/vaccination_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../Constants/constant.dart';

class EditVaccination extends StatefulWidget {
  const EditVaccination({Key? key,required this.hName,required this.vName,required this.vDate,required this.vtime,required this.id}) : super(key: key);
  final String vName;
  final String hName;
  final String vDate;
  final String vtime;
  final String id;

  @override
  _EditVaccinationState createState() => _EditVaccinationState();
}

class _EditVaccinationState extends State<EditVaccination> {
  TextEditingController date=TextEditingController();
  TextEditingController time=TextEditingController();
  TextEditingController vName=TextEditingController();
  TextEditingController hName=TextEditingController();
  DateTime? pickDate;
  bool textReadOnly=true;
  final _form=GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date.text=widget.vDate;
    time.text=widget.vtime;
    vName.text=widget.vName;
    hName.text=widget.hName;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kprimarycolor,
        title: const Text("Edit Detail"),
        actions: [
          IconButton(
              tooltip: "Update data",
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    insetPadding: const EdgeInsets.all(10),
                    contentPadding: const EdgeInsets.only(left: 40,right: 40,bottom: 30,top: 30),
                    content:  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Are you sure you want to Edit data ?"),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    textReadOnly=false;
                                  });
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
              }, icon: Icon(FontAwesomeIcons.penToSquare))
        ],
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
                      autofocus: true,
                      readOnly: textReadOnly,
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
                      readOnly:  textReadOnly,
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
                                if(textReadOnly==false)
                                  {
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
                                if(textReadOnly==false){
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
                onPressed: textReadOnly?null:(){
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
                    editVaccination(vName.text, hName.text, date.text, time.text, widget.id).then((value){
                      Navigator.pop(context);
                      setState(() {
                        textReadOnly=true;
                      });
                      showDialog(context: context, builder: (context){
                        return customMessage(message: "Data Update",title: "Successfully",icon: Icons.check_circle,);
                      });
                    });

                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kprimarycolor,
                    padding: const EdgeInsets.all(13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Update",style: TextStyle(
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
