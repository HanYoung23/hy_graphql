import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/comment_bottom_sheet.dart';
import 'package:letsgotrip/widgets/graphal_mutation.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:letsgotrip/widgets/post_cupertino_bottom_sheet.dart';
import 'package:letsgotrip/widgets/report_cupertino_bottom_sheet.dart';
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
  int currentIndex = 1;
  bool isRefreshing = false;

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
          if (!result.isLoading && result.data != null) {
            if (result.data["photo_detail"] != null) {
              Map resultData = result.data["photo_detail"];
              // print("🚨 place detail result : $resultData");
              String contentsTitle = resultData["contents_title"];
              String nickName = resultData["nick_name"];
              String mainText = resultData["main_text"];
              String registDate = resultData["regist_date"];
              String date =
                  registDate.replaceAll(RegExp(r'-'), ".").substring(0, 10);
              String profilePhotoLink = resultData["profile_photo_link"];
              String tags = resultData["tags"];

              List tagList = [];
              if (tags != null) {
                tagList = tags.split(",");
              }
              // print("🚨 place detail tags : $tags");
              int postCustomerId = resultData["customer_id"];
              // int bookmarksCount = resultData["bookmarks_count"];
              // int likesCount = resultData["likes_count"];
              // int comentsCount = resultData["coments_count"];
              // int likes = resultData["likes"];
              // int bookmarks = resultData["bookmarks"];
              List imageLink = ("${resultData["image_link"]}").split(",");
              List<int> starRating = [
                resultData["star_rating1"],
                resultData["star_rating2"],
                resultData["star_rating3"],
                resultData["star_rating4"],
              ];

              // print("🚨 tagList: $tagList");

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
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().setSp(44),
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(20)),
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setSp(20)),
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
                                  "게시물",
                                  style: TextStyle(
                                    fontFamily: "NotoSansCJKkrBold",
                                    fontSize:
                                        ScreenUtil().setSp(appbar_title_size),
                                    letterSpacing:
                                        ScreenUtil().setSp(letter_spacing),
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
                          isRefreshing
                              ? Container(
                                  width: ScreenUtil().screenWidth,
                                  height: ScreenUtil().setSp(42),
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
                                              placeholder: (context, url) =>
                                                  Container(
                                                      width: ScreenUtil()
                                                          .screenWidth,
                                                      height: ScreenUtil()
                                                          .screenHeight,
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
                                              errorWidget:
                                                  (context, url, error) =>
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
                                            autoPlayInterval:
                                                Duration(seconds: 3),
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
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil().setSp(100)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "$currentIndex/${imageLink.length}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        "NotoSansCJKkrBold",
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
                                                height: ScreenUtil().setSp(42),
                                                decoration: "$profilePhotoLink" !=
                                                        "null"
                                                    ? BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            50)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                profilePhotoLink),
                                                            fit: BoxFit.cover))
                                                    : BoxDecoration(
                                                        color: app_grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            50)),
                                                      )),
                                            SizedBox(
                                                width: ScreenUtil().setSp(15)),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "$nickName",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "NotoSansCJKkrBold",
                                                      fontSize: ScreenUtil()
                                                          .setSp(14),
                                                      letterSpacing:
                                                          ScreenUtil().setSp(
                                                              letter_spacing),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    date,
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
                                            SizedBox(
                                                width: ScreenUtil().setSp(15)),
                                            InkWell(
                                              onTap: () {
                                                if (widget.customerId !=
                                                    postCustomerId) {
                                                  showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ReportCupertinoBottomSheet(
                                                            contentsId: widget
                                                                .contentsId),
                                                  );
                                                } else {
                                                  showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        PostCupertinoBottomSheet(
                                                      contentsId:
                                                          widget.contentsId,
                                                      refetchCallback: () =>
                                                          refetch(),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Image.asset(
                                                  "assets/images/three_dots_toggle_button.png",
                                                  width: ScreenUtil().setSp(28),
                                                  height:
                                                      ScreenUtil().setSp(28)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setHeight(10)),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setSp(16),
                                              vertical: ScreenUtil().setSp(8)),
                                          decoration: BoxDecoration(
                                            color: app_grey,
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setSp(50)),
                                          ),
                                          child: Text(
                                            contentsTitle,
                                            style: TextStyle(
                                              fontFamily:
                                                  "NotoSansCJKkrRegular",
                                              fontSize: ScreenUtil().setSp(12),
                                              letterSpacing: ScreenUtil()
                                                  .setSp(letter_spacing_small),
                                            ),
                                          )),
                                      SizedBox(
                                          height: ScreenUtil().setHeight(10)),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: ScreenUtil().setSp(140),
                                                height: ScreenUtil().setSp(20),
                                                child: ratings(
                                                    "방문객", starRating[0]),
                                              ),
                                              Container(
                                                width: ScreenUtil().setSp(140),
                                                height: ScreenUtil().setSp(20),
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
                                                width: ScreenUtil().setSp(140),
                                                height: ScreenUtil().setSp(20),
                                                child: ratings(
                                                    "아이 동반", starRating[2]),
                                              ),
                                              Container(
                                                width: ScreenUtil().setSp(140),
                                                height: ScreenUtil().setSp(20),
                                                child: ratings(
                                                    "추천 의향", starRating[3]),
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
                                      SizedBox(height: ScreenUtil().setSp(10)),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: tagList.map((tag) {
                                          return tag != ""
                                              ? Text("#$tag  ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "NotoSansCJKkrRegular",
                                                      fontSize: ScreenUtil()
                                                          .setSp(14),
                                                      letterSpacing:
                                                          letter_spacing_small,
                                                      color: Color(0xff1A4F79)))
                                              : Container();
                                        }).toList(),
                                      ),
                                      SizedBox(height: ScreenUtil().setSp(20)),
                                      countButtons(),
                                      SizedBox(height: ScreenUtil().setSp(50)),
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
            } else {
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

  Query countButtons() {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoDetailCounts),
          variables: {
            "contents_id": widget.contentsId,
            "customer_id": widget.customerId,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["photo_detail"];
            int bookmarksCount = resultData["bookmarks_count"];
            int likesCount = resultData["likes_count"];
            int comentsCount = resultData["coments_count"];
            int likes = resultData["likes"];
            int bookmarks = resultData["bookmarks"];
            return Row(
              children: [
                likeButton(likesCount, likes),
                bookmarkButton(bookmarksCount, bookmarks),
                comentsButton(comentsCount),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Query comentsButton(int comentsCount) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoDetailCommentCounts),
          variables: {
            "contents_id": widget.contentsId,
            "customer_id": widget.customerId,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["photo_detail"];
            int newComentsCount = resultData["coments_count"];

            return Expanded(
              child: InkWell(
                onTap: () {
                  if (this.mounted) {
                    seeValue("customerId").then((value) {
                      int customerId = int.parse(value);
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => CommentBottomSheet(
                          contentsId: widget.contentsId,
                          customerId: customerId,
                          // commentCount: newComentsCount,
                        ),
                        isScrollControlled: true,
                      ).then((value) {
                        refetch();
                      });
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setSp(18),
                      height: ScreenUtil().setSp(18),
                      // child: Image.asset(
                      //   "assets/images/reply.png",
                      //   fit: BoxFit.contain,
                      // ),
                      child: SvgPicture.asset(
                        "assets/images/reply.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setSp(6)),
                    Text(
                      "댓글  $newComentsCount",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_x_small),
                          fontSize: ScreenUtil().setSp(12)),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenUtil().setSp(18),
                    height: ScreenUtil().setSp(18),
                    // child: Image.asset(
                    //   "assets/images/reply.png",
                    //   fit: BoxFit.contain,
                    // ),
                    child: SvgPicture.asset(
                      "assets/images/reply.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setSp(6)),
                  Text(
                    "댓글  $comentsCount",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        letterSpacing:
                            ScreenUtil().setSp(letter_spacing_x_small),
                        fontSize: ScreenUtil().setSp(12)),
                  )
                ],
              ),
            );
          }
        });
  }

  Query bookmarkButton(int bookmarksCount, int bookmarks) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoDetailBookmarkCounts),
          variables: {
            "contents_id": widget.contentsId,
            "customer_id": widget.customerId,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["photo_detail"];
            int newBookmarksCount = resultData["bookmarks_count"];
            int newBookmarks = resultData["bookmarks"];

            return Mutation(
                options: MutationOptions(
                    document: gql(Mutations.addBookmarks),
                    onCompleted: (dynamic resultData) {
                      if (resultData["add_bookmarks"]["result"]) {
                        refetch();
                      } else {
                        Get.snackbar(
                            "error", resultData["add_bookmarks"]["msg"]);
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
                          Container(
                            width: ScreenUtil().setSp(18),
                            height: ScreenUtil().setSp(18),
                            child: newBookmarks != 1
                                ? SvgPicture.asset(
                                    "assets/images/bookmark.svg",
                                    fit: BoxFit.contain,
                                  )
                                : SvgPicture.asset(
                                    "assets/images/bookmark_active.svg",
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          SizedBox(width: ScreenUtil().setSp(6)),
                          Text(
                            "북마크  $newBookmarksCount",
                            style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_x_small),
                                fontSize: ScreenUtil().setSp(12)),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenUtil().setSp(18),
                    height: ScreenUtil().setSp(18),
                    child: bookmarks != 1
                        ? SvgPicture.asset(
                            "assets/images/bookmark.svg",
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            "assets/images/bookmark_active.svg",
                            fit: BoxFit.contain,
                          ),
                  ),
                  SizedBox(width: ScreenUtil().setSp(6)),
                  Text(
                    "북마크  $bookmarksCount",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        letterSpacing:
                            ScreenUtil().setSp(letter_spacing_x_small),
                        fontSize: ScreenUtil().setSp(12)),
                  )
                ],
              ),
            );
          }
        });
  }

  Query likeButton(int likesCount, int likes) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.photoDetailLikeCounts),
          variables: {
            "contents_id": widget.contentsId,
            "customer_id": widget.customerId,
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["photo_detail"];
            int newLikesCount = resultData["likes_count"];
            int newLikes = resultData["likes"];

            return Mutation(
                options: MutationOptions(
                    document: gql(Mutations.addLikes),
                    onCompleted: (dynamic resultData) {
                      if (resultData["add_likes"]["result"]) {
                        refetch();
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
                          Container(
                            width: ScreenUtil().setSp(18),
                            height: ScreenUtil().setSp(18),
                            child: newLikes != 1
                                ? SvgPicture.asset(
                                    "assets/images/like_active.svg",
                                    fit: BoxFit.contain,
                                  )
                                : SvgPicture.asset(
                                    "assets/images/like.svg",
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          SizedBox(width: ScreenUtil().setSp(6)),
                          Text(
                            "좋아요  $newLikesCount",
                            style: TextStyle(
                                fontFamily: "NotoSansCJKkrRegular",
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing_x_small),
                                fontSize: ScreenUtil().setSp(12)),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenUtil().setSp(18),
                    height: ScreenUtil().setSp(18),
                    child: likes != 1
                        ? SvgPicture.asset(
                            "assets/images/like_active.svg",
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            "assets/images/like.svg",
                            fit: BoxFit.contain,
                          ),
                  ),
                  SizedBox(width: ScreenUtil().setSp(6)),
                  Text(
                    "좋아요  $likesCount",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkrRegular",
                        letterSpacing:
                            ScreenUtil().setSp(letter_spacing_x_small),
                        fontSize: ScreenUtil().setSp(12)),
                  )
                ],
              ),
            );
          }
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
                  style: TextStyle(
                      fontFamily: "NotoSansCJKkrRegular",
                      letterSpacing: ScreenUtil().setSp(letter_spacing_x_small),
                      fontSize: ScreenUtil().setSp(12)))),
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
