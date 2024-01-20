import 'dart:io';
import 'package:age_calculator/age_calculator.dart';

import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Components/showMessage/customMessage.dart';
import '../../Controller/check_username.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({Key? key}) : super(key: key);

  @override
  _AddFamilyMemberState createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  File? imageFile;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController relation = TextEditingController();
  String? genderType;
  String? bloodType;
  String blood='';
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  bool emailValidation(String e){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(e);
    return emailValid;
  }

  void showImageDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              "Choose Option",
              style: TextStyle(color: kprimarycolor),
            )),
            content: SizedBox(
              width: 350,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      _getFromCamera();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: kprimarycolor,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(fontSize: 18, color: kprimarycolor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _getFromGallery();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.photo,
                          size: 50,
                          color: kprimarycolor,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(fontSize: 18, color: kprimarycolor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(2),
          );
        });
  }

  void _getFromGallery() async {
    XFile? pickFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    _cropImage(pickFile!.path);
    Navigator.pop(context);
  }

  void _getFromCamera() async {
    XFile? pickFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    _cropImage(pickFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
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
        ]);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  List<DropdownMenuItem<String>> get bloodGroup {
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


  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: const Text("Add Family Member"),
        centerTitle: true,
        backgroundColor: kprimarycolor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: const BoxDecoration(
                    color: kprimarycolor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionalTranslation(
                    translation: const Offset(0.0, 0.1),
                    child: InkWell(
                      onTap: (){
                        showImageDialog();
                      },
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: kprimarycolor,
                        child: imageFile == null
                            ? const CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.add_a_photo_sharp,color: kprimarycolor,size: 40,),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                backgroundImage: FileImage(imageFile!),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: form,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "First Name*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: fName,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please Enter First Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Last Name*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: lName,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please Enter Last Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Relation e.g son",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: relation,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          validator: (value) => value == null ? 'field required' : null,
                          value: bloodType,
                          items: bloodGroup,
                          decoration: const InputDecoration(
                            hintText: "Select Blood Group",
                            hintStyle: TextStyle(color: kprimarycolor),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kprimarycolor,width: 2),
                            ),
                          ),

                          onChanged: (value){
                            setState(() {
                              bloodType=value;
                            });
                          },


                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: dateOfBirth,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: "Date of Birth",
                        hintStyle: TextStyle(color: kprimarycolor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please Enter Date of Birth";
                        }
                        return null;
                      },
                      onTap: ()async{
                        DateTime? pickDate=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now(),
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
                            dateOfBirth.text=DateFormat('yyyy-MM-dd').format(pickDate);
                            DateDuration duration;
                            duration=AgeCalculator.age(pickDate);
                            age.text=duration.years.toString();
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Username*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: username,
                      validator: (value){
                        if (value!.length < 8 || value.isEmpty) {
                          return "Username must be at least 8 characters.";
                        } else if (value.length > 25) {
                          return "Username is too long.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: email,
                      validator: (value){
                        if(!emailValidation(value!)||value.isEmpty){
                          return "Please enter valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Password*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: password,
                      validator: (value){
                        if(value!.isEmpty||value.length<7){
                          return "Please enter at least 7 character";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
              child: ElevatedButton(
                onPressed: ()async{
                  FocusManager.instance.primaryFocus!.unfocus();
                  if(!form.currentState!.validate()){
                    return;
                  }
                  else {
                    final valid = await usernameCheck(username.text.trim(),context);
                    if (!valid) {
                      Navigator.pop(context);
                      showDialog(context: context, builder: (context){
                        return customMessage(message: "Username already exist.",icon: Icons.error,title: "Alert",);
                      });
                    }
                    else{
                      DateDuration duration;
                      duration=AgeCalculator.age(DateTime.parse(dateOfBirth.text));
                      if(imageFile!=null)
                      {
                        try{
                          final result = await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                            registerFamilyMemberWithImage(email.text.trim(), password.text.trim(), fName.text, lName.text, dateOfBirth.text, bloodType!, duration.years, context, username.text.trim(), relation.text, imageFile!);
                          }
                        }on SocketException catch (_){
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context){
                            return customMessage(message: 'Please check your internet connection.', icon: Icons.error, title: 'Alert');
                          });
                        }
                      }
                      else{
                        registerFamilyMember(email.text.trim(), password.text.trim(), fName.text, lName.text, dateOfBirth.text, bloodType!, duration.years, context,"",username.text.trim(),relation.text);
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kprimarycolor,
                    padding: const EdgeInsets.all(13)
                ),
                child: const Text(
                  "Save",style: TextStyle(
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
