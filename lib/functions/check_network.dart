import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letsgotrip/constants/common_value.dart';

Future checkInternetConnection(BuildContext context) async {
  try {
    final response =
        await InternetAddress.lookup('http://map.cosmeticfitting.com');
    if (response.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '네트워크에 연결되었습니다.',
            style: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              fontSize: ScreenUtil().setSp(14),
              letterSpacing: ScreenUtil().setSp(letter_spacing_small),
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
          ),
          backgroundColor: Color(0xffb5b5b5),
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setSp(90),
              left: ScreenUtil().setSp(80),
              right: ScreenUtil().setSp(80))));
    }
    return true;
  } on SocketException catch (err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '네트워크에 연결되어있지 않습니다.\n$err',
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(14),
            letterSpacing: ScreenUtil().setSp(letter_spacing_small),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(50)),
        ),
        backgroundColor: Color(0xffb5b5b5),
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setSp(90),
            left: ScreenUtil().setSp(80),
            right: ScreenUtil().setSp(80))));
    return false;
  }
}
