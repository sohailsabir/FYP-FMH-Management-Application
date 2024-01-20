
import 'dart:io';

import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Components/Loading/loading.dart';

class ViewMemberProfile extends StatefulWidget {
  const ViewMemberProfile({Key? key,required this.snapshot}) : super(key: key);
  final QueryDocumentSnapshot snapshot;

  @override
  _ViewMemberProfileState createState() => _ViewMemberProfileState();
}

class _ViewMemberProfileState extends State<ViewMemberProfile> {
  late var snapshot;
  DateTime? pickDate;
  TextEditingController date=TextEditingController();
  TextEditingController fName=TextEditingController();
  TextEditingController lName=TextEditingController();
  TextEditingController age=TextEditingController();
  TextEditingController userName=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController relation=TextEditingController();
  List<DropdownMenuItem<String>> get bloodGroup{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "A+", child: Text("A+")),
      const DropdownMenuItem(value: "A-", child: Text("A-")),
      const DropdownMenuItem(value: "B+", child: Text("B+")),
      const DropdownMenuItem(value: "B-", child: Text("B-")),
      const DropdownMenuItem(value: "O+", child: Text("O+")),
      const DropdownMenuItem(value: "O-", child: Text("O-")),
      const DropdownMenuItem(value: "AB+", child: Text("AB+")),
      const DropdownMenuItem(value: "AB-", child: Text("AB-")),
    ];
    return menuItems;
  }
  final form=GlobalKey<FormState>();
  String? bloodType;
  String? imageUrl;
  bool check=true;
  bool imageCircle=false;
  File? imageFile;
  void showImageDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Center(child: Text("Choose Option",style: TextStyle(color: kprimarycolor),)),
        content: SizedBox(
          width: 350,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: (){
                  _getFromCamera();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt,size: 50,color: kprimarycolor,),
                    Text("Camera",style: TextStyle(fontSize: 18,color: kprimarycolor),),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,),
              InkWell(
                onTap: (){
                  _getFromGellery();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.photo,size: 50,color: kprimarycolor,),
                    Text("Gallery",style: TextStyle(fontSize: 18,color: kprimarycolor),),
                  ],
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.all(2),

      );
    });
  }
  void _getFromGellery()async{
    XFile? pickFile=await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImage(pickFile!.path);
    Navigator.pop(context);
  }
  void _getFromCamera()async{
    XFile? pickFile=await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImage(pickFile!.path);
    Navigator.pop(context);
  }
  void _cropImage(filePath)async{
    CroppedFile? croppedImage=await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: kprimarycolor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            activeControlsWidgetColor: Colors.red,

          ),
          IOSUiSettings(
            title: 'Edit Image',

          ),
        ]

    );
    if(croppedImage!=null)
    {
      setState(() {
        imageFile=File(croppedImage.path);
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    snapshot=widget.snapshot;
    fName.text=widget.snapshot['First name'];
    lName.text=widget.snapshot['Last name'];
    age.text=widget.snapshot['Age'].toString();
    userName.text=widget.snapshot['User name'];
    date.text=widget.snapshot['Date of Birth'];
    password.text=widget.snapshot['Password'];
    bloodType=widget.snapshot['Blood group'];
    relation.text=widget.snapshot['Relation'];
    super.initState();
    if(widget.snapshot['Image'].toString().isNotEmpty)
    {
      imageUrl=widget.snapshot['Image'];
    }
    else{
      imageUrl='https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRKxFH_5CD60TMQ_gvjHkE5bAHCjWwPA1l3582kT5lqnbgFtPse';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: !check?const Text("Edit Profile"):const Text("Profile"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        actions: [
          !check?Container():IconButton(onPressed: (){
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
                                check=false;
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
          }, icon: const Icon(FontAwesomeIcons.userPen))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                              backgroundImage: imageFile==null?null:FileImage(imageFile!),
                              child: imageFile==null?ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: "$imageUrl",
                                  height: 133,
                                  width: 133,
                                  fit: BoxFit.cover,
                                  key: UniqueKey(),
                                  placeholder: (context, url) => loadingImage,
                                  errorWidget: (context, url, error) => const Image(image: AssetImage('assets/profile.jpg'),fit: BoxFit.cover),
                                ),
                              ):null,
                            ),
                          )
                      ),
                      !check?Container():const SizedBox(
                        height: 20,),
                      !check?Container():Text("${snapshot['First name'].toString().toCapitalized()} ${snapshot['Last name'].toString().toCapitalized()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      !check?Container():Text(widget.snapshot['Email'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),)
                    ],
                  ),
                ),
                check?Container():Positioned(
                  top: 110,
                  left: 210,
                  child: RawMaterialButton(
                    onPressed: () {
                      showImageDialog();
                    },
                    fillColor: Colors.white,
                    elevation: 10,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.edit,
                      color: kprimarycolor,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: fName,
                      readOnly: check,
                      cursorColor: kprimarycolor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person,color: Colors.grey),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "First Name",
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter first name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,),
                    TextFormField(
                      autofocus: false,
                      controller: lName,
                      readOnly: check,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person,color: Colors.grey,),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Last Name",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter last name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,),
                    TextFormField(
                      autofocus: false,
                      controller: date,
                      readOnly: true,
                      decoration:  InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                        prefixIcon: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.grey,
                        ),
                        hintText: "Date of Birth",
                        hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please Enter Date of birth";
                        }
                        return null;
                      },
                      onTap: check?null:()async{
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
                    const SizedBox(
                      height: 30,),
                    !check?Container():TextFormField(
                      autofocus: false,
                      controller: age,
                      readOnly: check,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.man,color: Colors.grey,),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Age",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                      ),
                    ),
                    !check?Container():const SizedBox(
                      height: 30,),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          value: bloodType,
                          items: bloodGroup,
                          decoration: InputDecoration(
                            hintText: "Select Blood Group (Optional)",
                            hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                            prefixIcon: const Icon(Icons.bloodtype,color: Colors.grey,),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 2.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.black12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 2.3, color: Colors.black12),
                            ),
                          ),

                          onChanged: check?null:(value){
                            setState(() {
                              bloodType=value as String?;
                            });
                          },

                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,),
                    TextFormField(
                      autofocus: false,
                      controller: relation,
                      readOnly: check,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.man,color: Colors.grey,),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Relation",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter relation";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,),
                    !check?Container():TextFormField(
                      controller: userName,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person,color: Colors.grey,),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Username",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                      ),
                      validator: (value){
                        if (value!.length < 4 || value.isEmpty) {
                          return "Username is too short.";
                        } else if (value.length > 12) {
                          return "Username is too long.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    !check?Container():const SizedBox(
                      height: 30,),
                    !check?Container():TextFormField(
                      controller: password,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock,color: Colors.grey,),
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black12, width: 2.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 2.3, color: Colors.black12),
                        ),
                      ),
                    ),
                    !check?Container():const SizedBox(
                      height: 30,),
                    check?Container():ElevatedButton(
                      onPressed: ()async{
                       FocusManager.instance.primaryFocus!.unfocus();
                       if(!form.currentState!.validate())
                         {
                           return;
                         }
                       else{
                         DateDuration duration;
                         duration=AgeCalculator.age(DateTime.parse(date.text));
                         showDialog(
                           context: context,
                           builder: (context)=>spinkit,
                           barrierDismissible: false,

                         );
                         if(imageFile!=null){
                           try{
                             final result = await InternetAddress.lookup('google.com');
                             if (result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                               editFamilyMemberProfileWithImage(fName.text, lName.text, date.text, bloodType!, relation.text, duration.years.toString(), context, widget.snapshot.id,widget.snapshot['User id'], imageFile!,widget.snapshot['Image']).then((value){
                                 reload();
                               });
                               setState(() {
                                 check=true;
                               });
                             }
                           }on SocketException catch (_){
                             Navigator.pop(context);
                             showDialog(context: context, builder: (context){
                               return customMessage(message: 'Please check your internet connection.', icon: Icons.error, title: 'Alert');
                             });
                           }
                         }
                         else{
                           editFamilyMemberProfile(fName.text, lName.text, date.text, bloodType!, relation.text, duration.years.toString(), context, widget.snapshot.id, widget.snapshot['User id']).then((value){
                             reload();
                           });
                           setState(() {
                             check=true;
                           });
                         }
                       }

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kprimarycolor,
                          padding: const EdgeInsets.all(13)
                      ),
                      child: const Text("Update",style: TextStyle(
                        fontSize: 18,
                      ),),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
   reload()async{
        final uid=await getUserId();
        await FirebaseFirestore.instance.collection('User').doc(uid).collection("Family member").doc(snapshot.id).get().then((data){
          setState(() {
            snapshot=data;
            fName.text=snapshot['First name'];
            lName.text=snapshot['Last name'];
            age.text=snapshot['Age'].toString();
            userName.text=snapshot['User name'];
            date.text=snapshot['Date of Birth'];
            password.text=snapshot['Password'];
            bloodType=snapshot['Blood group'];
            relation.text=snapshot['Relation'];
          });
        });
  }
}
