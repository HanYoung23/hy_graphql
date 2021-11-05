import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/comment_bottom_sheet.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:letsgotrip/widgets/post_cupertino_bottom_sheet.dart';
import 'package:readmore/readmore.dart';

class PlaceDetailScreen extends StatefulWidget {
  final int contentsId;
  final int customerId;
  const PlaceDetailScreen(
      {Key key, @required this.contentsId, @required this.customerId})
      : super(key: key);

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  int likesNum = 0;
  int bookmarksNum = 0;
  int comentsNum = 0;
  int currentIndex = 1;
  bool isLike = false;
  bool isRefreshing = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      // print('offset = ${_scrollController.offset}');
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
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoDetail),
          variables: {
            "contents_id": widget.contentsId,
            "customer_id": widget.customerId,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading) {
            if (result.data["photo_detail"] != null) {
              Map resultData = result.data["photo_detail"];
              print("🚨 place detail result : $resultData");
              String contentsTitle = resultData["contents_title"];
              String nickName = resultData["nick_name"];
              String mainText = resultData["main_text"];
              String registDate = resultData["regist_date"];
              String date =
                  registDate.replaceAll(RegExp(r'-'), ".").substring(0, 10);
              String profilePhotoLink = resultData["profile_photo_link"];
              String tags = resultData["tags"];
              List tagList = tags.split("#").sublist(1);
              // int customerId = resultData["customer_id"];
              int bookmarksCount = resultData["bookmarks_count"];
              int likesCount = resultData["likes_count"];
              int comentsCount = resultData["coments_count"];
              int likes = resultData["likes"];
              int bookmarks = resultData["bookmarks"];
              List imageLink = ("${resultData["image_link"]}").split(",");
              List<int> starRating = [
                resultData["star_rating1"],
                resultData["star_rating2"],
                resultData["star_rating3"],
                resultData["star_rating4"]
              ];

              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(375),
                              height: ScreenUtil().setHeight(44),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(20)),
                              margin:
                                  EdgeInsets.only(top: ScreenUtil().setSp(20)),
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
                                    "게시물",
                                    style: TextStyle(
                                        fontSize: ScreenUtil()
                                            .setSp(appbar_title_size),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                        "assets/images/arrow_back.png",
                                        color: Colors.transparent,
                                        width:
                                            ScreenUtil().setSp(arrow_back_size),
                                        height: ScreenUtil()
                                            .setSp(arrow_back_size)),
                                  ),
                                ],
                              ),
                            ),
                            isRefreshing
                                ? Container(
                                    width: ScreenUtil().screenWidth,
                                    height: ScreenUtil().setSp(42),
                                    child: Center(
                                      child: CupertinoActivityIndicator(),
                                    ))
                                : Container(),
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
                                          placeholder: (context, url) =>
                                              Container(
                                                  width:
                                                      ScreenUtil().screenWidth,
                                                  height:
                                                      ScreenUtil().screenHeight,
                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                            imageLink.length != 1
                                                ? true
                                                : false,
                                        reverse: false,
                                        autoPlay: imageLink.length != 1
                                            ? true
                                            : false,
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
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Center(
                                          child: Text(
                                            "$currentIndex/${imageLink.length}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(12)),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().screenWidth,
                                    height: ScreenUtil().setSp(42),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: ScreenUtil().setSp(42),
                                            height: ScreenUtil().setSp(42),
                                            decoration: profilePhotoLink != null
                                                ? BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            profilePhotoLink),
                                                        fit: BoxFit.cover))
                                                : BoxDecoration(
                                                    color: app_grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50))),
                                        SizedBox(width: ScreenUtil().setSp(15)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                nickName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        ScreenUtil().setSp(14)),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                date,
                                                style: TextStyle(
                                                    color: app_font_grey,
                                                    fontSize:
                                                        ScreenUtil().setSp(12)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: ScreenUtil().setSp(15)),
                                        InkWell(
                                          onTap: () {
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  PostCupertinoBottomSheet(
                                                contentsId: widget.contentsId,
                                                refetchCallback: () =>
                                                    refetch(),
                                              ),
                                            );
                                            // if (widget.customerId !=
                                            //     customerId) {
                                            //   showCupertinoModalPopup(
                                            //     context: context,
                                            //     builder: (BuildContext
                                            //             context) =>
                                            //         ReportCupertinoBottomSheet(
                                            //             contentsId:
                                            //                 widget.contentsId),
                                            //   );
                                            // } else {
                                            //   showCupertinoModalPopup(
                                            //     context: context,
                                            //     builder: (BuildContext
                                            //             context) =>
                                            //         PostCupertinoBottomSheet(
                                            //       contentsId: widget.contentsId,
                                            //       refetchCallback: () =>
                                            //           refetch(),
                                            //     ),
                                            //   );
                                            // }
                                          },
                                          child: Image.asset(
                                              "assets/images/three_dots_toggle_button.png",
                                              width: ScreenUtil().setSp(28),
                                              height: ScreenUtil().setSp(28)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(10)),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: app_grey,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(14),
                                        vertical: ScreenUtil().setSp(6),
                                      ),
                                      child: Text(
                                        contentsTitle,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(12)),
                                      )),
                                  SizedBox(height: ScreenUtil().setHeight(10)),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: ScreenUtil().setSp(140),
                                            height: ScreenUtil().setSp(20),
                                            child:
                                                ratings("방문객", starRating[0]),
                                          ),
                                          Container(
                                            width: ScreenUtil().setSp(140),
                                            height: ScreenUtil().setSp(20),
                                            child: ratings(
                                                "주차 편의성", starRating[1]),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: ScreenUtil().setSp(16)),
                                      Column(
                                        children: [
                                          Container(
                                            width: ScreenUtil().setSp(140),
                                            height: ScreenUtil().setSp(20),
                                            child:
                                                ratings("아이 동반", starRating[2]),
                                          ),
                                          Container(
                                            width: ScreenUtil().setSp(140),
                                            height: ScreenUtil().setSp(20),
                                            child:
                                                ratings("추천 의향", starRating[3]),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(10)),
                                  ReadMoreText(mainText,
                                      trimLines: 2,
                                      colorClickableText: app_font_grey,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        letterSpacing: -0.35,
                                        color: Colors.black,
                                      ),
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '더보기',
                                      trimExpandedText: '접기',
                                      moreStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        letterSpacing: -0.35,
                                        color: app_font_grey,
                                      )),
                                  SizedBox(height: ScreenUtil().setSp(10)),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: tagList.map((tag) {
                                      return Text("#$tag  ",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(14),
                                              letterSpacing: -0.35,
                                              color: Color(0xff1A4F79)));
                                    }).toList(),
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(20)),
                                  Row(
                                    children: [
                                      likeButton(likesCount, likes),
                                      bookmarkButton(bookmarksCount, bookmarks),
                                      comentsButton(comentsCount, refetch),
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(50)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
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
        });
  }

  Expanded comentsButton(int comentsCount, Function refetch) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // runMutation({
          //   "customer_id": widget.customerId,
          //   "contents_id": widget.contentsId,
          //   "coment_text":
          //       "text text text text text text text text text text text text text",
          //   "coments_id_link": "",
          // });
          if (this.mounted) {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => CommentBottomSheet(
                    contentsId: widget.contentsId,
                    callbackRefetch: () => refetch()),
                isScrollControlled: true);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/reply.png",
                width: ScreenUtil().setSp(28), height: ScreenUtil().setSp(28)),
            Text(
              "댓글  ${comentsCount + comentsNum}",
              style: TextStyle(fontSize: ScreenUtil().setSp(12)),
            )
          ],
        ),
      ),
    );
  }

  Mutation bookmarkButton(int bookmarksCount, int bookmarks) {
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.addBookmarks),
            onCompleted: (dynamic resultData) {
              if (resultData["add_bookmarks"]["result"]) {
                // print("🚨 ${resultData["add_bookmarks"]}");
                if (bookmarks == 1) {
                  if (bookmarksNum == 0) {
                    setState(() {
                      bookmarksNum = 1;
                    });
                  } else {
                    setState(() {
                      bookmarksNum = 0;
                    });
                  }
                } else {
                  if (bookmarksNum == 0) {
                    setState(() {
                      bookmarksNum = -1;
                    });
                  } else {
                    setState(() {
                      bookmarksNum = 0;
                    });
                  }
                }
              } else {
                Get.snackbar("error", resultData["add_likes"]["msg"]);
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return Expanded(
            child: InkWell(
              onTap: () {
                runMutation({
                  "customer_id": widget.customerId,
                  "contents_id": widget.contentsId,
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  bookmarks == 1
                      ? Image.asset(
                          bookmarksNum == 0
                              ? "assets/images/bookmark.png"
                              : "assets/images/bookmark_active.png",
                          width: ScreenUtil().setSp(28),
                          height: ScreenUtil().setSp(28))
                      : Image.asset(
                          bookmarksNum != 0
                              ? "assets/images/bookmark.png"
                              : "assets/images/bookmark_active.png",
                          width: ScreenUtil().setSp(28),
                          height: ScreenUtil().setSp(28)),
                  Text(
                    "북마크  ${bookmarksCount + bookmarksNum}",
                    style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                  )
                ],
              ),
            ),
          );
        });
  }

  Mutation likeButton(int likesCount, int likes) {
    return Mutation(
        options: MutationOptions(
            document: gql(Mutations.addLikes),
            onCompleted: (dynamic resultData) {
              if (resultData["add_likes"]["result"]) {
                // print("🚨 ${resultData["add_likes"]}");
                if (likes == 1) {
                  if (likesNum == 0) {
                    setState(() {
                      likesNum = 1;
                    });
                  } else {
                    setState(() {
                      likesNum = 0;
                    });
                  }
                } else {
                  if (likesNum == 0) {
                    setState(() {
                      likesNum = -1;
                    });
                  } else {
                    setState(() {
                      likesNum = 0;
                    });
                  }
                }
              } else {
                Get.snackbar("error", resultData["add_likes"]["msg"]);
              }
            }),
        builder: (RunMutation runMutation, QueryResult queryResult) {
          return Expanded(
            child: InkWell(
              onTap: () {
                runMutation({
                  "customer_id": widget.customerId,
                  "contents_id": widget.contentsId,
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  likes == 1
                      ? Image.asset(
                          likesNum == 0
                              ? "assets/images/like.png"
                              : "assets/images/like_active.png",
                          width: ScreenUtil().setSp(28),
                          height: ScreenUtil().setSp(28))
                      : Image.asset(
                          likesNum != 0
                              ? "assets/images/like.png"
                              : "assets/images/like_active.png",
                          width: ScreenUtil().setSp(28),
                          height: ScreenUtil().setSp(28)),
                  Text(
                    "좋아요  ${likesCount + likesNum}",
                    style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                  )
                ],
              ),
            ),
          );
        });
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
