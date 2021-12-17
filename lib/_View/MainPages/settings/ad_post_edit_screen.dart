import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_list_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/postal.dart';

class AdPostEditScreen extends StatefulWidget {
  final Map paramData;
  const AdPostEditScreen({
    Key key,
    @required this.paramData,
  }) : super(key: key);

  @override
  _AdPostEditScreenState createState() => _AdPostEditScreenState();
}

class _AdPostEditScreenState extends State<AdPostEditScreen> {
  final titleTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final contentTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  List<dynamic> imageList = [];
  // List<LatLng> photoLatLng = [];
  bool isAllFilled = false;
  String address = "";
  double lat;
  double lng;

  checkIsAllFilled() {
    if (imageList.length != 0 &&
        titleTextController.text.length != 0 &&
        contentTextController.text.length != 0 &&
        address != "") {
      setState(() {
        isAllFilled = true;
      });
    } else {
      setState(() {
        isAllFilled = false;
      });
    }
  }

  saveDataCallback() {
    Map paramMap = {
      "titleText": titleTextController.text,
      "phoneText": phoneTextController.text,
      "contentText": contentTextController.text,
      "addressText": address,
      "lat": lat,
      "lng": lng,
    };
    String adSaveData = jsonEncode(paramMap);

    storeUserData("adSaveData", adSaveData).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '임시저장 되었습니다.',
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
    });
  }

  callSaveDataCallback() {
    seeValue("adSaveData").then((value) {
      Map paramMap = jsonDecode(value);

      titleTextController.text = paramMap["titleText"];
      phoneTextController.text = paramMap["phoneText"];
      contentTextController.text = paramMap["contentText"];
      setState(() {
        address = paramMap["titleText"];
        lat = paramMap["lat"];
        lng = paramMap["lng"];
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '이전 게시물을 불러옵니다.',
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
    deleteUserData("adSaveData");
  }

  callBackAddress(Map callbackAddress) async {
    setState(() {
      address = callbackAddress["address"];
      lat = callbackAddress["lat"];
      lng = callbackAddress["lng"];
    });
  }

  setPreData() {
    titleTextController.text = widget.paramData["title"];
    phoneTextController.text = widget.paramData["phone"];
    contentTextController.text = widget.paramData["main_text"];
    setState(() {
      address = widget.paramData["location_link"];
      imageList = "${widget.paramData["image_link"]}".split(",");
      lat = double.parse("${widget.paramData["latitude"]}");
      lng = double.parse("${widget.paramData["longitude"]}");
      isAllFilled = true;
    });
  }

  @override
  void dispose() {
    contentTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    seeValue("adSaveData").then((value) {
      if (value != null) {
        callSaveDataPopup(context, () => callSaveDataCallback());
      }
    });
    setPreData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        checkIsAllFilled();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            // height: ScreenUtil().screenHeight -
            //     MediaQuery.of(context).padding.top -
            //     MediaQuery.of(context).padding.bottom,
            padding: EdgeInsets.all(ScreenUtil().setSp(20)),
            child: Column(
              children: [
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
                      InkWell(
                        // onTap: () {
                        //   Get.to(() => AdPostDoneScreen());
                        // },
                        child: Text(
                          "홍보 게시물 작성",
                          style: TextStyle(
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(appbar_title_size),
                            letterSpacing: ScreenUtil().setSp(letter_spacing),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            saveAdPopup(context, () => saveDataCallback());
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "임시저장",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                                fontSize: ScreenUtil().setSp(appbar_title_size),
                                color: app_font_grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setSp(20)),
                Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setSp(40),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: titleTextController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '제목을 입력하세요',
                          hintStyle: TextStyle(color: app_font_grey)),
                      style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        fontSize: ScreenUtil().setSp(14),
                        letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                        decorationColor: Colors.white,
                      ),
                      onChanged: (value) {
                        checkIsAllFilled();
                      }),
                ),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setSp(10)),
                InkWell(
                  onTap: () {
                    Get.to(() => PostalWeb(
                          callback: (address) => callBackAddress(address),
                        ));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setSp(1),
                            right: ScreenUtil().setSp(8)),
                        child: Image.asset(
                          "assets/images/location_icon.png",
                          width: ScreenUtil().setSp(14),
                          height: ScreenUtil().setSp(14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: ScreenUtil().setSp(40),
                          child: Text(
                            address == "" ? '주소를 남겨보세요(필수사항)' : address,
                            style: TextStyle(
                              color:
                                  address == "" ? app_font_grey : Colors.black,
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setSp(10)),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setSp(1),
                          right: ScreenUtil().setSp(8)),
                      child: Image.asset(
                        "assets/images/phone_icon.png",
                        width: ScreenUtil().setSp(14),
                        height: ScreenUtil().setSp(14),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: ScreenUtil().setSp(40),
                        child: TextFormField(
                          autocorrect: false,
                          controller: phoneTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '전화번호를 입력하세요(선택사항)',
                            hintStyle: TextStyle(color: app_font_grey),
                          ),
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_small)),
                          onChanged: (value) {
                            // if (value.isNumericOnly) {
                            //   if (phoneTextController.text.length > 11) {
                            //     phoneTextController.text =
                            //         phoneTextController.text.substring(0, 11);
                            //     FocusScope.of(context).unfocus();
                            //   }
                            // } else {
                            //   phoneTextController.text =
                            //       value.replaceAll(".", "").replaceAll("-", "");
                            // }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: ScreenUtil().setSp(10)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setSp(18)),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("이미지를 첨부해보세요\n(${imageList.length}/10)",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small),
                          color: app_font_grey)),
                ),
                SizedBox(height: ScreenUtil().setSp(4)),
                imageList.length > 0
                    ? Container(
                        alignment: Alignment.centerLeft,
                        height: ScreenUtil().setSp(74),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: imageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < 10) {
                              if (index == 0) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    photoUploadButton(),
                                    photoPreview(index)
                                  ],
                                );
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  photoPreview(index),
                                ],
                              );
                            } else {
                              return null;
                            }
                          },
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          photoUploadButton(),
                          Container(
                            width: ScreenUtil().setSp(58),
                            height: ScreenUtil().setSp(58),
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setSp(10)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(10)),
                                color: Color.fromRGBO(241, 241, 245, 1)),
                          )
                        ],
                      ),
                SizedBox(height: ScreenUtil().setSp(8)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setSp(4)),
                Wrap(
                  children: [
                    Container(
                        height: ScreenUtil().setSp(180),
                        child: TextField(
                            controller: contentTextController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: null,
                            onChanged: (_) {
                              checkIsAllFilled();
                            },
                            style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
                                color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    "내용을 입력해주세요.\n(정책을 위반한 글은 무통보 삭제 처리될 수 있습니다.)",
                                hintMaxLines: 3,
                                hintStyle: TextStyle(
                                  color: app_font_grey,
                                  fontFamily: "NotoSansCJKkrRegular",
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing_small),
                                  decorationColor: Colors.white,
                                ))))
                  ],
                ),
                SizedBox(height: ScreenUtil().setSp(4)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setSp(110)),
                Mutation(
                    options: MutationOptions(
                        document: gql(Mutations.changePromotions),
                        update: (GraphQLDataProxy proxy, QueryResult result) {},
                        onCompleted: (dynamic resultData) {
                          print("🚨 resultData : $resultData");
                          if (resultData["change_promotions"]["result"]) {
                            seeValue("customerId").then((customerId) {
                              Get.to(() => Query(
                                  options: QueryOptions(
                                    document: gql(Queries.myPromotionsList),
                                    variables: {
                                      "customer_id": int.parse(customerId)
                                    },
                                  ),
                                  builder: (result, {refetch, fetchMore}) {
                                    if (!result.isLoading &&
                                        result.data != null) {
                                      print(
                                          "🚨 myPromotionsList result : $result");
                                      List resultData =
                                          result.data["my_promotions_list"];
                                      return AdPostListScreen(
                                          paramData: resultData);
                                    } else {
                                      return Container();
                                    }
                                  }));
                            });
                          }
                        }),
                    builder:
                        (RunMutation runMutation, QueryResult queryResult) {
                      return InkWell(
                          onTap: () {
                            if (isAllFilled) {
                              editUploadAWS(imageList).then((imageUrlList) {
                                String uploadImageList = imageUrlList.join(",");
                                runMutation({
                                  "promotions_id": int.parse(
                                      "${widget.paramData["promotions_id"]}"),
                                  "title": titleTextController.text,
                                  "image_link": uploadImageList,
                                  "main_text": contentTextController.text,
                                  "location_link": address,
                                  "phone": phoneTextController.text,
                                  "latitude": "$lat",
                                  "longitude": "$lng",
                                });
                              });
                            }
                          },
                          child: Container(
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().setSp(50),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: isAllFilled
                                    ? app_blue
                                    : app_blue_light_button,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(10))),
                            child: Text(
                              "수정완료",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                fontSize: ScreenUtil().setSp(16),
                                color: Colors.white,
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_small),
                              ),
                            ),
                          ));
                    }),
                SizedBox(height: ScreenUtil().setSp(14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack photoPreview(int index) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: ScreenUtil().setSp(58),
            height: ScreenUtil().setSp(58),
            margin: EdgeInsets.only(
                top: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
            decoration: BoxDecoration(
              color: app_grey,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
              image: DecorationImage(
                  image: imageList[index].toString().substring(0, 4) == "http"
                      ? NetworkImage(imageList[index])
                      : FileImage(File(imageList[index])),
                  fit: BoxFit.fill),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              imageList.removeAt(index);
              // photoLatLng.removeAt(index);
              checkIsAllFilled();
              setState(() {});
            },
            child: Container(
              width: ScreenUtil().setSp(20),
              height: ScreenUtil().setSp(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(100)),
                  color: app_grey),
              child: Icon(Icons.close,
                  size: ScreenUtil().setSp(16), color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  InkWell photoUploadButton() {
    return InkWell(
      onTap: () {
        checkGalleryPermission().then((permission) async {
          if (permission) {
            picker
                .pickMultiImage(
                    maxWidth: ScreenUtil().setSp(1000),
                    maxHeight: ScreenUtil().setSp(1000))
                .then((images) {
              if (images != null) {
                List newImageList = imageList;
                images.forEach((xfile) async {
                  newImageList.add("${xfile.path}");
                });
                if (newImageList.length > 10) {
                  newImageList.removeRange(10, newImageList.length);
                }
                setState(() {
                  imageList = newImageList;
                });
                checkIsAllFilled();
              }
            });
          } else {
            permissionPopup(
                context, "사진 접근이 허용되어있지 않습니다.\n설정에서 허용 후 이용 가능합니다.");
          }
        });
      },
      child: Visibility(
        visible: imageList.length < 10 ? true : false,
        child: Container(
          width: ScreenUtil().setSp(58),
          height: ScreenUtil().setSp(58),
          margin: EdgeInsets.only(right: ScreenUtil().setSp(10)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
              color: Color.fromRGBO(241, 241, 245, 1)),
          child: Icon(
            Icons.add,
            size: ScreenUtil().setSp(40),
            color: Color.fromRGBO(188, 192, 193, 1),
          ),
        ),
      ),
    );
  }
}
