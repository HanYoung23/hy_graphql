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
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class ProfileSetScreen extends StatefulWidget {
  final String userId;
  final String loginType;
  final String nickname;
  final String photoUrl;

  const ProfileSetScreen(
      {Key key,
      @required this.userId,
      @required this.loginType,
      this.nickname,
      this.photoUrl})
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
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.nickname != null) {
      nicknameController.text = widget.nickname;
      setState(() {
        isAllFilled = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.createNickname),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) {
              // print("🚨 resultData : $resultData");
              if (isAllFilled) {
                if (resultData["createNickname"]["result"]) {
                  storeUserData("isProfileSet", "true");
                  Get.off(() => HomePage());
                } else {
                  Get.snackbar(
                      "error", "${resultData["createNickname"]["msg"]}");
                }
              } else {
                if (resultData["createNickname"]["result"]) {
                  setState(() {
                    inputMessage = "사용 가능한 별명입니다 :)";
                    currentColor = enableColor;
                    isAllFilled = true;
                  });
                } else if ("${resultData["createNickname"]["msg"]}" == "???") {
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
                  Get.snackbar(
                      "error", "${resultData["createNickname"]["msg"]}");
                }
              }
              FocusScope.of(context).unfocus();
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return SafeArea(
            top: false,
            bottom: false,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                ),
                body: Container(
                  margin: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child: Column(
                    children: [
                      Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(44),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/images/arrow_back.png",
                                color: Colors.transparent,
                                width: ScreenUtil().setSp(arrow_back_size),
                                height: ScreenUtil().setSp(arrow_back_size)),
                            Text(
                              "프로필 설정",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(appbar_title_size),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                              ),
                            ),
                            Image.asset("assets/images/arrow_back.png",
                                color: Colors.transparent,
                                width: ScreenUtil().setSp(arrow_back_size),
                                height: ScreenUtil().setSp(arrow_back_size)),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
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
                              permissionPopup(context,
                                  "사진 접근이 허용되어있지 않있습니다.\n설정에서 허용 후 이용 가능합니다.");
                            }
                          });
                        },
                        child: Column(
                          children: [
                            pickedImage == null
                                ? widget.photoUrl == null ||
                                        widget.photoUrl == "null"
                                    ? Image.asset(
                                        "assets/images/profileSettings/thumbnail_default.png",
                                        width: ScreenUtil().setSp(101),
                                        height: ScreenUtil().setSp(101))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(50)),
                                        child: Image.network(
                                          widget.photoUrl,
                                          width: ScreenUtil().setSp(101),
                                          height: ScreenUtil().setSp(101),
                                          fit: BoxFit.cover,
                                        ))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setSp(50)),
                                    child: Image.file(
                                      File(pickedImage.path),
                                      width: ScreenUtil().setSp(101),
                                      height: ScreenUtil().setSp(101),
                                      fit: BoxFit.cover,
                                    )),
                            SizedBox(height: ScreenUtil().setHeight(3)),
                            Text(
                              "변경하기",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(12),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_x_small),
                                color: app_grey_dark,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(7)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "프로필 별명",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
                                color: Colors.black,
                              ),
                            )
                          ]),
                      SizedBox(height: ScreenUtil().setHeight(5)),
                      Container(
                          alignment: Alignment.bottomLeft,
                          child: TextFormField(
                            controller: nicknameController,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              if (value.length > 0 && value.length < 13) {
                                String typedData = value[value.length - 1];
                                if (!validChar.hasMatch(typedData) ||
                                    typedData == " ") {
                                  setState(() {
                                    isValid = false;
                                    inputMessage = "별명은 한글, 영문, 숫자만 사용 가능합니다.";
                                    currentColor = errorColor;
                                  });
                                } else if (nicknameController.text.length < 2) {
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
                              } else if (value.length > 12) {
                                setState(() {
                                  isValid = false;
                                  inputMessage = "12자 이상은 사용 불가합니다.";
                                  currentColor = errorColor;
                                });
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
                                borderSide: BorderSide(color: currentColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: '별명을 입력해주세요',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(188, 192, 193, 1),
                                  fontSize: ScreenUtil().setSp(14)),
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (isValid && !isAllFilled) {
                                    seeValue("customerId").then((customerId) {
                                      runMutation({
                                        "nick_name": nicknameController.text,
                                        "profile_photo_link": "",
                                        "customer_id": int.parse(customerId),
                                      });
                                    });

                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: Container(
                                  width: ScreenUtil().setSp(56),
                                  height: ScreenUtil().setHeight(34),
                                  margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5),
                                      horizontal: ScreenUtil().setSp(8)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setSp(5)),
                                      color: isValid
                                          ? app_blue
                                          : app_blue_light_button),
                                  child: Center(
                                      child: Text(
                                    "적용",
                                    style: TextStyle(
                                        fontFamily: "NotoSansCJKkrBold",
                                        fontSize: ScreenUtil().setSp(14),
                                        letterSpacing: ScreenUtil()
                                            .setSp(letter_spacing_small),
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
                          SizedBox(width: ScreenUtil().setSp(10)),
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
                          SizedBox(width: ScreenUtil().setSp(14)),
                          Text(
                            "한글 2~12자, 영문 대소문자, 숫자 2~20자에 한하여\n사용가능합니다(혼용 가능)",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                              color: app_grey_login,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          seeValue("customerId").then((customerId) {
                            if (isAllFilled) {
                              if (pickedImage != null) {
                                File file = File(pickedImage.path);
                                uploadAWS([file]).then((awsLink) {
                                  if (awsLink[0] != null) {
                                    runMutation({
                                      "nick_name": "${nicknameController.text}",
                                      "profile_photo_link": "${awsLink[0]}",
                                      "customer_id": int.parse(customerId),
                                    });
                                  } else {
                                    runMutation({
                                      "nick_name": "${nicknameController.text}",
                                      "profile_photo_link": "",
                                      "customer_id": int.parse(customerId),
                                    });
                                  }
                                });
                              } else if (widget.photoUrl != null) {
                                runMutation({
                                  "nick_name": "${nicknameController.text}",
                                  "profile_photo_link": widget.photoUrl,
                                  "customer_id": int.parse(customerId),
                                });
                              } else {
                                runMutation({
                                  "nick_name": "${nicknameController.text}",
                                  "profile_photo_link": "",
                                  "customer_id": int.parse(customerId),
                                });
                              }
                            }
                          });
                        },
                        child: Container(
                          width: ScreenUtil().screenWidth,
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(13)),
                          decoration: BoxDecoration(
                              color: isAllFilled
                                  ? app_blue
                                  : app_blue_light_button,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(10))),
                          child: Center(
                            child: Text(
                              "메인 화면으로 이동",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(16),
                                color: Colors.white,
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setSp(14)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
