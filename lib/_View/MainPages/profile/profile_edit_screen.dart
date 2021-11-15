import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/profile/profile_edit_introduction_screen.dart';
import 'package:letsgotrip/_View/MainPages/profile/profile_edit_nickname_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class ProfileEditScreen extends StatefulWidget {
  final int customerId;
  final Function callbackRefetch;
  const ProfileEditScreen(
      {Key key, @required this.customerId, @required this.callbackRefetch})
      : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final picker = ImagePicker();
  XFile pickedImage;
  String newNickname;
  String newIntroduction;

  setNewNickname(String nickname) {
    setState(() {
      newNickname = nickname;
    });
  }

  setNewIntroduction(String introduction) {
    setState(() {
      newIntroduction = introduction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypage),
          variables: {"customer_id": widget.customerId},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["mypage"][0];
            // print("🚨 mypage result : $resultData");
            String nickname = resultData["nick_name"];
            String profilePhotoLink = resultData["profile_photo_link"];
            String profileText = resultData["profile_text"];

            return SafeArea(
                top: false,
                bottom: false,
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          toolbarHeight: 0,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          brightness: Brightness.light,
                        ),
                        body: SingleChildScrollView(
                            child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                              child: Column(children: [
                                Container(
                                  width: ScreenUtil().screenWidth,
                                  height: ScreenUtil().setSp(44),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
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
                                      ),
                                      Text(
                                        "프로필 수정",
                                        style: TextStyle(
                                            fontFamily: "NotoSansCJKkrBold",
                                            fontSize: ScreenUtil()
                                                .setSp(appbar_title_size),
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing)),
                                      ),
                                      Mutation(
                                          options: MutationOptions(
                                              document:
                                                  gql(Mutations.changeProfile),
                                              update: (GraphQLDataProxy proxy,
                                                  QueryResult result) {},
                                              onCompleted:
                                                  (dynamic resultData) {
                                                if (resultData["change_profile"]
                                                    ["result"]) {
                                                  widget.callbackRefetch();
                                                  Get.back();
                                                }
                                              }),
                                          builder: (RunMutation runMutation,
                                              QueryResult queryResult) {
                                            return InkWell(
                                              onTap: () async {
                                                int customerId = int.parse(
                                                    await storage.read(
                                                        key: "customerId"));
                                                //
                                                if (pickedImage != null) {
                                                  File file =
                                                      File(pickedImage.path);
                                                  uploadAWS([file])
                                                      .then((awsLink) {
                                                    if (awsLink[0] != null) {
                                                      runMutation({
                                                        "nick_name":
                                                            newNickname == null
                                                                ? nickname
                                                                : newNickname,
                                                        "profile_photo_link":
                                                            "${awsLink[0]}",
                                                        "profile_text":
                                                            newIntroduction ==
                                                                    null
                                                                ? profileText
                                                                : newIntroduction,
                                                        "customer_id":
                                                            customerId,
                                                      });
                                                    } else {
                                                      runMutation({
                                                        "nick_name":
                                                            profilePhotoLink ==
                                                                    null
                                                                ? ""
                                                                : profilePhotoLink,
                                                        "profile_photo_link":
                                                            "",
                                                        "profile_text":
                                                            newIntroduction ==
                                                                    null
                                                                ? profileText
                                                                : newIntroduction,
                                                        "customer_id":
                                                            customerId,
                                                      });
                                                    }
                                                  });
                                                } else if (profilePhotoLink !=
                                                    null) {
                                                  runMutation({
                                                    "profile_photo_link":
                                                        profilePhotoLink,
                                                    "nick_name":
                                                        newNickname == null
                                                            ? nickname
                                                            : newNickname,
                                                    "profile_text":
                                                        newIntroduction == null
                                                            ? profileText
                                                            : newIntroduction,
                                                    "customer_id": customerId,
                                                  });
                                                } else {
                                                  runMutation({
                                                    "profile_photo_link": null,
                                                    "nick_name":
                                                        newNickname == null
                                                            ? nickname
                                                            : newNickname,
                                                    "profile_text":
                                                        newIntroduction == null
                                                            ? profileText
                                                            : newIntroduction,
                                                    "customer_id": customerId,
                                                  });
                                                }
                                              },
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "완료",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "NotoSansCJKkrBold",
                                                    fontSize: ScreenUtil()
                                                        .setSp(
                                                            appbar_title_size),
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(letter_spacing),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setSp(10)),
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
                                          permissionPopup(context,
                                              "사진 접근이 허용되어있지 않있습니다.\n설정에서 허용 후 이용 가능합니다.");
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        profilePhotoLink == null ||
                                                profilePhotoLink == "null"
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil()
                                                            .setSp(100)),
                                                child: pickedImage == null
                                                    ? Image.asset(
                                                        "assets/images/profileSettings/thumbnail_default.png",
                                                        width: ScreenUtil()
                                                            .setSp(101),
                                                        height: ScreenUtil()
                                                            .setSp(101))
                                                    : Image.file(
                                                        File(pickedImage.path),
                                                        width: ScreenUtil()
                                                            .setSp(101),
                                                        height: ScreenUtil()
                                                            .setSp(101),
                                                        fit: BoxFit.cover,
                                                      ))
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil()
                                                            .setSp(100)),
                                                child: pickedImage == null
                                                    ?
                                                    // Image.network(
                                                    //     profilePhotoLink,
                                                    //     width: ScreenUtil()
                                                    //         .setSp(101),
                                                    //     height: ScreenUtil()
                                                    //         .setSp(101),
                                                    //     fit: BoxFit.cover,
                                                    //   )
                                                    CachedNetworkImage(
                                                        imageUrl:
                                                            profilePhotoLink,
                                                        width: ScreenUtil()
                                                            .setSp(101),
                                                        height: ScreenUtil()
                                                            .setSp(101),
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      )
                                                    : Image.file(
                                                        File(pickedImage.path),
                                                        width: ScreenUtil()
                                                            .setSp(101),
                                                        height: ScreenUtil()
                                                            .setSp(101),
                                                        fit: BoxFit.cover,
                                                      )),
                                        SizedBox(height: ScreenUtil().setSp(3)),
                                        Text(
                                          "변경하기",
                                          style: TextStyle(
                                            fontFamily: "NotoSansCJKkrRegular",
                                            fontSize: ScreenUtil().setSp(12),
                                            color: app_font_grey,
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing_x_small),
                                          ),
                                        )
                                      ],
                                    )),
                              ]),
                            ),
                            Container(
                              color: app_grey_light,
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(10),
                            ),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            InkWell(
                              onTap: () {
                                Get.to(() => ProfileEditNicknameScreen(
                                      nickname: nickname,
                                      setNickname: (nickname) =>
                                          setNewNickname(nickname),
                                      profilePhoto: profilePhotoLink,
                                    ));
                              },
                              child: Container(
                                  width: ScreenUtil().screenWidth,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setSp(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "프로필 별명",
                                        style: TextStyle(
                                            fontFamily: "NotoSansCJKkrBold",
                                            fontSize: ScreenUtil().setSp(16),
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing)),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Text(
                                        newNickname == null
                                            ? nickname
                                            : newNickname,
                                        style: TextStyle(
                                            fontFamily: "NotoSansCJKkrRegular",
                                            fontSize: ScreenUtil().setSp(16),
                                            color: app_font_grey,
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing)),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Container(
                                        color: app_grey_light,
                                        width: ScreenUtil().screenWidth,
                                        height: ScreenUtil().setSp(2),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(height: ScreenUtil().setSp(30)),
                            InkWell(
                              onTap: () {
                                Get.to(() => ProfileEditIntroductionScreen(
                                    introduction: profileText,
                                    setIntroduction: (introduction) =>
                                        setNewIntroduction(introduction)));
                              },
                              child: Container(
                                  width: ScreenUtil().screenWidth,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setSp(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "프로필 소개",
                                        style: TextStyle(
                                            fontFamily: "NotoSansCJKkrBold",
                                            fontSize: ScreenUtil().setSp(16),
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing)),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Text(
                                        newIntroduction == null
                                            ? profileText == null
                                                ? ""
                                                : profileText
                                            : newIntroduction,
                                        style: TextStyle(
                                            fontFamily: "NotoSansCJKkrRegular",
                                            fontSize: ScreenUtil().setSp(16),
                                            color: app_font_grey,
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing)),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Container(
                                        color: app_grey_light,
                                        width: ScreenUtil().screenWidth,
                                        height: ScreenUtil().setSp(2),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        )))));
          } else {
            return Container();
          }
        });
  }
}
