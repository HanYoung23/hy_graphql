import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

Future uploadAWS(List imageFiles) async {
  var option = UploadFileOptions(
    accessLevel: StorageAccessLevel.guest,
    contentType: "image/png",
  );
  List propsImageList = imageFiles;
  // print("🚨 imageFiles : $imageFiles");

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000);

  Im.Image image = Im.decodeImage(File(imageFiles[0].path).readAsBytesSync());
  Im.Image smallerImage = Im.copyResize(image, width: 150, height: 150);

  var compressedImage = new File('$path/img_$rand.jpg')
    ..writeAsBytesSync(Im.encodeJpg(smallerImage));

  propsImageList.insert(0, compressedImage);

  // print("🚨 compressedImage : $compressedImage");
  // print("🚨 propsImageList : $propsImageList");

  List<String> photoUrlList = [];
  for (var file in propsImageList) {
    final key = "${DateTime.now().toString()}.png";
    await Amplify.Storage.uploadFile(local: file, key: key, options: option)
        .then((result) async {
      var photoOption = GetUrlOptions(accessLevel: StorageAccessLevel.guest);
      GetUrlResult storageUrl =
          await Amplify.Storage.getUrl(key: key, options: photoOption);
      String shortUrl =
          storageUrl.url.substring(0, storageUrl.url.indexOf("?X-Amz"));

      photoUrlList.add(shortUrl);
      print('🚨 Successfully uploaded url: $shortUrl');
    });
  }
  return photoUrlList;
}

Future editUploadAWS(List imageFiles) async {
  var option = UploadFileOptions(
    accessLevel: StorageAccessLevel.guest,
    contentType: "image/png",
  );
  List<String> photoUrlList = [];

  List propsImageList = [];
  for (String file in imageFiles) {
    if (file.toString().substring(0, 4) != "http") {
      propsImageList.add(file);
    }
  }
  //

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000);

  Im.Image image =
      Im.decodeImage(File(propsImageList[0].path).readAsBytesSync());
  Im.Image smallerImage = Im.copyResize(image, width: 150, height: 150);

  var compressedImage = new File('$path/img_$rand.jpg')
    ..writeAsBytesSync(Im.encodeJpg(smallerImage));

  propsImageList.insert(0, compressedImage);
//

  for (String file in propsImageList) {
    if (file.toString().substring(0, 4) != "http") {
      File fileName = File(file);
      final key = "${DateTime.now().toString()}.png";

      await Amplify.Storage.uploadFile(
              local: fileName, key: key, options: option)
          .then((result) async {
        var photoOption = GetUrlOptions(accessLevel: StorageAccessLevel.guest);
        GetUrlResult storageUrl =
            await Amplify.Storage.getUrl(key: key, options: photoOption);
        String shortUrl =
            storageUrl.url.substring(0, storageUrl.url.indexOf("?X-Amz"));

        photoUrlList.add(shortUrl);
        print('🚨 Successfully uploaded url: ${result.key}, $shortUrl');
      });
    } else {
      photoUrlList.add(file);
    }
  }
  return photoUrlList;
}

Future profileImageUploadAWS(List imageFiles) async {
  var option = UploadFileOptions(
    accessLevel: StorageAccessLevel.guest,
    contentType: "image/png",
  );
  List<String> photoUrlList = [];
  for (var file in imageFiles) {
    final key = "${DateTime.now().toString()}.png";
    await Amplify.Storage.uploadFile(local: file, key: key, options: option)
        .then((result) async {
      var photoOption = GetUrlOptions(accessLevel: StorageAccessLevel.guest);
      GetUrlResult storageUrl =
          await Amplify.Storage.getUrl(key: key, options: photoOption);
      String shortUrl =
          storageUrl.url.substring(0, storageUrl.url.indexOf("?X-Amz"));

      photoUrlList.add(shortUrl);
      print('🚨 Successfully uploaded url: $shortUrl');
    });
  }
  return photoUrlList;
}
