import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/map/map_post_done_screen.dart';
import 'package:letsgotrip/_View/MainPages/map/map_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class MapPostReviewScreen extends StatefulWidget {
  final Map paramMap;
  const MapPostReviewScreen({Key key, @required this.paramMap})
      : super(key: key);

  @override
  _MapPostReviewScreenState createState() => _MapPostReviewScreenState();
}

class _MapPostReviewScreenState extends State<MapPostReviewScreen> {
  int firstQRating = 3;

  int secondQRating = 3;

  int thirdQRating = 3;

  int fourthQRating = 3;

  bool isUploading = false;

  uploadAws() {}

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.createContents),
            update: (GraphQLDataProxy proxy, QueryResult result) {
              if (result.hasException) {
                // print(['optimistic', result.exception.toString()]);
              } else {
                // Do something
              }
            },
            onCompleted: (dynamic resultData) {
              print("🚨 resultData : $resultData");
              Get.offAll(() => HomePage());
              // Get.offAll(() => MapPostDoneScreen());
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                  margin: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child:
                      // !isUploading
                      //     ?
                      Column(
                    children: [
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
                              "장소 평가",
                              style: TextStyle(
                                  fontSize:
                                      ScreenUtil().setSp(appbar_title_size),
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Icon(
                                Icons.arrow_back,
                                size: ScreenUtil().setSp(arrow_back_size),
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25)),
                      Image.asset(
                        "assets/images/post_logo.png",
                        width: ScreenUtil().setSp(24),
                        height: ScreenUtil().setSp(31),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      Text(
                        "${widget.paramMap["contentsTitle"]}",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      Text(
                        "해당 장소에 대해 간략하게 알려주세요",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: app_font_grey,
                        ),
                      ),
                      // SizedBox(height: ScreenUtil().setHeight(12)),
                      Spacer(),
                      questionText("방문객이 많이 있었나요?"),
                      ratingbar("first"),
                      questionText("주차가 편리한가요?"),
                      ratingbar("second"),
                      questionText("아이들과 동반하기 좋았나요?"),
                      ratingbar("third"),
                      questionText("이곳을 다른 사람에게 추천하나요?"),
                      ratingbar("fourth"),
                      Spacer(),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isUploading = true;
                          });
                          List awsUrlList = [];
                          await uploadAWS(widget.paramMap["imageLink"])
                              .then((awsLinks) {
                            for (String photoUrl in awsLinks) {
                              String shortUrl = photoUrl.substring(
                                  0, photoUrl.indexOf("?X-Amz"));
                              awsUrlList.add(shortUrl);
                            }
                          });
                          String imageLink = awsUrlList.join(",");
                          String tag = widget.paramMap["tags"];
                          String tags =
                              tag.replaceAll(RegExp(r'#'), ",").substring(1);

                          runMutation({
                            "customer_id": 1,
                            "category_id": widget.paramMap["categoryId"],
                            "contents_title":
                                "${widget.paramMap["contentsTitle"]}",
                            "location_link": widget.paramMap["locationLink"],
                            "image_link": imageLink,
                            "main_text": widget.paramMap["mainText"],
                            "tags": tags,
                            "star_rating1": firstQRating,
                            "star_rating2": secondQRating,
                            "star_rating3": thirdQRating,
                            "star_rating4": fourthQRating,
                            "latitude": "${widget.paramMap["latitude"]}",
                            "longitude": "${widget.paramMap["longitude"]}",
                          });
                        },
                        child: Image.asset(
                          "assets/images/upload_button.png",
                          width: ScreenUtil().setWidth(335),
                          height: ScreenUtil().setHeight(50),
                        ),
                      )
                    ],
                  )
                  // : Container(
                  //     width: ScreenUtil().screenWidth,
                  //     height: ScreenUtil().screenHeight,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         CircularProgressIndicator(),
                  //         SizedBox(height: ScreenUtil().setSp(40)),
                  //         Text("업로드 중 ...",
                  //             style: TextStyle(
                  //                 fontSize: ScreenUtil().setSp(16)))
                  //       ],
                  //     ))
                  ),
            ),
          );
        });
  }

  RatingBar ratingbar(String title) {
    return RatingBar(
      itemSize: ScreenUtil().setSp(28),
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Image(image: AssetImage("assets/images/rating_icon.png")),
        half: Image(image: AssetImage("assets/images/rating_icon.png")),
        empty: Image(image: AssetImage("assets/images/rating_icon_grey.png")),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
      onRatingUpdate: (rating) {
        switch (title) {
          case "first":
            return setState(() {
              firstQRating = rating.toInt();
            });
          case "second":
            return setState(() {
              secondQRating = rating.toInt();
            });
          case "third":
            return setState(() {
              thirdQRating = rating.toInt();
            });
          case "fourth":
            return setState(() {
              fourthQRating = rating.toInt();
            });
            break;
          default:
        }
      },
    );
  }

  Container questionText(String title) {
    return Container(
      margin: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(12), top: ScreenUtil().setHeight(12)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(16),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// print("🚨 1 ${widget.paramMap["contentsTitle"]}");
// print("🚨 2 ${widget.paramMap["locationLink"]}");
// print("🚨 3 $imageLink");
// print("🚨 4 ${widget.paramMap["mainText"]}");
// print("🚨 5 $tags");
// print("🚨 6 ${widget.paramMap["categoryId"]}");
// print("🚨 7 $firstQRating");
// print("🚨 8 $secondQRating");
// print("🚨 9 $thirdQRating");
// print("🚨 10 $fourthQRating");
// print("🚨 11 ${widget.paramMap["latitude"]}");
// print("🚨 12 ${widget.paramMap["longitude"]}");