import 'package:flutter/material.dart';
const kprimarycolor=Colors.indigo;
const drawerMenuColor=Colors.white;
const backColor=Color(0xFFE0E5FD);
const familyMemberStyle=TextStyle(color: kprimarycolor,fontWeight: FontWeight.bold,fontSize: 16);
const medicationsIconColor=Color(0xFF757575);

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}