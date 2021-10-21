import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChanneltalkBottomSheet extends StatelessWidget {
  const ChanneltalkBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().screenHeight * 0.9,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: WebView(
              initialUrl: 'https://letsgotrip.channel.io',
              javascriptMode: JavascriptMode.unrestricted,
            )),
      ),
    );
  }
}
