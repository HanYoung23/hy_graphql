import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';

class MapPostReviewScreen extends StatefulWidget {
  const MapPostReviewScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapPostReviewScreenState createState() => _MapPostReviewScreenState();
}

class _MapPostReviewScreenState extends State<MapPostReviewScreen> {
  double firstQRating;

  double secondQRating;

  double thirdQRating;

  double fourthQRating;

  @override
  Widget build(BuildContext context) {
    Mutation(
        options: MutationOptions(document: gql(Mutations.createContents)),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return reviewScreen();
        });
    return reviewScreen();
  }

  SafeArea reviewScreen() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.all(ScreenUtil().setSp(20)),
          child: Column(
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
                          fontSize: ScreenUtil().setSp(appbar_title_size),
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
                "${Get.arguments}",
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
              Image.asset(
                "assets/images/upload_button.png",
                width: ScreenUtil().setWidth(335),
                height: ScreenUtil().setHeight(50),
              )
            ],
          ),
        ),
      ),
    );
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
              firstQRating = rating;
            });
          case "second":
            return setState(() {
              secondQRating = rating;
            });
          case "third":
            return setState(() {
              thirdQRating = rating;
            });
          case "fourth":
            return setState(() {
              fourthQRating = rating;
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
