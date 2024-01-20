import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class customSnackBarContainer extends StatelessWidget {
  customSnackBarContainer({required this.text,required this.title});
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.all(16.0),
            height: 95.0,
            decoration: BoxDecoration(
              color: Colors.indigo.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(20.0),),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style:
                      const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),),
                      const Spacer(),
                      Text(text,style:
                      const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                ),
              ],
            )),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
            child: SvgPicture.asset("assets/bubbles.svg",height: 50,width: 45,
              color: Colors.indigo.shade400,
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset("assets/circle.svg",
                height: 55,
                color: Colors.indigo.shade400,),
              SvgPicture.asset("assets/check.svg",height: 16,
                color: Colors.white,),
            ],
          ),
        ),
      ],
    );
  }
}
