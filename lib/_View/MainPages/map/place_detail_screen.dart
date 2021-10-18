import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PlaceDetailScreen extends StatefulWidget {
  final int contentsId;
  const PlaceDetailScreen({Key key, @required this.contentsId})
      : super(key: key);

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  bool isMoreText = false;
  int customerId;
  int bookmarksNum;
  bool isLike = false;
  int comentsNum;

  onPageChanged() {}

  @override
  void initState() {
    seeValue("customerId").then((value) {
      setState(() {
        customerId = int.parse(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return customerId != null
        ? Query(
            options: QueryOptions(
              document: gql(Queries.photoDetail),
              variables: {"contents_id": widget.contentsId},
            ),
            builder: (result, {refetch, fetchMore}) {
              if (!result.isLoading) {
                if (result.data["photo_detail"] != null) {
                  Map resultData = result.data["photo_detail"];
                  int contentsId = int.parse("${resultData["contents_id"]}");
                  int categoryId = int.parse("${resultData["category_id"]}");
                  String contentsTitle = resultData["contents_title"];
                  String nickName = resultData["nick_name"];
                  String mainText = resultData["main_text"];
                  String registDate = resultData["regist_date"];
                  String date =
                      registDate.replaceAll(RegExp(r'-'), ".").substring(0, 10);
                  String profilePhotoLink = resultData["profile_photo_link"];
                  int bookmarksCount = resultData["bookmarks_count"];
                  int likesCount = resultData["likes_count"];
                  int comentsCount = resultData["coments_count"];
                  List imageLink = ("${resultData["image_link"]}").split(",");
                  List<int> starRating = [
                    resultData["star_rating1"],
                    resultData["star_rating2"],
                    resultData["star_rating3"],
                    resultData["star_rating4"]
                  ];

                  return GestureDetector(
                    onTap: () {},
                    child: SafeArea(
                      child: Scaffold(
                        backgroundColor: Colors.black,
                        body: Container(
                            color: Colors.white,
                            padding:
                                EdgeInsets.only(top: ScreenUtil().setSp(20)),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(375),
                                    height: ScreenUtil().setHeight(44),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                size: ScreenUtil()
                                                    .setSp(arrow_back_size),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "게시물",
                                          style: TextStyle(
                                              fontSize: ScreenUtil()
                                                  .setSp(appbar_title_size),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Icon(
                                            Icons.arrow_back,
                                            size: ScreenUtil()
                                                .setSp(arrow_back_size),
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Positioned(
                                        child: CarouselSlider(
                                            items: imageLink.map((url) {
                                              return Image.network(url,
                                                  width:
                                                      ScreenUtil().screenWidth,
                                                  height:
                                                      ScreenUtil().screenWidth,
                                                  fit: BoxFit.cover);
                                            }).toList(),
                                            options: CarouselOptions(
                                              aspectRatio: 1,
                                              viewportFraction: 1,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              onPageChanged: onPageChanged(),
                                              scrollDirection: Axis.horizontal,
                                            )),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        child: Container(
                                          width: ScreenUtil().screenWidth,
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: ScreenUtil().setSp(48),
                                              padding: EdgeInsets.symmetric(
                                                vertical: ScreenUtil().setSp(4),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Center(
                                                child: Text(
                                                  "1/${imageLink.length}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(12)),
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(14)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenUtil().screenWidth,
                                          height: ScreenUtil().setSp(42),
                                          child: Row(
                                            children: [
                                              Container(
                                                  width: ScreenUtil().setSp(42),
                                                  height:
                                                      ScreenUtil().setSp(42),
                                                  decoration: profilePhotoLink !=
                                                          null
                                                      ? BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  profilePhotoLink)))
                                                      : BoxDecoration(
                                                          color: app_grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50))),
                                              SizedBox(
                                                  width:
                                                      ScreenUtil().setSp(15)),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      nickName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: ScreenUtil()
                                                              .setSp(14)),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                      date,
                                                      style: TextStyle(
                                                          color: app_font_grey,
                                                          fontSize: ScreenUtil()
                                                              .setSp(12)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      ScreenUtil().setSp(15)),
                                              Container(
                                                width: ScreenUtil().setSp(42),
                                                height: ScreenUtil().setSp(42),
                                                child: Icon(Icons.toggle_off),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setHeight(10)),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: app_grey,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setSp(14),
                                              vertical: ScreenUtil().setSp(6),
                                            ),
                                            child: Text(
                                              contentsTitle,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(12)),
                                            )),
                                        SizedBox(
                                            height: ScreenUtil().setHeight(10)),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width:
                                                      ScreenUtil().setSp(140),
                                                  height:
                                                      ScreenUtil().setSp(20),
                                                  child: ratings(
                                                      "방문객", starRating[0]),
                                                ),
                                                Container(
                                                  width:
                                                      ScreenUtil().setSp(140),
                                                  height:
                                                      ScreenUtil().setSp(20),
                                                  child: ratings(
                                                      "주차 편의성", starRating[1]),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                                width: ScreenUtil().setSp(16)),
                                            Column(
                                              children: [
                                                Container(
                                                  width:
                                                      ScreenUtil().setSp(140),
                                                  height:
                                                      ScreenUtil().setSp(20),
                                                  child: ratings(
                                                      "아이 동반", starRating[2]),
                                                ),
                                                Container(
                                                  width:
                                                      ScreenUtil().setSp(140),
                                                  height:
                                                      ScreenUtil().setSp(20),
                                                  child: ratings(
                                                      "추천 의향", starRating[3]),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setSp(10)),
                                        Wrap(
                                          direction: Axis.horizontal,
                                          children: [
                                            Text(
                                              "mainText mainText mainText mainText mainText mainText mainText mainText mainText mainText mainText mainText mainText",
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14),
                                              ),
                                              overflow: TextOverflow.fade,
                                              maxLines: isMoreText ? null : 2,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isMoreText = !isMoreText;
                                                });
                                              },
                                              child: Text(
                                                  isMoreText ? "접기" : "더보기",
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(14),
                                                      color: app_font_grey)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setSp(20)),
                                        Row(
                                          children: [
                                            Mutation(
                                                options: MutationOptions(
                                                    document:
                                                        gql(Mutations.addLikes),
                                                    onCompleted:
                                                        (dynamic resultData) {
                                                      if (resultData[
                                                              "add_likes"]
                                                          ["result"]) {
                                                        setState(() {});
                                                      } else {
                                                        Get.snackbar(
                                                            "error",
                                                            resultData[
                                                                    "add_likes"]
                                                                ["msg"]);
                                                      }
                                                    }),
                                                builder: (RunMutation
                                                        runMutation,
                                                    QueryResult queryResult) {
                                                  return Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        runMutation({
                                                          "customer_id":
                                                              customerId,
                                                          "contents_id":
                                                              widget.contentsId,
                                                        });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            color: Colors.red,
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          6)),
                                                          Text(
                                                            "좋아요  $likesCount",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            12)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      color: Colors.red,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setSp(6)),
                                                    Text(
                                                      "북마크  $bookmarksCount",
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(12)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      color: Colors.red,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setSp(6)),
                                                    Text(
                                                      "댓글  $comentsCount",
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(12)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setSp(500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  );
                } else {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Container(
                          width: ScreenUtil().screenWidth,
                          height: ScreenUtil().screenHeight,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingIndicator(),
                              ],
                            ),
                          )),
                    ),
                  );
                }
              } else {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().screenHeight,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingIndicator(),
                            ],
                          ),
                        )),
                  ),
                );
              }
            })
        : Container();
  }

  Row ratings(String title, int rating) {
    return Row(
      children: [
        Expanded(
          child: Container(
              alignment: Alignment.centerLeft,
              height: ScreenUtil().setSp(18),
              child: Text(title,
                  style: TextStyle(fontSize: ScreenUtil().setSp(12)))),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Image.asset("assets/images/rating_icon.png",
                    width: ScreenUtil().setSp(10)),
                SizedBox(width: ScreenUtil().setSp(2)),
                Image.asset(
                    rating > 1
                        ? "assets/images/rating_icon.png"
                        : "assets/images/rating_icon_grey.png",
                    width: ScreenUtil().setSp(10)),
                SizedBox(width: ScreenUtil().setSp(2)),
                Image.asset(
                    rating > 2
                        ? "assets/images/rating_icon.png"
                        : "assets/images/rating_icon_grey.png",
                    width: ScreenUtil().setSp(10)),
                SizedBox(width: ScreenUtil().setSp(2)),
                Image.asset(
                    rating > 3
                        ? "assets/images/rating_icon.png"
                        : "assets/images/rating_icon_grey.png",
                    width: ScreenUtil().setSp(10)),
                SizedBox(width: ScreenUtil().setSp(2)),
                Image.asset(
                    rating > 4
                        ? "assets/images/rating_icon.png"
                        : "assets/images/rating_icon_grey.png",
                    width: ScreenUtil().setSp(10)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
