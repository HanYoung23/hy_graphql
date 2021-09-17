import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';

class ProfileSetScreen extends StatefulWidget {
  const ProfileSetScreen({Key key}) : super(key: key);

  @override
  _ProfileSetScreenState createState() => _ProfileSetScreenState();
}

class _ProfileSetScreenState extends State<ProfileSetScreen> {
  final nicknameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // bool isFocus = false;
  // int borderColor = 211;

  Color enableColor = Color.fromRGBO(5, 138, 221, 1);
  Color unfocusColor = Color.fromRGBO(211, 211, 211, 1);
  Color errorColor = Color.fromRGBO(255, 49, 32, 1);
  Color currentColor = Color.fromRGBO(211, 211, 211, 1);
  String inputMessage = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: EdgeInsets.all(ScreenUtil().setSp(20)),
            child: Column(
              children: [
                Container(
                  width: ScreenUtil().setWidth(375),
                  height: ScreenUtil().setHeight(44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: ScreenUtil().setSp(arrow_back_size),
                        ),
                      ),
                      Text(
                        "프로필 설정",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            // fontStyle: NotoSansCJKKR-Bold
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_back,
                        size: ScreenUtil().setSp(arrow_back_size),
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(12)),
                Image.asset(
                    "assets/images/profileSettings/thumbnail_default.png",
                    width: ScreenUtil().setWidth(101),
                    height: ScreenUtil().setHeight(101)),
                SizedBox(height: ScreenUtil().setHeight(3)),
                Image.asset("assets/images/profileSettings/change_button.png",
                    width: ScreenUtil().setWidth(44),
                    height: ScreenUtil().setHeight(18)),
                SizedBox(height: ScreenUtil().setHeight(7)),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Image.asset(
                      "assets/images/profileSettings/profile_nickname.png",
                      width: ScreenUtil().setWidth(66),
                      height: ScreenUtil().setHeight(20))
                ]),
                SizedBox(height: ScreenUtil().setHeight(5)),
                Container(
                    width: ScreenUtil().setWidth(335),
                    height: ScreenUtil().setHeight(44),
                    child: TextFormField(
                      controller: nicknameController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      onChanged: (_) {
                        setState(() {
                          inputMessage = "";
                          currentColor = unfocusColor;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: currentColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: '별명을 입력해주세요',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(188, 192, 193, 1)),
                        suffixIcon: InkWell(
                          onTap: () {
                            // 서버 통신해서 결과별로 state 다르게 설정, 특수문자 유효성 추가
                            setState(() {
                              currentColor = errorColor;
                              inputMessage = "이미 사용 중인 별명입니다.";
                            });
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(56),
                            height: ScreenUtil().setHeight(34),
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(5),
                                horizontal: ScreenUtil().setWidth(8)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: nicknameController.text.length > 2
                                  ? Color.fromRGBO(5, 138, 221, 1)
                                  : Color.fromRGBO(5, 138, 221, 0.3),
                            ),
                            child: Center(
                                child: Text(
                              "적용",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: ScreenUtil().setHeight(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Text(
                      "$inputMessage",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: inputMessage != ""
                              ? currentColor
                              : Colors.transparent),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: ScreenUtil().setSp(10)),
                    Image.asset(
                      "assets/images/profileSettings/content.png",
                      width: ScreenUtil().setSp(284),
                      height: ScreenUtil().setSp(40),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: ScreenUtil().setWidth(335),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(13)),
                  decoration: BoxDecoration(
                      color: nicknameController.text.length > 2
                          ? Color.fromRGBO(5, 138, 221, 1)
                          : Color.fromRGBO(5, 138, 221, 0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "회원가입 완료",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
