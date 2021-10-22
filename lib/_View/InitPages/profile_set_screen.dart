import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';

class ProfileSetScreen extends StatefulWidget {
  final String userId;
  final String loginType;

  const ProfileSetScreen(
      {Key key, @required this.userId, @required this.loginType})
      : super(key: key);

  @override
  _ProfileSetScreenState createState() => _ProfileSetScreenState();
}

class _ProfileSetScreenState extends State<ProfileSetScreen> {
  final nicknameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final validChar = RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z0-9]+$');

  Color enableColor = Color.fromRGBO(5, 138, 221, 1);
  Color focusColor = Color.fromRGBO(211, 211, 211, 1);
  Color errorColor = Color.fromRGBO(255, 49, 32, 1);
  Color currentColor = Color.fromRGBO(211, 211, 211, 1);
  String inputMessage = "";
  XFile pickedImage;
  bool isValid = false;
  bool isAllFilled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.login),
          variables: {
            "login_link": "${widget.userId}",
            "login_type": "${widget.loginType}",
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            // print("🚨 query : $result");
            Map resultData = result.data["Login"];
            int customerId = resultData["customer_id"];
            String nickname = resultData["nick_name"];
            String profilePhotoLink = resultData["profile_photo_link"];
            int language = resultData["language"];

            return Mutation(
                options: MutationOptions(
                    document: gql(Mutations.createNickname),
                    update: (GraphQLDataProxy proxy, QueryResult result) {},
                    onCompleted: (dynamic resultData) {
                      print("🚨 resultData : $resultData");
                      if (isAllFilled) {
                        if (resultData["createNickname"]["result"]) {
                          storeUserData("isProfileSet", "true");
                          storeUserData("customerId", "$customerId");
                          Get.to(() => HomePage());
                        } else {
                          Get.snackbar("error",
                              "${resultData["createNickname"]["msg"]}");
                        }
                      } else {
                        if (resultData["createNickname"]["result"]) {
                          setState(() {
                            inputMessage = "사용 가능한 별명입니다 :)";
                            currentColor = enableColor;
                            isAllFilled = true;
                          });
                        } else if ("${resultData["createNickname"]["msg"]}" ==
                            "???") {
                          setState(() {
                            inputMessage = "이미 사용 중인 별명입니다.";
                            currentColor = errorColor;
                            isAllFilled = false;
                          });
                        } else {
                          setState(() {
                            inputMessage = "";
                            currentColor = errorColor;
                            isAllFilled = false;
                          });
                          Get.snackbar("error",
                              "${resultData["createNickname"]["msg"]}");
                        }
                      }
                      FocusScope.of(context).unfocus();
                    }),
                builder: (RunMutation runMutation, QueryResult queryResult) {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Image.asset(
                                          "assets/images/arrow_back.png",
                                          width: ScreenUtil()
                                              .setSp(arrow_back_size),
                                          height: ScreenUtil()
                                              .setSp(arrow_back_size)),
                                    ),
                                    Text(
                                      "프로필 설정",
                                      style: TextStyle(
                                          fontSize: ScreenUtil()
                                              .setSp(appbar_title_size),
                                          letterSpacing: -0.4,
                                          fontWeight: appbar_title_weight),
                                    ),
                                    Image.asset("assets/images/arrow_back.png",
                                        color: Colors.transparent,
                                        width:
                                            ScreenUtil().setSp(arrow_back_size),
                                        height: ScreenUtil()
                                            .setSp(arrow_back_size)),
                                  ],
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(12)),
                              InkWell(
                                onTap: () {
                                  checkGalleryPermission()
                                      .then((permission) async {
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
                                        ? profilePhotoLink == null
                                            ? Image.asset(
                                                "assets/images/profileSettings/thumbnail_default.png",
                                                width: ScreenUtil().setSp(101),
                                                height: ScreenUtil().setSp(101))
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                    profilePhotoLink,
                                                    fit: BoxFit.cover,
                                                    width:
                                                        ScreenUtil().setSp(101),
                                                    height: ScreenUtil()
                                                        .setSp(101)),
                                              )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                              SizedBox(height: ScreenUtil().setHeight(7)),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                        "assets/images/profileSettings/profile_nickname.png",
                                        width: ScreenUtil().setWidth(66),
                                        height: ScreenUtil().setHeight(20))
                                  ]),
                              SizedBox(height: ScreenUtil().setHeight(5)),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: TextFormField(
                                    controller: nicknameController,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        String typedData =
                                            value[value.length - 1];
                                        if (!validChar.hasMatch(typedData) ||
                                            typedData == " ") {
                                          setState(() {
                                            isValid = false;
                                            inputMessage =
                                                "별명은 한글, 영문, 숫자만 사용 가능합니다.";
                                            currentColor = errorColor;
                                          });
                                        } else if (nicknameController
                                                .text.length <
                                            2) {
                                          setState(() {
                                            isValid = false;
                                            inputMessage = "";
                                            currentColor = focusColor;
                                          });
                                        } else {
                                          setState(() {
                                            isValid = true;
                                            inputMessage = "";
                                            currentColor = focusColor;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          isValid = false;
                                          inputMessage = "";
                                          currentColor = focusColor;
                                        });
                                      }
                                      setState(() {
                                        isAllFilled = false;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: ScreenUtil().setSp(10)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: currentColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      hintText: nickname == null
                                          ? '별명을 입력해주세요'
                                          : nickname,
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(188, 192, 193, 1),
                                          fontSize: ScreenUtil().setSp(14)),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          if (isValid) {
                                            runMutation({
                                              "nick_name":
                                                  nicknameController.text,
                                              "profile_photo_link": "",
                                              "customer_id": customerId,
                                            });
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        child: Container(
                                          width: ScreenUtil().setWidth(56),
                                          height: ScreenUtil().setHeight(34),
                                          margin: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setHeight(5),
                                              horizontal:
                                                  ScreenUtil().setWidth(8)),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: isValid
                                                ? Color.fromRGBO(5, 138, 221, 1)
                                                : Color.fromRGBO(
                                                    5, 138, 221, 0.3),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "적용",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14),
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
                              InkWell(
                                onTap: () async {
                                  if (isAllFilled) {
                                    if (pickedImage != null) {
                                      File file = File(pickedImage.path);
                                      uploadAWS([file]).then((awsLink) {
                                        if (awsLink[0] != null) {
                                          runMutation({
                                            "nick_name":
                                                "${nicknameController.text}",
                                            "profile_photo_link":
                                                "${awsLink[0]}",
                                            "customer_id": customerId,
                                          });
                                        } else {
                                          runMutation({
                                            "nick_name":
                                                "${nicknameController.text}",
                                            "profile_photo_link": "",
                                            "customer_id": customerId,
                                          });
                                        }
                                      });
                                    } else {
                                      if (profilePhotoLink == null) {
                                        runMutation({
                                          "nick_name":
                                              "${nicknameController.text}",
                                          "profile_photo_link": "",
                                          "customer_id": customerId,
                                        });
                                      } else {
                                        runMutation({
                                          "nick_name":
                                              "${nicknameController.text}",
                                          "profile_photo_link":
                                              profilePhotoLink,
                                          "customer_id": customerId,
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(335),
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(13)),
                                  decoration: BoxDecoration(
                                      color: isAllFilled
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingIndicator(),
                        ],
                      ),
                    )),
              ),
            );
          }
        });
  }
}
