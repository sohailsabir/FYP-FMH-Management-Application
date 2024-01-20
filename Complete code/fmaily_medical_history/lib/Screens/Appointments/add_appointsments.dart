import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Controller/appointment_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../Components/Loading/loading.dart';
import '../../Constants/constant.dart';
import '../../Notification/notification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddAppointments extends StatefulWidget {
  const AddAppointments({Key? key}) : super(key: key);

  @override
  _AddAppointmentsState createState() => _AddAppointmentsState();
}

class _AddAppointmentsState extends State<AddAppointments> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  TextEditingController date=TextEditingController();
  TextEditingController time=TextEditingController();
  TextEditingController dName=TextEditingController();
  TextEditingController hName=TextEditingController();
  TextEditingController purpose=TextEditingController();
  final Notifications _notifications = Notifications();
  DateTime dateTime=DateTime.now();
  DateTime? pickDate;
  final _form=GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotifies();
  }
  Future initNotifies() async => flutterLocalNotificationsPlugin = await _notifications.initNotifies(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kprimarycolor,
        title: const Text("Add Appointment"),
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
                        radius: 70,
                        backgroundColor: kprimarycolor,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: Icon(FontAwesomeIcons.userDoctor,size: 70,color: kprimarycolor,),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
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
                        if(value!.isEmpty)
                        {
                          return "Please enter doctor name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
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
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: purpose,
                      decoration: const InputDecoration(
                        labelText: "Purpose of Visit*",
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
                          return "Please enter purpose of visit";
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
                                pickDate=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(),lastDate: DateTime(5001),
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
                                    print(date.text);
                                    DateTime newDate = DateTime(
                                        pickDate != null ? pickDate!.year : dateTime.year,
                                        pickDate != null ? pickDate!.month : dateTime.month,
                                        pickDate!= null ? pickDate!.day : dateTime.day,
                                        dateTime.hour,
                                        dateTime.minute

                                       );
                                    setState(() => dateTime = newDate);
                                    print(dateTime);
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
                                    print(time.text);
                                    DateTime newDate = DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day,
                                        pickTime != null ? pickTime.hour : dateTime.hour,
                                        pickTime != null ? pickTime.minute : dateTime.minute);
                                    setState(() => dateTime = newDate);
                                    print(dateTime);
                                    print(newDate.hour);
                                    print(newDate.minute);
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
                onPressed: ()async{
                  FocusManager.instance.primaryFocus!.unfocus();
                  if(!_form.currentState!.validate()){
                    return;
                  }
                  else{
                    if(dateTime.microsecondsSinceEpoch <=DateTime.now().microsecondsSinceEpoch){
                      showDialog(context: context, builder: (context){
                        return customMessage(message: 'Current time is ${TimeOfDay.now().format(context)}. Please select time that is latter than current time.', icon: Icons.error, title: 'Selection Time Error.');
                      });
                    }
                    else{
                      showDialog(
                        context: context,
                        builder: (context)=>spinkit,
                        barrierDismissible: false,
                      );
                      int notifyId=Random().nextInt(10000000);
                      saveAppointmentData(dName.text, hName.text, date.text, time.text, purpose.text,context,dateTime.microsecondsSinceEpoch,notifyId).then((value) {
                        dName.clear();
                        hName.clear();
                        date.clear();
                        time.clear();
                        purpose.clear();
                      });
                      tz.initializeTimeZones();
                      await _notifications.showNotification('Today Appointment With DR. ${dName.text.toString().toCapitalized()}','${purpose.text.toCapitalized()}',timeNotification,notifyId, flutterLocalNotificationsPlugin);

                    }

                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kprimarycolor,
                    padding: const EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Add & Exit",style: TextStyle(
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
  int get timeNotification => dateTime.millisecondsSinceEpoch - tz.TZDateTime.now(tz.local).millisecondsSinceEpoch;
}
