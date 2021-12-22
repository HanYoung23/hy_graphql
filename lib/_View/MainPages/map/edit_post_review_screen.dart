import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_Controller/google_map_whole_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/aws_upload.dart';
import 'package:letsgotrip/homepage.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';

class EditPostReviewScreen extends StatefulWidget {
  final Map paramMap;
  final Map mapData;
  const EditPostReviewScreen(
      {Key key, @required this.paramMap, @required this.mapData})
      : super(key: key);

  @override
  _EditPostReviewScreenState createState() => _EditPostReviewScreenState();
}

class _EditPostReviewScreenState extends State<EditPostReviewScreen> {
  GoogleMapWholeController gmWholeImages = Get.find();

  int firstQRating = 3;

  int secondQRating = 3;

  int thirdQRating = 3;

  int fourthQRating = 3;

  bool isUploading = false;

  setPreviousData() {
    setState(() {
      firstQRating = widget.mapData["starRatingList"][0];
      secondQRating = widget.mapData["starRatingList"][1];
      thirdQRating = widget.mapData["starRatingList"][2];
      fourthQRating = widget.mapData["starRatingList"][3];
    });
  }

  @override
  void initState() {
    print("🚨 mapData : ${widget.mapData}");
    setPreviousData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    firstQRating = widget.mapData["starRatingList"][0];
    secondQRating = widget.mapData["starRatingList"][1];
    thirdQRating = widget.mapData["starRatingList"][2];
    fourthQRating = widget.mapData["starRatingList"][3];
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.changeContents),
            update: (GraphQLDataProxy proxy, QueryResult result) {},
            onCompleted: (dynamic resultData) {
              // print("🚨 edit post mutation result : $resultData");
              if (resultData["change_contents"]["result"]) {
                CameraPosition cameraPosition = CameraPosition(
                    bearing: 0.0,
                    target: LatLng(
                        double.parse("${widget.paramMap["latitude"]}"),
                        double.parse("${widget.paramMap["longitude"]}")),
                    tilt: 0.0,
                    zoom: 15);
                gmWholeImages.setCameraPosition(cameraPosition);
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
                              await editUploadAWS(widget.paramMap["imageLink"])
                                  .then((awsLinks) {
                                for (String photoUrl in awsLinks) {
                                  awsUrlList.add(photoUrl);
                                }
                              });
                              String thumbnail = awsUrlList[0];
                              awsUrlList.removeAt(0);
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
                                "type": "edit",
                                "contents_id": widget.mapData["contentsId"],
                                "customer_id": int.parse(customerId),
                                "category_id": widget.paramMap["categoryId"],
                                "contents_title":
                                    "${widget.paramMap["contentsTitle"]}",
                                "location_link":
                                    widget.paramMap["locationLink"],
                                "thumbnail": thumbnail,
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
      initialRating: title == "first"
          ? firstQRating.toDouble()
          : title == "second"
              ? secondQRating.toDouble()
              : title == "third"
                  ? thirdQRating.toDouble()
                  : fourthQRating.toDouble(),
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