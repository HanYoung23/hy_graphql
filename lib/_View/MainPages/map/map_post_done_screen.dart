import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/homepage.dart';

class MapPostDoneScreen extends StatelessWidget {
  const MapPostDoneScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: InkWell(
                onTap: () {
                  Get.to(() => HomePage());
                },
                child: Text("upload done"))),
      ),
    );
  }
}
