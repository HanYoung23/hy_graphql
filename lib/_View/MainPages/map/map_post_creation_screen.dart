import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsgotrip/_Controller/permission_controller.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_creation_detail_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/functions/photo_coord.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/map_post_creation_bottom_sheet.dart';

class MapPostCreationScreen extends StatefulWidget {
  const MapPostCreationScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapPostCreationScreenState createState() => _MapPostCreationScreenState();
}

class _MapPostCreationScreenState extends State<MapPostCreationScreen> {
  final contentTextController = TextEditingController();
  final tagTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  int category = 0;
  String selectedCategory = "";
  List<File> imageList = [];
  List<LatLng> photoLatLng = [];
  bool isAllFilled = false;

  categoryCallback(String categoryName) {
    int categoryId;
    switch (categoryName) {
      case "바닷가":
        categoryId = 1;
        break;
      case "액티비티":
        categoryId = 2;
        break;
      case "맛집":
        categoryId = 3;
        break;
      case "숙소":
        categoryId = 4;
        break;
      default:
    }
    setState(() {
      category = categoryId;
      selectedCategory = categoryName;
    });
    checkIsAllFilled();
  }

  checkIsAllFilled() {
    if (selectedCategory != "" &&
        imageList.length != 0 &&
        contentTextController.text.length != 0 &&
        tagTextController.text.length > 1) {
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
      "categoryId": category,
      "selectedCategory": selectedCategory,
      "mainText": contentTextController.text,
      "tags": tagTextController.text,
    };
    String postSaveData = jsonEncode(paramMap);

    storeUserData("postSaveData", postSaveData).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '임시저장 되었습니다.',
            style: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              fontSize: ScreenUtil().setSp(14),
              letterSpacing: letter_spacing_small,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(21)),
          ),
          backgroundColor: Color(0xffb5b5b5),
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setSp(90),
              left: ScreenUtil().setSp(80),
              right: ScreenUtil().setSp(80))));
    });
  }

  callSaveDataCallback() {
    seeValue("postSaveData").then((value) {
      Map paramMap = jsonDecode(value);
      setState(() {
        category = paramMap["categoryId"];
        selectedCategory = paramMap["selectedCategory"];
      });
      contentTextController.text = paramMap["mainText"];
      tagTextController.text = paramMap["tags"];
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '이전 게시물을 불러옵니다.',
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(14),
            letterSpacing: letter_spacing_small,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(21)),
        ),
        backgroundColor: Color(0xffb5b5b5),
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setSp(90),
            left: ScreenUtil().setSp(80),
            right: ScreenUtil().setSp(80))));
    deleteUserData("postSaveData");
  }

  @override
  void initState() {
    super.initState();
    seeValue("postSaveData").then((value) {
      if (value != null) {
        callSaveDataPopup(context, () => callSaveDataCallback());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          checkIsAllFilled();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            backgroundColor: Colors.black,
            brightness: Brightness.dark,
          ),
          body: Container(
            height: ScreenUtil().screenHeight -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
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
                      Text(
                        "게시물 작성",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing: letter_spacing,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            savePostPopup(context, () => saveDataCallback());
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "임시저장",
                              style: TextStyle(
                                fontFamily: "NotoSansCJKkrBold",
                                letterSpacing: letter_spacing,
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
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => MapPostCreationBottomSheet(
                            callback: (category) =>
                                categoryCallback(category)));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtil().setSp(8)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                        selectedCategory == ""
                            ? "카테고리 설정"
                            : "$selectedCategory",
                        style: TextStyle(
                            fontFamily: "NotoSansCJKkrRegular",
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing: letter_spacing_small,
                            color: selectedCategory == ""
                                ? app_font_grey
                                : Colors.black)),
                  ),
                ),
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
                          letterSpacing: letter_spacing_small,
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
                                letterSpacing: letter_spacing_small,
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
                                  letterSpacing: letter_spacing_small,
                                ))))
                  ],
                ),
                SizedBox(height: ScreenUtil().setSp(4)),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                SizedBox(height: ScreenUtil().setSp(20)),
                Wrap(
                  children: [
                    Container(
                        child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: tagTextController,
                            minLines: 1,
                            maxLines: 1,
                            onTap: () {
                              if (tagTextController.text.length < 1) {
                                tagTextController.text = "#";
                                tagTextController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: tagTextController.text.length));
                              }
                            },
                            onChanged: (String value) {
                              checkIsAllFilled();
                              if (value.length != 0) {
                                String clickedVal =
                                    "${value[value.length - 1]}";
                                if (value[0] != "#") {
                                  tagTextController.text = "#$value";
                                }
                                if (clickedVal == " ") {
                                  String validText = value.replaceAll(" ", "#");
                                  String validTextTwo =
                                      validText.replaceAll("##", "#");
                                  tagTextController.text = validTextTwo;
                                }
                                tagTextController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: tagTextController.text.length));
                              }
                            },
                            style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing: letter_spacing_small,
                                color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "태그를 입력할 수 있습니다 (ex. 바다)",
                                hintStyle: TextStyle(
                                  color: app_font_grey,
                                  fontFamily: "NotoSansCJKkrRegular",
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing: letter_spacing_small,
                                ))))
                  ],
                ),
                Container(
                    color: app_grey,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().setSp(3)),
                Spacer(),
                InkWell(
                    onTap: () {
                      if (isAllFilled) {
                        Map paramMap = {
                          "categoryId": category,
                          "imageLink": imageList,
                          "imageLatLngList": photoLatLng,
                          "mainText": contentTextController.text,
                          "tags": tagTextController.text,
                        };
                        Get.to(() => MapPostCreationDetailScreen(
                              paramMap: paramMap,
                            ));
                      }
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: isAllFilled ? app_blue : app_blue_light_button,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setSp(10))),
                      child: Text(
                        "다음",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white,
                          letterSpacing: letter_spacing_small,
                        ),
                      ),
                    )),
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
                  image: FileImage(imageList[index]), fit: BoxFit.fill),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              imageList.removeAt(index);
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
                .pickMultiImage(maxWidth: 1000, maxHeight: 1000)
                .then((images) {
              if (images != null) {
                List<File> newImageList = imageList;
                List<LatLng> newLatLngList = photoLatLng;
                images.forEach((xfile) async {
                  File file = File(xfile.path);
                  newImageList.add(file);
                  pullPhotoCoordnate(file).then((latlng) {
                    if (latlng != null) {
                      newLatLngList.add(latlng);
                    }
                  });
                });
                if (newImageList.length > 10) {
                  newImageList.removeRange(10, newImageList.length);
                }
                setState(() {
                  imageList = newImageList;
                  photoLatLng = newLatLngList;
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
