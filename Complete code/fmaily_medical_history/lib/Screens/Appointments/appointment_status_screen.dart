
import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppointmentStatus extends StatefulWidget {
  AppointmentStatus({Key? key}) : super(key: key);

  @override
  State<AppointmentStatus> createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus>
    with SingleTickerProviderStateMixin {
  // definition of ParticlesOptions.
  ParticleOptions particles = const ParticleOptions(
    baseColor: Colors.white,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 70,
    spawnMaxRadius: 15.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );
  @override
  Widget build(BuildContext context) {
    // return MaterialApp
    return Scaffold(
      backgroundColor: kprimarycolor,
        body: SafeArea(
          child: AnimatedBackground(
            // vsync uses singleTicketProvider state mixin.
            vsync: this,
            behaviour: RandomParticleBehaviour(options: particles),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: kprimarycolor.shade100,
                        child: const Icon(FontAwesomeIcons.userDoctor,size: 90,color: kprimarycolor,),
                        // backgroundImage: AssetImage('assets/doctorProfile.jpg'),
                      ),
                      const SizedBox(height: 15,),
                      const Text('Appointment with',style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                      const Text('Dr. Ali',style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),),
                      const Text('Purpose: abc',style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    TextButton(
                        onPressed: (){},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18
                        ),
                      ),
                        child: const Text('Attend'),
                    ),
                    TextButton(
                        onPressed: (){},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                        child: const Text('Not Attend'),
                    )
                  ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}