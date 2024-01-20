import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class refeshShimmer extends StatefulWidget {
  @override
  _refeshShimmerState createState() => _refeshShimmerState();
}

class _refeshShimmerState extends State<refeshShimmer> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: _enabled,
                child: ListView.builder(
                  itemBuilder: (context,index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                ),
                                const SizedBox(width: 10,),
                                Container(
                                  width: 100,
                                  height: 7.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                ),
                                const SizedBox(width: 10,),
                                Container(
                                  width: 90,
                                  height: 7.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                ),
                                const SizedBox(width: 10,),
                                Container(
                                  width: 100,
                                  height: 7.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,),
                          ],
                        )
                  ),
                  itemCount: 6,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}