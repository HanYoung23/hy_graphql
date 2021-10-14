import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({Key key}) : super(key: key);

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Container(child: Text("data"))));
  }
}
