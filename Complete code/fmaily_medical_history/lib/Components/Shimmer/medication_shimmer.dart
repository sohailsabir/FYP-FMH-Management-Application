import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingListPage extends StatefulWidget {
  @override
  _LoadingListPageState createState() => _LoadingListPageState();
}

class _LoadingListPageState extends State<LoadingListPage> {
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
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   width: 48.0,
                        //   height: 48.0,
                        //   color: Colors.white,
                        // ),
                        const CircleAvatar(
                          radius: 30.0,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 11.0,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 15,),
                              Container(
                                width: 150,
                                height: 10.0,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10,),
                              Container(
                                width: 200,
                                height: 10.0,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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