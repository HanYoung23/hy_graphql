import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class MapPostReviewScreen extends StatefulWidget {
  final Map paramMap;
  const MapPostReviewScreen({Key key, @required this.paramMap})
      : super(key: key);

  @override
  _MapPostReviewScreenState createState() => _MapPostReviewScreenState();
}

class _MapPostReviewScreenState extends State<MapPostReviewScreen> {
  GoogleMapWholeController gmWholeController =
      Get.put(GoogleMapWholeController());
  GoogleMapWholeController gmUpdate = Get.find();

  int firstQRating = 3;

  int secondQRating = 3;

  int thirdQRating = 3;

  int fourthQRating = 3;

  bool isUploading = false;

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
              // print("🚨 resultData : $resultData");

              if (resultData["createContents"]["result"]) {
                Get.offAll(() => HomePage());
              } else {
                Get.snackbar("error", "${resultData["createContents"]["msg"]}");
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
            ),
            body: Container(
                margin: EdgeInsets.all(ScreenUtil().setSp(20)),
                child: !isUploading
                    ? Column(
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
                                      child: Image.asset(
                                          "assets/images/arrow_back.png",
                                          width: ScreenUtil()
                                              .setSp(arrow_back_size),
                                          height: ScreenUtil()
                                              .setSp(arrow_back_size)),
                                    ),
                                  ),
                                ),
                                Text(
                                  "장소 평가",
                                  style: TextStyle(
                                    fontFamily: "NotoSansCJKkrBold",
                                    letterSpacing:
                                        ScreenUtil().setSp(letter_spacing),
                                    fontSize:
                                        ScreenUtil().setSp(appbar_title_size),
                                  ),
                                ),
                                Expanded(
                                  child: Image.asset(
                                      "assets/images/arrow_back.png",
                                      color: Colors.transparent,
                                      width:
                                          ScreenUtil().setSp(arrow_back_size),
                                      height:
                                          ScreenUtil().setSp(arrow_back_size)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setSp(25)),
                          Image.asset(
                            "assets/images/post_logo.png",
                            width: ScreenUtil().setSp(24),
                            height: ScreenUtil().setSp(31),
                          ),
                          SizedBox(height: ScreenUtil().setSp(12)),
                          Text(
                            "${widget.paramMap["contentsTitle"]}",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(20),
                              letterSpacing: ScreenUtil().setSp(-0.5),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setSp(12)),
                          Text(
                            "해당 장소에 대해 간략하게 알려주세요",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: ScreenUtil().setSp(letter_spacing),
                              color: app_font_grey,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                          // SizedBox(height: ScreenUtil().setSp(12)),
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
                                  awsUrlList.add(photoUrl);
                                }
                              });
                              String imageLink = awsUrlList.join(",");
                              String tag = "${widget.paramMap["tags"]}";
                              String tags = "";
                              if (tag != "") {
                                tags = tag
                                    .replaceAll(RegExp(r'#'), ",")
                                    .substring(1);
                              }
                              String customerId =
                                  await storage.read(key: "customerId");

                              runMutation({
                                "customer_id": int.parse(customerId),
                                "category_id": widget.paramMap["categoryId"],
                                "contents_title":
                                    "${widget.paramMap["contentsTitle"]}",
                                "location_link":
                                    widget.paramMap["locationLink"],
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
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(50),
                              decoration: BoxDecoration(
                                  color: app_blue,
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(10))),
                              alignment: Alignment.center,
                              child: Text(
                                "업로드",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "NotoSansCJKkrBold",
                                  fontSize: ScreenUtil().setSp(16),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().screenHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: ScreenUtil().setSp(40)),
                            Text("업로드 중 ...",
                                style: TextStyle(
                                  fontFamily: "NotoSansCJKkrRegular",
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing_small),
                                  fontSize: ScreenUtil().setSp(16),
                                  color: app_font_grey,
                                ))
                          ],
                        ))),
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
      itemPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(8)),
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
          bottom: ScreenUtil().setSp(12), top: ScreenUtil().setSp(12)),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "NotoSansCJKkrBold",
          fontSize: ScreenUtil().setSp(14),
          letterSpacing: ScreenUtil().setSp(letter_spacing_small),
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