import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key key,
  }) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final picker = ImagePicker();
  XFile pickedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setSp(20)),
                      child: Column(children: [
                        Container(
                          width: ScreenUtil().setWidth(375),
                          height: ScreenUtil().setHeight(44),
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
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: ScreenUtil().setSp(arrow_back_size),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "프로필 수정",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil().setSp(appbar_title_size),
                                    letterSpacing: -0.4,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "완료",
                                      style: TextStyle(
                                          fontSize: ScreenUtil()
                                              .setSp(appbar_title_size),
                                          letterSpacing: -0.4,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setSp(10)),
                        InkWell(
                          onTap: () {
                            checkGalleryPermission().then((permission) async {
                              if (permission) {
                                picker
                                    .pickImage(
                                        maxWidth: 1000,
                                        maxHeight: 1000,
                                        source: ImageSource.gallery)
                                    .then((image) {
                                  if (image != null) {
                                    setState(() {
                                      pickedImage = image;
                                    });
                                  }
                                });
                              } else {
                                Get.snackbar("error", "사진 접근 권한이 없습니다.");
                              }
                            });
                          },
                          child: Column(
                            children: [
                              pickedImage == null
                                  ? Image.asset(
                                      "assets/images/profileSettings/thumbnail_default.png",
                                      width: ScreenUtil().setSp(101),
                                      height: ScreenUtil().setSp(101))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        File(pickedImage.path),
                                        width: ScreenUtil().setSp(101),
                                        height: ScreenUtil().setSp(101),
                                        fit: BoxFit.cover,
                                      )),
                              SizedBox(height: ScreenUtil().setHeight(3)),
                              Image.asset(
                                  "assets/images/profileSettings/change_button.png",
                                  width: ScreenUtil().setWidth(44),
                                  height: ScreenUtil().setHeight(18)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      color: app_grey_light,
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(10),
                    ),
                    SizedBox(height: ScreenUtil().setSp(20)),
                    Container(
                        width: ScreenUtil().screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "프로필 별명",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Text(
                              "홍길동",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  color: app_font_grey,
                                  letterSpacing: -0.4),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Container(
                              color: app_grey_light,
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(2),
                            )
                          ],
                        )),
                    SizedBox(height: ScreenUtil().setSp(30)),
                    Container(
                        width: ScreenUtil().screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "프로필 소개",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Text(
                              "소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개 소개",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  color: app_font_grey,
                                  letterSpacing: -0.4),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Container(
                              color: app_grey_light,
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(2),
                            )
                          ],
                        )),
                  ],
                )))));
  }
}
