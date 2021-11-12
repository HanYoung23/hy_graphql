import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

class ServicePersonalPolicyScreen extends StatefulWidget {
  const ServicePersonalPolicyScreen({Key key}) : super(key: key);

  @override
  _ServicePersonalPolicyScreenState createState() =>
      _ServicePersonalPolicyScreenState();
}

class _ServicePersonalPolicyScreenState
    extends State<ServicePersonalPolicyScreen> {
  String data;

  Future loadData() async {
    final loadedData = await rootBundle.loadString('assets/texts/policy.txt');
    setState(() {
      data = loadedData;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil().setSp(20)),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setSp(44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset("assets/images/arrow_back.png",
                                  width: ScreenUtil().setSp(arrow_back_size),
                                  height: ScreenUtil().setSp(arrow_back_size))),
                        ),
                      ),
                      Text(
                        "개인정보 처리방침",
                        style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small)),
                      ),
                      Expanded(
                        child: Image.asset("assets/images/arrow_back.png",
                            color: Colors.transparent,
                            width: ScreenUtil().setSp(arrow_back_size),
                            height: ScreenUtil().setSp(arrow_back_size)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setSp(24)),
                Container(
                  child: Text(
                    data == null ? "" : data,
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(14),
                      letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
