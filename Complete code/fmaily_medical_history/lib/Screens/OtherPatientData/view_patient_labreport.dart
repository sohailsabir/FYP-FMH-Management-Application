
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:photo_view/photo_view.dart';


class ShowPatientLabReport extends StatefulWidget {
  const ShowPatientLabReport({Key? key,required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  _ShowPatientLabReportState createState() => _ShowPatientLabReportState();
}

class _ShowPatientLabReportState extends State<ShowPatientLabReport> {
  bool checkAppbar=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkAppbar?AppBar(
        backgroundColor: kprimarycolor,
        title: const Text("LabReport"),
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
