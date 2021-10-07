import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geocoder/geocoder.dart';

class AddressWeb extends StatelessWidget {
  final Function callback;
  const AddressWeb({Key key, @required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebViewController _webViewController;
    return Scaffold(
      appBar: AppBar(title: Text("주소 검색")),
      body: Container(
        child: WebView(
          initialUrl: 'http://plinic.cafe24app.com/api/daumFlutterPost',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            // _loadHtmlFromAssets();
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'messageHandler',
        onMessageReceived: (JavascriptMessage message) {
          var jsonData = jsonDecode(message.message);
          String address = "${jsonData["roadAddress"]}";

          getAddressCoordinate(address).then((value) {
            double lng = value.longitude;
            double lat = value.latitude;
            Map addressMap = {"address": address, "lat": lat, "lng": lng};
            print("🚨 address : $addressMap");
            callback(addressMap);

            Get.back();
          });
        });
  }
}

Future getAddressCoordinate(String address) async {
  var addresses = await Geocoder.local.findAddressesFromQuery(address);
  var coord = addresses.first.coordinates;
  return coord;
}
