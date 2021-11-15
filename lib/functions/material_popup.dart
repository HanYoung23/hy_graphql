import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/InitPages/authority_screen.dart';
import 'package:letsgotrip/_View/InitPages/login_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/report_dialog_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// void gpsNullPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title:  Text("사진에 위치 정보가 없습니다."),
//           content:  Text("위치 검색 후 진행할 수 있습니다."),
//           actions: <Widget>[
//              InkWell(
//                onTap: (){
//                  Get.to
//                },
//                child: Text("위치 검색 하기", style: TextStyle(fontSize : ScreenUtil().setSp(16))))
//           ],
//         );
//       },
//     );
//   }

savePostPopup(BuildContext context, Function saveDataCallback) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "임시저장 하시겠습니까?\n다음 게시물 작성 시 불러올 수 있습니다.",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                          )),
                      SizedBox(
                        width: ScreenUtil().setSp(20),
                      ),
                      InkWell(
                          onTap: () {
                            saveDataCallback();
                            Get.back();
                          },
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

callSaveDataPopup(BuildContext context, Function callSaveDataCallback) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(348),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    "이전에 임시저장했던 게시물이 있습니다.\n이어서 작성하시겠습니까?",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(letter_spacing),
                      height: ScreenUtil().setSp(1.4),
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(height: ScreenUtil().setSp(30)),
                  Text(
                    "새롭게 작성하게 되면 임시저장된 게시물은\n초기화됩니다.",
                    style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: ScreenUtil().setSp(letter_spacing),
                      color: app_font_grey,
                      height: ScreenUtil().setSp(1.4),
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(height: ScreenUtil().setSp(40)),
                  InkWell(
                    onTap: () {
                      callSaveDataCallback();
                      Get.back();
                    },
                    child: Container(
                      width: ScreenUtil().setSp(296),
                      height: ScreenUtil().setSp(44),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(5)),
                        color: app_blue,
                      ),
                      child: Center(
                        child: Text(
                          "네, 이어서 작성할게요.",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrRegular",
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  InkWell(
                    onTap: () {
                      deleteUserData("postSaveData").then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              '이전 게시물을 초기화합니다.',
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            elevation: 0,
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(21)),
                            ),
                            backgroundColor: Color(0xffb5b5b5),
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setSp(90),
                                left: ScreenUtil().setSp(80),
                                right: ScreenUtil().setSp(80))));
                      });
                      Get.back();
                    },
                    child: Container(
                      width: ScreenUtil().setSp(296),
                      height: ScreenUtil().setSp(44),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(5)),
                        border: Border.all(
                          width: ScreenUtil().setSp(1),
                          color: app_font_grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "아니요, 새롭게 작성할게요.",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrRegular",
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing:
                                ScreenUtil().setSp(letter_spacing_small),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ));
}

logOutPopup(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "로그아웃 하시겠습니까?",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                          )),
                      SizedBox(
                        width: ScreenUtil().setSp(20),
                      ),
                      InkWell(
                          onTap: () {
                            seeValue("loginType").then((loginType) async {
                              // switch (loginType) {
                              //   case "kakao":
                              //     await kakaoLogout();
                              //     break;
                              //   case "naver":
                              //     await naverLogout();
                              //     break;
                              // }
                              // await deleteUserData("userId");
                              // await deleteUserData("customerId");
                              // await deleteUserData("loginType");
                              // await deleteUserData("isProfileSet");
                              await deleteAllUserData();

                              Get.offAll(() => AuthorityScreen());
                            });
                          },
                          child: Text(
                            "로그아웃",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

signOutPopupFirst(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "버튼을 누르시면 정상적으로 진행됩니다.\n탈퇴하시겠습니까?",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                          )),
                      SizedBox(
                        width: ScreenUtil().setSp(20),
                      ),
                      Mutation(
                          options: MutationOptions(
                              document: gql(Mutations.secession),
                              update: (GraphQLDataProxy proxy,
                                  QueryResult result) {},
                              onCompleted: (dynamic resultData) async {
                                print("🚨 signout result : $resultData");
                                if (resultData["secession"]["result"]) {
                                  await deleteAllUserData();
                                  signOutPopupSecond(context);
                                }
                              }),
                          builder: (RunMutation runMutation,
                              QueryResult queryResult) {
                            return InkWell(
                                onTap: () {
                                  seeValue("customerId").then((customerId) {
                                    runMutation(
                                        {"customer_id": int.parse(customerId)});
                                  });
                                },
                                child: Text(
                                  "탈퇴하기",
                                  style: TextStyle(
                                    fontFamily: "NotoSansCJKkrBold",
                                    fontSize: ScreenUtil().setSp(16),
                                    letterSpacing:
                                        ScreenUtil().setSp(letter_spacing),
                                  ),
                                ));
                          })
                    ],
                  )
                ],
              ),
            ),
          ));
}

signOutPopupSecond(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "탈퇴되었습니다.\n로그인 화면으로 돌아갑니다.",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.offAll(() => LoginScreen());
                          },
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

permissionPopup(BuildContext context, String content) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      content,
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                          )),
                      SizedBox(
                        width: ScreenUtil().setSp(20),
                      ),
                      InkWell(
                          onTap: () {
                            openAppSettings();
                            Get.back();
                          },
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

deleteCommentPopup(BuildContext context, Function runMutationCallback) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "등록하신 댓글이 삭제됩니다.\n삭제 하시겠습니까?",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                          )),
                      SizedBox(
                        width: ScreenUtil().setSp(20),
                      ),
                      InkWell(
                          onTap: () {
                            runMutationCallback();
                            Get.back();
                          },
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

deletePostPopup(BuildContext context, Function runMutationCallback) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "등록하신 게시물이 삭제됩니다.\n삭제 하시겠습니까?",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                          )),
                      SizedBox(
                        width: ScreenUtil().setSp(20),
                      ),
                      InkWell(
                          onTap: () {
                            runMutationCallback();
                            Get.back();
                          },
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

reportPostPopup(BuildContext context, int contentsId) {
  showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: ReportDialogScreen(contentsId: contentsId),
          ));
}

reportPostDonePopup(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
            ),
            content: Container(
              width: ScreenUtil().setSp(336),
              height: ScreenUtil().setSp(156),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(14),
                  ),
                  Container(
                    child: Text(
                      "신고가 정상적으로 접수되었습니다.\n확인후 신속하게 처리하겠습니다.",
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: ScreenUtil().setSp(letter_spacing),
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ));
}
