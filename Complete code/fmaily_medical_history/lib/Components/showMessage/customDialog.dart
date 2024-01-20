import 'package:flutter/material.dart';
import '../../Constants/constant.dart';

class customDialog extends StatelessWidget {
  customDialog({required this.message,required this.icon,required this.title}) ;
  final String message;
  final IconData icon;
  final String title;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 2),
      title: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.cancel,color: Color(0xFFC8CDCF),),
              onPressed: (){
                Navigator.pop(context);
              },

            ),
          ),
          Icon(icon,
            color: kprimarycolor,size: 50,),
          const SizedBox(
            height: 10,
          ),
          Center(child: Text(title,style: const TextStyle(
              fontSize: 20
          ),)),
        ],
      ),
      content: Text(message,
        style: const TextStyle(
            color: Colors.grey,
            fontSize: 16
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: ElevatedButton(onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8CDCF),
              foregroundColor: Colors.black,
              minimumSize: const Size(350, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
              elevation: 0.0,
            ),
            child: const Text("OK"),),
        ),
      ],
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(10),

    );
  }
}