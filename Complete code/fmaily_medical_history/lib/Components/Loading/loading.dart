import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
final spinkit = SpinKitFadingCircle(
  size: 70,
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? kprimarycolor : Colors.orange,
        shape: BoxShape.circle
      ),
    );
  },
);

final loadingImage=SpinKitPouringHourGlassRefined(
  color: kprimarycolor,
  size: 50,
);