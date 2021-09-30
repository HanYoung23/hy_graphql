// import 'dart:typed_data';

// import 'package:intl/intl.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:flutter_exif/flutter_exif.dart';

// class Example extends StatefulWidget {
//   @override
//   _ExampleState createState() => _ExampleState();
// }

// class _ExampleState extends State<Example> {

//   int startingAt = 1574679600000;
//   int endingAt = 1575370800000;

//   Map<String,Uint8List> images = Map<String,Uint8List>();
//   List<FlutterExifData> items = List<FlutterExifData>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app')
//         ),
//         body: 
//     );
//   }

//   Widget _list( BuildContext context ) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: this.items.length,
//       itemBuilder: (BuildContext context, int index) {
//         FlutterExifData item = this.items[index];
//         if (!images.containsKey( item.identifier )) {
//           FlutterExif.image( item.identifier, width: 64, height: 64 ).then( (imageData) {
//             setState(() {
//               this.images[ item.identifier ] = imageData;
//             });
//           });
//         }
//         return Padding(
//           padding: EdgeInsets.all( 4 ),
//           child: ListTile(
//               title: Text("aa"),
//               subtitle: Text( "${item.latitude} ,\n${item.longitude}" ),
//               leading: _imageView( item.identifier )
//           ),
//         );
//       },
//     );
//   }
//   _updateList() {
//     setState(() {
//       this.items = List<FlutterExifData>();
//     });
//   }
// }