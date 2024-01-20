
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ShowPatientPrescription extends StatefulWidget {
  const ShowPatientPrescription({Key? key,required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  _ShowPatientPrescriptionState createState() => _ShowPatientPrescriptionState();
}

class _ShowPatientPrescriptionState extends State<ShowPatientPrescription> {
  bool checkAppbar=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkAppbar?AppBar(
        backgroundColor: kprimarycolor,
        title: const Text("Prescription"),
      ):null,
      body: GestureDetector(
        onTap: (){
          setState(() {
            checkAppbar=!checkAppbar;
          });

        },
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          enableRotation: false,
          imageProvider: CachedNetworkImageProvider(widget.imageUrl),
          maxScale: 3.0,
          minScale: 0.3,

        ),
      ),
    );
  }
}
