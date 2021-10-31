import 'dart:io';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

Future uploadAWS(List<File> imageFiles) async {
  var option = UploadFileOptions(
    accessLevel: StorageAccessLevel.guest,
    contentType: "image/png",
  );
  List<String> photoUrlList = [];
  for (File file in imageFiles) {
    final key = "${DateTime.now().toString()}.png";
    try {
      await Amplify.Storage.uploadFile(local: file, key: key, options: option)
          .then((result) async {
        var photoOption = GetUrlOptions(accessLevel: StorageAccessLevel.guest);
        GetUrlResult storageUrl =
            await Amplify.Storage.getUrl(key: key, options: photoOption);
        String shortUrl =
            storageUrl.url.substring(0, storageUrl.url.indexOf("?X-Amz"));

        photoUrlList.add(shortUrl);
        print('🚨 Successfully uploaded url: ${result.key}');
      });
    } on StorageException catch (e) {
      print('🚨 Error uploading image: $e');
    }
  }
  return photoUrlList;
}

Future editUploadAWS(List imageFiles) async {
  var option = UploadFileOptions(
    accessLevel: StorageAccessLevel.guest,
    contentType: "image/png",
  );
  List<String> photoUrlList = [];
  for (String file in imageFiles) {
    if (file.toString().substring(0, 4) != "http") {
      File fileName = File(file);
      final key = "${DateTime.now().toString()}.png";
      try {
        await Amplify.Storage.uploadFile(
                local: fileName, key: key, options: option)
            .then((result) async {
          var photoOption =
              GetUrlOptions(accessLevel: StorageAccessLevel.guest);
          GetUrlResult storageUrl =
              await Amplify.Storage.getUrl(key: key, options: photoOption);
          String shortUrl =
              storageUrl.url.substring(0, storageUrl.url.indexOf("?X-Amz"));

          photoUrlList.add(shortUrl);
          print('🚨 Successfully uploaded url: ${result.key}');
        });
      } on StorageException catch (e) {
        print('🚨 Error uploading image: $e');
      }
    } else {
      photoUrlList.add(file);
    }
  }
  return photoUrlList;
}
