
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

class ShowPrescription extends StatefulWidget {
  const ShowPrescription({Key? key,required this.imageUrl}) : super(key: key);
final String imageUrl;
  @override
  _ShowPrescriptionState createState() => _ShowPrescriptionState();
}

class _ShowPrescriptionState extends State<ShowPrescription> {
  bool checkAppbar=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkAppbar?AppBar(
        backgroundColor: kprimarycolor,
        title: const Text("Prescription"),
        actions: [
          IconButton(onPressed: ()async{
            showDialog(
              barrierDismissible: false,
                context: context, builder: (context){
              return AlertDialog(
                content: Row(
                  children: const [
                    CircularProgressIndicator(color: kprimarycolor),
                    SizedBox(width: 15,),
                    Text('Please wait...'),
                  ],
                ),

              );
            });
            final uri=Uri.parse(widget.imageUrl);
            final res=await http.get(uri);
            Navigator.pop(context);
            final bytes=res.bodyBytes;
            final temp=await getTemporaryDirectory();
            final path='${temp.path}/image.jpg';
            File(path).writeAsBytes(bytes);
            await Share.shareFiles([path]);
          }, icon: const Icon(Icons.share)),
          PopupMenuButton(itemBuilder: (context)=>[
            PopupMenuItem(
              padding: const EdgeInsets.only(left: 20),
              onTap: ()async{
                await GallerySaver.saveImage('${widget.imageUrl}.jpg',albumName: 'FMH',);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloaded to Gallery!'))
                );
              },
              child: Row(
              children: const [
                Icon(FontAwesomeIcons.floppyDisk,color: Colors.black,size: 25,),
                SizedBox(width: 20,),
                Text('Save to Gallery'),
              ],
            ),),
          ],
          ),
        ],

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
