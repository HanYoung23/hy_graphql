
//  import 'dart:io';

// import 'dart:typed_data';

// Future<Uint8List> getFaceFromImage(File imageFile) async {
//     final image = await imageFile.readAsBytes();
//     final decodedImage = decodeImage(image);

//     final rectangle = this.boundingBox;

//     final face = copyCrop(
//       decodedImage,
//       rectangle.topLeft.dx.toInt(),
//       rectangle.topLeft.dy.toInt(),
//       rectangle.width.toInt(),
//       rectangle.height.toInt(),
//     );

//     return Uint8List.fromList(encodePng(face));
//   }
