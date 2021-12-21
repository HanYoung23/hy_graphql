import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/_View/MainPages/settings/ad_post_edit_screen.dart';
import 'package:letsgotrip/_View/MainPages/settings/googlemap_bottom_sheet.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/material_popup.dart';
import 'package:letsgotrip/widgets/channeltalk_bottom_sheet.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:letsgotrip/_View/MainPages/settings/phone_call_cupertino_bottom_sheet.dart';
import 'package:readmore/readmore.dart';

class AdPostMineScreen extends StatefulWidget {
  // final int contentsId;
  // final int customerId;
  final Map paramData;
  final Function refetchCallback;
  const AdPostMineScreen({
    Key key,
    // @required this.contentsId,
    // @required this.customerId,
    @required this.paramData,
    this.refetchCallback,
  }) : super(key: key);

  @override
  _AdPostMineScreenState createState() => _AdPostMineScreenState();
}

class _AdPostMineScreenState extends State<AdPostMineScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 1;
  bool isRefreshing = false;
  List imageLink = [];
  String profilePhotoLink = "";
  // String nickname = "";
  String date = "";
  String currentState = "일시중지";
  String clickedButton = "";
  String range = "";
  String promotionState = "";

  setParamData() {
    String dateString = widget.paramData["regist_date"];
    if (widget.paramData["edit_date"] != null) {
      dateString = widget.paramData["edit_date"];
    }
    String dateFormat =
        DateFormat("yyyy.MM.dd").format(DateTime.parse(dateString));

    String postRange = "${widget.paramData["ranges"]}".substring(0, 1);
    if (widget.paramData["ranges"] == 500) {
      postRange = "500m";
    }
    setState(() {
      imageLink = "${widget.paramData["image_link"]}".split(",");
      date = dateFormat;
      range = postRange;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset < 0.0) {
        setState(() {
          isRefreshing = true;
        });
        Future.delayed(
            Duration(milliseconds: 1000),
            () => setState(() {
                  isRefreshing = false;
                }));
      }
    });
    print("🚨 ${widget.paramData}");
    setParamData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (promotionState == "") {
      switch (widget.paramData["promotions_state"]) {
        case 1:
          promotionState = "심사 대기중";
          break;
        case 2:
          promotionState = "승인 반려됨";
          break;
        case 3:
          promotionState = "진행중";
          currentState = "일시중지";
          break;
        case 4:
          promotionState = "중지됨";
          currentState = "게시물 홍보 진행하기";
          break;
        case 5:
          promotionState = "완료";
          break;
        case 6:
          promotionState = "삭제됨";
          break;
        default:
      }
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: ScreenUtil().setSp(side_gap),
                  color: Colors.white,
                ),
                Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setSp(44),
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
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
                                height: ScreenUtil().setSp(arrow_back_size)),
                          ),
                        ),
                      ),
                      Text(
                        "내 게시물 관리",
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          letterSpacing: ScreenUtil().setSp(letter_spacing),
                        ),
                      ),
                      Expanded(
                        child: Image.asset("assets/images/arrow_back.png",
                            color: Colors.transparent,
                            width: ScreenUtil().setSp(arrow_back_size),
                            height: ScreenUtil().setSp(arrow_back_size)),
                      ),
                    ],
                  ),
                ),
                isRefreshing
                    ? Container(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(42),
                        color: Colors.white,
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ))
                    : Container(),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: CarouselSlider(
                                items: imageLink.map((url) {
                                  // return Image.network(url,
                                  //     width: ScreenUtil().screenWidth,
                                  //     height: ScreenUtil().screenWidth,
                                  //     fit: BoxFit.cover);

                                  return CachedNetworkImage(
                                    imageUrl: url,
                                    width: ScreenUtil().screenWidth,
                                    height: ScreenUtil().screenWidth,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                        width: ScreenUtil().screenWidth,
                                        height: ScreenUtil().screenHeight,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              LoadingIndicator(),
                                            ],
                                          ),
                                        )),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  aspectRatio: 1,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll:
                                      imageLink.length != 1 ? true : false,
                                  reverse: false,
                                  autoPlay:
                                      imageLink.length != 1 ? true : false,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      currentIndex = index + 1;
                                    });
                                  },
                                  scrollDirection: Axis.horizontal,
                                )),
                          ),
                          Positioned(
                            bottom: ScreenUtil().setSp(8),
                            child: Container(
                              width: ScreenUtil().screenWidth,
                              alignment: Alignment.center,
                              child: Container(
                                  width: ScreenUtil().setSp(48),
                                  height: ScreenUtil().setSp(22),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setSp(100)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$currentIndex/${imageLink.length}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "NotoSansCJKkrBold",
                                          fontSize: ScreenUtil().setSp(12)),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                      Container(
                          height: ScreenUtil().setSp(14), color: Colors.white),
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(42),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(20)),
                              child: Query(
                                  options: QueryOptions(
                                    document: gql(Queries.mypage),
                                    variables: {
                                      "customer_id":
                                          widget.paramData["customer_id"],
                                    },
                                  ),
                                  builder: (result, {refetch, fetchMore}) {
                                    if (!result.isLoading &&
                                        result.data != null) {
                                      Map resultData = result.data["mypage"][0];
                                      // print("🚨 mypage result : $resultData");
                                      String nickname = resultData["nick_name"];
                                      String profilePhotoLink =
                                          resultData["profile_photo_link"];
                                      return Row(
                                        children: [
                                          Container(
                                              width: ScreenUtil().setSp(42),
                                              height: ScreenUtil().setSp(42),
                                              decoration: "$profilePhotoLink" !=
                                                      "null"
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenUtil()
                                                                  .setSp(50)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              profilePhotoLink),
                                                          fit: BoxFit.cover))
                                                  : BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/profileSettings/thumbnail_default.png"),
                                                          fit: BoxFit.cover),
                                                    )),
                                          SizedBox(
                                              width: ScreenUtil().setSp(15)),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  nickname,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "NotoSansCJKkrBold",
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    letterSpacing: ScreenUtil()
                                                        .setSp(letter_spacing),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  "$date",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "NotoSansCJKkrRegular",
                                                      color: app_font_grey,
                                                      fontSize: ScreenUtil()
                                                          .setSp(12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //     width: ScreenUtil().setSp(15)),
                                          // InkWell(
                                          // onTap: () {
                                          //   if (widget.customerId != postCustomerId) {
                                          //     showCupertinoModalPopup(
                                          //       context: context,
                                          //       builder: (BuildContext context) =>
                                          //           ReportCupertinoBottomSheet(
                                          //               contentsId:
                                          //                   widget.contentsId),
                                          //     );
                                          //   } else {
                                          //     showCupertinoModalPopup(
                                          //       context: context,
                                          //       builder: (BuildContext context) =>
                                          //           PostCupertinoBottomSheet(
                                          //         contentsId: widget.contentsId,
                                          //         refetchCallback: () => refetch(),
                                          //       ),
                                          //     );
                                          //   }
                                          // },
                                          // child: Image.asset(
                                          //     "assets/images/three_dots_toggle_button.png",
                                          //     width: ScreenUtil().setSp(28),
                                          //     height: ScreenUtil().setSp(28)),
                                          // ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ),
                            SizedBox(height: ScreenUtil().setSp(16)),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(16),
                                    vertical: ScreenUtil().setSp(8)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setSp(20)),
                                decoration: BoxDecoration(
                                  color: app_grey,
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(50)),
                                ),
                                child: Text(
                                  "${widget.paramData["business_name"]}",
                                  style: TextStyle(
                                    fontFamily: "NotoSansCJKkrRegular",
                                    fontSize: ScreenUtil().setSp(12),
                                    letterSpacing: ScreenUtil()
                                        .setSp(letter_spacing_x_small),
                                  ),
                                )),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(20)),
                              child: Text(
                                "${widget.paramData["title"]}",
                                style: TextStyle(
                                  fontFamily: "NotoSansCJKkrBold",
                                  fontSize: ScreenUtil().setSp(18),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing_big),
                                ),
                                // maxLines: 2,
                                // overflow: TextOverflow.fade,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(20)),
                              child: ReadMoreText(
                                  "${widget.paramData["main_text"]}",
                                  trimLines: 2,
                                  colorClickableText: app_font_grey,
                                  style: TextStyle(
                                    fontFamily: "NotoSansCJKkrRegular",
                                    fontSize: ScreenUtil().setSp(14),
                                    letterSpacing: ScreenUtil()
                                        .setSp(letter_spacing_small),
                                  ),
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '더보기',
                                  trimExpandedText: '접기',
                                  moreStyle: TextStyle(
                                    fontFamily: "NotoSansCJKkrRegular",
                                    fontSize: ScreenUtil().setSp(14),
                                    letterSpacing: ScreenUtil()
                                        .setSp(letter_spacing_small),
                                    color: app_font_grey,
                                  )),
                            ),
                            SizedBox(height: ScreenUtil().setSp(24)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(20)),
                              child: Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PhoneCallCupertinoBottomSheet(
                                          phone: "${widget.paramData["phone"]}",
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: ScreenUtil().setSp(0.5),
                                            color: app_font_grey),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(10)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(12),
                                        vertical: ScreenUtil().setSp(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/phone_icon.png",
                                            width: ScreenUtil().setSp(14),
                                            height: ScreenUtil().setSp(14),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setSp(8)),
                                          Text(
                                            "전화연결",
                                            style: TextStyle(
                                              fontFamily: "NotoSansCJKkrBold",
                                              fontSize: ScreenUtil().setSp(14),
                                              letterSpacing: ScreenUtil()
                                                  .setSp(letter_spacing_small),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setSp(6)),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              GooglemapBottomSheet(
                                                latlng: LatLng(
                                                  double.parse(
                                                      "${widget.paramData["latitude"]}"),
                                                  double.parse(
                                                      "${widget.paramData["longitude"]}"),
                                                ),
                                                address:
                                                    "${widget.paramData["location_link"]}",
                                                title:
                                                    "${widget.paramData["business_name"]}",
                                              ),
                                          isScrollControlled: true,
                                          enableDrag: false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: ScreenUtil().setSp(0.5),
                                            color: app_font_grey),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(10)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(12),
                                        vertical: ScreenUtil().setSp(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/location_icon.png",
                                            width: ScreenUtil().setSp(14),
                                            height: ScreenUtil().setSp(14),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setSp(8)),
                                          Text(
                                            "지도에서 위치확인",
                                            style: TextStyle(
                                              fontFamily: "NotoSansCJKkrBold",
                                              fontSize: ScreenUtil().setSp(14),
                                              letterSpacing: ScreenUtil()
                                                  .setSp(letter_spacing_small),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            // 좋아요 북마크 댓글
                            Container(
                              color: app_grey,
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(1),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(20)),
                              child: Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ChanneltalkBottomSheet(),
                                        isScrollControlled: true,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(10)),
                                        color: app_grey,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(12),
                                        vertical: ScreenUtil().setSp(8),
                                      ),
                                      child: Text("1:1 고객문의",
                                          style: TextStyle(
                                            fontFamily: "NotoSansCJKkrBold",
                                            fontSize: ScreenUtil().setSp(12),
                                            letterSpacing: ScreenUtil()
                                                .setSp(letter_spacing_x_small),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            postInfo(
                                "희망지역", "${widget.paramData["location_link"]}"),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            postInfo(
                                "도달범위",
                                range == "500m"
                                    ? "반경 $range"
                                    : "반경 ${range}km"),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            postInfo("클릭횟수",
                                "(${widget.paramData["promotions_count"]}/${widget.paramData["promotions_count_total"]})"),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            postInfo("작동상태", "$promotionState"),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            Mutation(
                                options: MutationOptions(
                                    document: gql(Mutations.pausePromotions),
                                    update: (GraphQLDataProxy proxy,
                                        QueryResult result) {},
                                    onCompleted: (dynamic resultData) {
                                      print("🚨 resultData : $resultData");
                                      if (resultData["pause_promotions"]
                                          ["result"]) {
                                        currentState == "일시중지"
                                            ? adResumePopup(context)
                                            : print("");
                                        setState(() {
                                          promotionState =
                                              currentState != "일시중지"
                                                  ? "진행중"
                                                  : "중지됨";
                                          currentState = currentState == "일시중지"
                                              ? "게시물 홍보 진행하기"
                                              : "일시중지";
                                          clickedButton = currentState;
                                        });
                                        widget.refetchCallback();
                                      }
                                    }),
                                builder: (RunMutation runMutation,
                                    QueryResult queryResult) {
                                  return InkWell(
                                      onTap: () {
                                        currentState == "일시중지"
                                            ? adPausePopup(
                                                context,
                                                () => runMutation({
                                                      "promotions_id":
                                                          widget.paramData[
                                                              "promotions_id"],
                                                      "type": 4,
                                                    }))
                                            : runMutation({
                                                "promotions_id": widget
                                                    .paramData["promotions_id"],
                                                "type": 3,
                                              });
                                      },
                                      child:
                                          postButton(context, "$currentState"));
                                }),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    clickedButton = "게시물 수정하기";
                                  });
                                  Get.to(() => AdPostEditScreen(
                                      paramData: widget.paramData));
                                },
                                child: postButton(context, "게시물 수정하기")),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            Mutation(
                                options: MutationOptions(
                                    document: gql(Mutations.delPromotions),
                                    update: (GraphQLDataProxy proxy,
                                        QueryResult result) {},
                                    onCompleted: (dynamic resultData) {
                                      int totalCount = int.parse(
                                          "${widget.paramData["promotions_count_total"]}");
                                      int usedCount = int.parse(
                                          "${resultData["del_promotions"]["msg"]}");

                                      print("🚨 resultData : $resultData");
                                      if (resultData["del_promotions"]
                                          ["result"]) {
                                        adDeleteDonePopup(
                                            context, totalCount - usedCount);
                                        // adDeleteDonePopup(context, 100);
                                      }
                                    }),
                                builder: (RunMutation runMutation,
                                    QueryResult queryResult) {
                                  return InkWell(
                                      onTap: () {
                                        adDeletePopup(
                                            context,
                                            () => runMutation({
                                                  "promotions_id": int.parse(
                                                      "${widget.paramData["promotions_id"]}"),
                                                  "customer_id": int.parse(
                                                      "${widget.paramData["customer_id"]}"),
                                                }));
                                      },
                                      child: postButton(context, "게시물 삭제하기"));
                                }),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            Container(
                              color: app_grey,
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(6),
                            ),
                            SizedBox(height: ScreenUtil().setSp(160)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Container postButton(BuildContext context, String title) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().setSp(50),
        decoration: BoxDecoration(
          color: clickedButton == title ? app_grey : Colors.white,
          border:
              Border.all(width: ScreenUtil().setSp(0.5), color: app_font_grey),
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(5)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(14),
            letterSpacing: ScreenUtil().setSp(letter_spacing_small),
            color: clickedButton == title ? app_font_grey : Colors.black,
          ),
        ));
  }

  Container postInfo(String title, String desc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                fontFamily: "NotoSansCJKkrBold",
                fontSize: ScreenUtil().setSp(14),
                letterSpacing: ScreenUtil().setSp(letter_spacing_small),
              )),
          SizedBox(width: ScreenUtil().setSp(20)),
          Expanded(
            child: Text(
              desc,
              style: TextStyle(
                fontFamily: title == "작동상태"
                    ? "NotoSansCJKkrBold"
                    : "NotoSansCJKkrRegular",
                fontSize: ScreenUtil().setSp(14),
                letterSpacing: ScreenUtil().setSp(letter_spacing_small),
                color: title == "작동상태" ? app_blue : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // Query countButtons() {
  //   return Query(
  //       options: QueryOptions(
  //         document: gql(Queries.photoDetailCounts),
  //         variables: {
  //           "contents_id": widget.contentsId,
  //           "customer_id": widget.customerId,
  //         },
  //       ),
  //       builder: (result, {refetch, fetchMore}) {
  //         if (!result.isLoading && result.data != null) {
  //           Map resultData = result.data["photo_detail"];
  //           int bookmarksCount = resultData["bookmarks_count"];
  //           int likesCount = resultData["likes_count"];
  //           int comentsCount = resultData["coments_count"];
  //           int likes = resultData["likes"];
  //           int bookmarks = resultData["bookmarks"];
  //           return Row(
  //             children: [
  //               likeButton(likesCount, likes),
  //               bookmarkButton(bookmarksCount, bookmarks),
  //               comentsButton(comentsCount),
  //             ],
  //           );
  //         } else {
  //           return Container();
  //         }
  //       });
  // }

  // Query comentsButton(int comentsCount) {
  //   return Query(
  //       options: QueryOptions(
  //         document: gql(Queries.photoDetailCommentCounts),
  //         variables: {
  //           "contents_id": widget.contentsId,
  //           "customer_id": widget.customerId,
  //         },
  //       ),
  //       builder: (result, {refetch, fetchMore}) {
  //         if (!result.isLoading && result.data != null) {
  //           Map resultData = result.data["photo_detail"];
  //           int newComentsCount = resultData["coments_count"];

  //           return Expanded(
  //             child: InkWell(
  //               onTap: () {
  //                 if (this.mounted) {
  //                   seeValue("customerId").then((value) {
  //                     int customerId = int.parse(value);
  //                     showModalBottomSheet(
  //                       backgroundColor: Colors.transparent,
  //                       context: context,
  //                       builder: (_) => CommentBottomSheet(
  //                         contentsId: widget.contentsId,
  //                         customerId: customerId,
  //                         commentCount: newComentsCount,
  //                       ),
  //                       isScrollControlled: true,
  //                     ).then((value) {
  //                       refetch();
  //                     });
  //                   });
  //                 }
  //               },
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: ScreenUtil().setSp(18),
  //                     height: ScreenUtil().setSp(18),
  //                     // child: Image.asset(
  //                     //   "assets/images/reply.png",
  //                     //   fit: BoxFit.contain,
  //                     // ),
  //                     child: SvgPicture.asset(
  //                       "assets/images/reply.svg",
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                   SizedBox(width: ScreenUtil().setSp(6)),
  //                   Text(
  //                     "댓글  $newComentsCount",
  //                     style: TextStyle(
  //                         fontFamily: "NotoSansCJKkrRegular",
  //                         letterSpacing:
  //                             ScreenUtil().setSp(letter_spacing_x_small),
  //                         fontSize: ScreenUtil().setSp(12)),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         } else {
  //           return Expanded(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   width: ScreenUtil().setSp(18),
  //                   height: ScreenUtil().setSp(18),
  //                   // child: Image.asset(
  //                   //   "assets/images/reply.png",
  //                   //   fit: BoxFit.contain,
  //                   // ),
  //                   child: SvgPicture.asset(
  //                     "assets/images/reply.svg",
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //                 SizedBox(width: ScreenUtil().setSp(6)),
  //                 Text(
  //                   "댓글  $comentsCount",
  //                   style: TextStyle(
  //                       fontFamily: "NotoSansCJKkrRegular",
  //                       letterSpacing:
  //                           ScreenUtil().setSp(letter_spacing_x_small),
  //                       fontSize: ScreenUtil().setSp(12)),
  //                 )
  //               ],
  //             ),
  //           );
  //         }
  //       });
  // }

  // Query bookmarkButton(int bookmarksCount, int bookmarks) {
  //   return Query(
  //       options: QueryOptions(
  //         document: gql(Queries.photoDetailBookmarkCounts),
  //         variables: {
  //           "contents_id": widget.contentsId,
  //           "customer_id": widget.customerId,
  //         },
  //       ),
  //       builder: (result, {refetch, fetchMore}) {
  //         if (!result.isLoading && result.data != null) {
  //           Map resultData = result.data["photo_detail"];
  //           int newBookmarksCount = resultData["bookmarks_count"];
  //           int newBookmarks = resultData["bookmarks"];

  //           return Mutation(
  //               options: MutationOptions(
  //                   document: gql(Mutations.addBookmarks),
  //                   onCompleted: (dynamic resultData) {
  //                     if (resultData["add_bookmarks"]["result"]) {
  //                       refetch();
  //                     } else {
  //                       Get.snackbar(
  //                           "error", resultData["add_bookmarks"]["msg"]);
  //                     }
  //                   }),
  //               builder: (RunMutation runMutation, QueryResult queryResult) {
  //                 return Expanded(
  //                   child: InkWell(
  //                     onTap: () {
  //                       runMutation({
  //                         "customer_id": widget.customerId,
  //                         "contents_id": widget.contentsId,
  //                       });
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           width: ScreenUtil().setSp(18),
  //                           height: ScreenUtil().setSp(18),
  //                           child: newBookmarks != 1
  //                               ? SvgPicture.asset(
  //                                   "assets/images/bookmark.svg",
  //                                   fit: BoxFit.contain,
  //                                 )
  //                               : SvgPicture.asset(
  //                                   "assets/images/bookmark_active.svg",
  //                                   fit: BoxFit.contain,
  //                                 ),
  //                         ),
  //                         SizedBox(width: ScreenUtil().setSp(6)),
  //                         Text(
  //                           "북마크  $newBookmarksCount",
  //                           style: TextStyle(
  //                               fontFamily: "NotoSansCJKkrRegular",
  //                               letterSpacing:
  //                                   ScreenUtil().setSp(letter_spacing_x_small),
  //                               fontSize: ScreenUtil().setSp(12)),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //         } else {
  //           return Expanded(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   width: ScreenUtil().setSp(18),
  //                   height: ScreenUtil().setSp(18),
  //                   child: bookmarks != 1
  //                       ? SvgPicture.asset(
  //                           "assets/images/bookmark.svg",
  //                           fit: BoxFit.contain,
  //                         )
  //                       : SvgPicture.asset(
  //                           "assets/images/bookmark_active.svg",
  //                           fit: BoxFit.contain,
  //                         ),
  //                 ),
  //                 SizedBox(width: ScreenUtil().setSp(6)),
  //                 Text(
  //                   "북마크  $bookmarksCount",
  //                   style: TextStyle(
  //                       fontFamily: "NotoSansCJKkrRegular",
  //                       letterSpacing:
  //                           ScreenUtil().setSp(letter_spacing_x_small),
  //                       fontSize: ScreenUtil().setSp(12)),
  //                 )
  //               ],
  //             ),
  //           );
  //         }
  //       });
  // }

  // Query likeButton(int likesCount, int likes) {
  //   return Query(
  //       options: QueryOptions(
  //         document: gql(Queries.photoDetailLikeCounts),
  //         variables: {
  //           "contents_id": widget.contentsId,
  //           "customer_id": widget.customerId,
  //         },
  //       ),
  //       builder: (result, {refetch, fetchMore}) {
  //         if (!result.isLoading && result.data != null) {
  //           Map resultData = result.data["photo_detail"];
  //           int newLikesCount = resultData["likes_count"];
  //           int newLikes = resultData["likes"];

  //           return Mutation(
  //               options: MutationOptions(
  //                   document: gql(Mutations.addLikes),
  //                   onCompleted: (dynamic resultData) {
  //                     if (resultData["add_likes"]["result"]) {
  //                       refetch();
  //                     } else {
  //                       Get.snackbar("error", resultData["add_likes"]["msg"]);
  //                     }
  //                   }),
  //               builder: (RunMutation runMutation, QueryResult queryResult) {
  //                 return Expanded(
  //                   child: InkWell(
  //                     onTap: () {
  //                       runMutation({
  //                         "customer_id": widget.customerId,
  //                         "contents_id": widget.contentsId,
  //                       });
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           width: ScreenUtil().setSp(18),
  //                           height: ScreenUtil().setSp(18),
  //                           child: newLikes != 1
  //                               ? SvgPicture.asset(
  //                                   "assets/images/like_active.svg",
  //                                   fit: BoxFit.contain,
  //                                 )
  //                               : SvgPicture.asset(
  //                                   "assets/images/like.svg",
  //                                   fit: BoxFit.contain,
  //                                 ),
  //                         ),
  //                         SizedBox(width: ScreenUtil().setSp(6)),
  //                         Text(
  //                           "좋아요  $newLikesCount",
  //                           style: TextStyle(
  //                               fontFamily: "NotoSansCJKkrRegular",
  //                               letterSpacing:
  //                                   ScreenUtil().setSp(letter_spacing_x_small),
  //                               fontSize: ScreenUtil().setSp(12)),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //         } else {
  //           return Expanded(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   width: ScreenUtil().setSp(18),
  //                   height: ScreenUtil().setSp(18),
  //                   child: likes != 1
  //                       ? SvgPicture.asset(
  //                           "assets/images/like_active.svg",
  //                           fit: BoxFit.contain,
  //                         )
  //                       : SvgPicture.asset(
  //                           "assets/images/like.svg",
  //                           fit: BoxFit.contain,
  //                         ),
  //                 ),
  //                 SizedBox(width: ScreenUtil().setSp(6)),
  //                 Text(
  //                   "좋아요  $likesCount",
  //                   style: TextStyle(
  //                       fontFamily: "NotoSansCJKkrRegular",
  //                       letterSpacing:
  //                           ScreenUtil().setSp(letter_spacing_x_small),
  //                       fontSize: ScreenUtil().setSp(12)),
  //                 )
  //               ],
  //             ),
  //           );
  //         }
  //       });
  //

}
