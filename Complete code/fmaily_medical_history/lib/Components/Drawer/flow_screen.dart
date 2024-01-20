import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fmaily_medical_history/Components/Drawer/menu_screen.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Screens/home_screen.dart';

class FlowScreen extends StatefulWidget {
  const FlowScreen({Key? key}) : super(key: key);

  @override
  _FlowScreenState createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.defaultStyle,
        menuScreen: const MenuScreen(),
        mainScreen: const HomeScreen(),
      androidCloseOnBackTap: true,
      menuBackgroundColor: kprimarycolor,
      menuScreenTapClose: true,
      mainScreenTapClose: true,
      slideWidth: 300,
      angle: 0.0,

      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade900,
          spreadRadius: 20,
          blurRadius: 12,
          offset: const Offset(0, 20),
        ),
      ],
    );
  }
}
