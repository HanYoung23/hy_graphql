import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class ProfileEditNicknameScreen extends StatefulWidget {
  final String nickname;
  final Function setNickname;
  final String profilePhoto;
  const ProfileEditNicknameScreen(
      {Key key,
      @required this.nickname,
      @required this.setNickname,
      @required this.profilePhoto})
      : super(key: key);

  @override
  _ProfileEditNicknameScreenState createState() =>
      _ProfileEditNicknameScreenState();
}

class _ProfileEditNicknameScreenState extends State<ProfileEditNicknameScreen> {
  final nicknameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.createNickname),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) {
              print("🚨 resultData : $resultData");
              if (isAllFilled) {
                if (resultData["createNickname"]["result"]) {
                  storeUserData("isProfileSet", "true");
                  Get.offAll(() => HomePage());
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
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return SafeArea(
            top: false,
            bottom: true,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: Colors.black,
                  brightness: Brightness.dark,
                ),
                resizeToAvoidBottomInset: false,
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
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                    "assets/images/arrow_back.png",
                                    width: ScreenUtil().setSp(arrow_back_size),
                                    height:
                                        ScreenUtil().setSp(arrow_back_size))),
                            InkWell(
                              onTap: () {
                                print("🚨 ${nicknameController.text}");
                              },
                              child: Text(
                                "프로필 별명",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil().setSp(appbar_title_size),
                                    letterSpacing: -0.4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (inputMessage == "사용 가능한 별명입니다 :)") {
                                  widget.setNickname(nicknameController.text);
                                  Get.back();
                                }
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "완료",
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(appbar_title_size),
                                      letterSpacing: -0.4,
                                      color: inputMessage == "사용 가능한 별명입니다 :)"
                                          ? Colors.black
                                          : app_font_grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
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
                                } else if (nicknameController.text ==
                                    widget.nickname) {
                                  setState(() {
                                    isValid = false;
                                    inputMessage = "현재와 동일한 별명입니다.";
                                    currentColor = errorColor;
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
                                  letterSpacing: -0.35,
                                  fontSize: ScreenUtil().setSp(14)),
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (isValid) {
                                    seeValue("customerId").then((value) {
                                      int customerId = int.parse(value);
                                      runMutation({
                                        "nick_name": nicknameController.text,
                                        "profile_photo_link":
                                            "${widget.profilePhoto}",
                                        "customer_id": customerId,
                                      });
                                    });

                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(56),
                                  height: ScreenUtil().setHeight(34),
                                  margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5),
                                      horizontal: ScreenUtil().setWidth(8)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setSp(5)),
                                    color: isValid
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
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
