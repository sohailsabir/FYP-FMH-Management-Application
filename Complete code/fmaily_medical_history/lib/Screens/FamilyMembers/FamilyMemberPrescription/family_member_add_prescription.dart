
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Components/Loading/loading.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/family_member_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFamilyPrescription extends StatefulWidget {
  const AddFamilyPrescription({Key? key,required this.prescriptionId,required this.familyMemberId}) : super(key: key);
  final String familyMemberId;
  final String prescriptionId;

  @override
  _AddFamilyPrescriptionState createState() => _AddFamilyPrescriptionState();
}

class _AddFamilyPrescriptionState extends State<AddFamilyPrescription> {
  TextEditingController dName=TextEditingController();
  TextEditingController hName=TextEditingController();
  TextEditingController disease=TextEditingController();

  final _form=GlobalKey<FormState>();
  var pickDate;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Prescriptions"),
        backgroundColor: kprimarycolor,
        centerTitle: true,
      ),
      backgroundColor: backColor,
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Doctor Name*",
                        labelStyle: TextStyle(
                            color: kprimarycolor
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kprimarycolor,width: 2),
                        ),
                      ),
                      controller: dName,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return "Please enter doctor name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: hName,
                      decoration: const InputDecoration(
                        labelText: "Hospital/Clinic Name*",
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
                      height: 20,
                    ),
                    TextFormField(
                      controller: disease,
                      decoration: const InputDecoration(
                        labelText: "For Disease*",
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Take Photo",style: TextStyle(
                        fontSize: 20,
                        fontFamily: "PatuaOne",
                        color: kprimarycolor
                    ),),
                    const SizedBox(
                      height: 20,
                    ),
                    imageFile==null?Container(
                      width: 400,
                      height: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]
                      ),
                      child: InkWell(
                        onTap: (){
                          showImageDialog();
                        },
                        child: const Icon(Icons.add_a_photo,color: kprimarycolor,size: 100,),
                      ),
                    ):
                    Container(
                      width: 400,
                      height: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]
                      ),
                      child: InkWell(
                        onTap: (){
                          showImageDialog();
                        },
                        child: Image.file(imageFile!,fit: BoxFit.fill,),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                child: ElevatedButton(
                  onPressed: ()async{
                    FocusManager.instance.primaryFocus!.unfocus();
                    if(!_form.currentState!.validate())
                    {
                      return;
                    }
                    else{
                      if(imageFile==null)
                      {
                        showDialog(context: context, builder: (context){
                          return customMessage(message: "Please take one photo.", icon: Icons.error, title: "Alert");
                        });
                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (context)=>spinkit,
                          barrierDismissible: false,

                        );
                        try{
                          final result = await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                            uploadFamilyPrescriptionImage(imageFile!, dName.text, hName.text, disease.text,context,widget.familyMemberId,widget.prescriptionId);
                          }
                        }on SocketException catch (_){
                          await saveFamilyPrescriprtionDataLocally(imageFile!.path, dName.text, hName.text, disease.text, widget.familyMemberId, widget.prescriptionId);
                          setState(() {
                            disease.clear();
                            dName.clear();
                            hName.clear();
                            imageFile=null;
                          });
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context){
                            return customMessage(message: 'Data store locally. Data automatically uploaded to server when internet connection available', icon: Icons.error, title: 'No internet connection');
                          });
                        }
                      }

                    }

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kprimarycolor,
                      padding: const EdgeInsets.all(13)
                  ),
                  child: const Text("Save & Exit",style: TextStyle(
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
                      padding: const EdgeInsets.all(13)
                  ),
                  child: const Text("Cancel",style: TextStyle(
                    fontSize: 18,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> saveFamilyPrescriprtionDataLocally(String imagePath,String dName,String hName,String disease,String fID,String pID) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> localData = prefs.getStringList('localFamilyPrescriptionData') ?? [];

  localData.add('$dName,$hName,$disease,$fID,$pID,$imagePath');
  await prefs.setStringList('localFamilyPrescriptionData', localData);
}
Future<void> uploadLocalFamilyPrescriptionData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> localData = prefs.getStringList('localFamilyPrescriptionData') ?? [];

  for (final data in localData) {
    final List<String> values = data.split(',');
    final String dName = values[0];
    final String hName = values[1];
    final String disease = values[2];
    final String fID = values[3];
    final String pID = values[4];
    final String imagePath = values[5];
    final File imageFile = File(imagePath);
    uploadLocallyFamilyPrescriptionImage(imageFile, dName, hName, disease, fID, pID);
  }

  // Clear local data after successful upload
  await prefs.remove('localFamilyPrescriptionData');
}