import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/map/place_detail_screen.dart';
import 'package:letsgotrip/_View/MainPages/profile/profile_edit_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/_View/MainPages/settings/menu_drawer_screen.dart';
import 'package:readmore/readmore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int customerId;
  int currentTap = 1;
  List postPages = [1];
  List commentPages = [1];
  List bookmarkPages = [1];
  bool isRefreshing = false;
  int num = 0;

  refresh() {
    setState(() {
      isRefreshing = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isRefreshing = false;
      });
    });
  }

  bool onPostNotification(ScrollEndNotification t) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge && this.mounted) {
      List newPages = postPages;
      int lastPage = newPages.length;
      newPages.add(lastPage + 1);
      setState(() {
        postPages = newPages;
      });
    } else if (t.metrics.pixels == 0 && t.metrics.atEdge && this.mounted) {
      refresh();
    }
    return true;
  }

  bool onCommentNotification(ScrollEndNotification t) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge && this.mounted) {
      List newPages = commentPages;
      int lastPage = newPages.length;
      newPages.add(lastPage + 1);
      setState(() {
        commentPages = newPages;
      });
    } else if (t.metrics.pixels == 0 && t.metrics.atEdge && this.mounted) {
      refresh();
    }
    return true;
  }

  bool onBookmarkNotification(ScrollEndNotification t) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge && this.mounted) {
      List newPages = bookmarkPages;
      int lastPage = newPages.length;
      newPages.add(lastPage + 1);
      setState(() {
        bookmarkPages = newPages;
      });
    } else if (t.metrics.pixels == 0 && t.metrics.atEdge && this.mounted) {
      refresh();
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        ? SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 0,
                elevation: 0,
                backgroundColor: Colors.black,
                brightness: Brightness.dark,
              ),
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  child: Column(
                    children: [
                      SizedBox(height: ScreenUtil().setSp(20)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setSp(44),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        scaffoldKey.currentState.openDrawer();
                                      },
                                      child: Image.asset(
                                          "assets/images/hamburger_button.png",
                                          width: ScreenUtil().setSp(28),
                                          height: ScreenUtil().setSp(28))),
                                  Text(
                                    "마이페이지",
                                    style: TextStyle(
                                        fontFamily: "NotoSansCJKkrBold",
                                        fontSize: ScreenUtil()
                                            .setSp(appbar_title_size),
                                        letterSpacing:
                                            ScreenUtil().setSp(letter_spacing)),
                                  ),
                                  Image.asset(
                                    "assets/images/hamburger_button.png",
                                    width: ScreenUtil().setSp(28),
                                    height: ScreenUtil().setSp(28),
                                    color: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            mypageQuery(),
                            SizedBox(height: ScreenUtil().setSp(20)),
                            Text(
                              "개인활동",
                              style: TextStyle(
                                  fontFamily: "NotoSansCJKkrBold",
                                  fontSize: ScreenUtil().setSp(16),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing)),
                            ),
                            SizedBox(height: ScreenUtil().setSp(10)),
                            !isRefreshing
                                ? mypageCountQuery()
                                : mypageCountContainer(0, 0, 0, true),
                            SizedBox(height: ScreenUtil().setSp(10)),
                          ],
                        ),
                      ),
                      Container(
                        color: app_grey_light,
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().setSp(10),
                      ),
                      currentTap == 1
                          ? Flexible(
                              child: !isRefreshing
                                  ? NotificationListener(
                                      onNotification: onPostNotification,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: postPages.map((page) {
                                          return mypageContentsListQuery(page);
                                        }).toList(),
                                      ),
                                    )
                                  : CupertinoActivityIndicator(),
                            )
                          : Container(),
                      currentTap == 2
                          ? Flexible(
                              child: !isRefreshing
                                  ? NotificationListener(
                                      onNotification: onCommentNotification,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: commentPages.map((page) {
                                          return mypageComentsListQuery(page);
                                        }).toList(),
                                      ),
                                    )
                                  : CupertinoActivityIndicator(),
                            )
                          : Container(),
                      currentTap == 3
                          ? Flexible(
                              child: !isRefreshing
                                  ? NotificationListener(
                                      onNotification: onBookmarkNotification,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: bookmarkPages.map((page) {
                                          return mypageBookmarksListQuery(page);
                                        }).toList(),
                                      ),
                                    )
                                  : CupertinoActivityIndicator(),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              drawer: MenuDrawer(customerId: customerId),
            ))
        : SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 0,
                elevation: 0,
                backgroundColor: Colors.black,
                brightness: Brightness.dark,
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

  Query mypageContentsListQuery(int page) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageContentsList),
          variables: {"customer_id": customerId, "page": page},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            // print("🚨 mypageContentsList : $result");
            List resultData = result.data["mypage_contents_list"];

            return Wrap(
                spacing: ScreenUtil().setSp(1),
                runSpacing: ScreenUtil().setSp(1),
                direction: Axis.horizontal,
                children: resultData.map((item) {
                  List imageLink = item["image_link"].split(",");
                  return InkWell(
                    onTap: () {
                      Get.to(() => PlaceDetailScreen(
                            contentsId: item["contents_id"],
                            customerId: customerId,
                          ));
                    },
                    child: Container(
                      width:
                          ScreenUtil().screenWidth / 3 - ScreenUtil().setSp(2),
                      height:
                          ScreenUtil().screenWidth / 3 - ScreenUtil().setSp(2),
                      child: Image.network(
                        imageLink[0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CupertinoActivityIndicator();
                        },
                      ),
                    ),
                  );
                }).toList());
          } else {
            return Container();
          }
        });
  }

  Query mypageComentsListQuery(int page) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageComentsList),
          variables: {"customer_id": customerId, "page": page},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            // print("🚨 bookmarkslist : $result");
            List resultData = result.data["mypage_coments_list"];

            return commentsListContainer(resultData);
          } else {
            return Container();
          }
        });
  }

  Container commentsListContainer(List<dynamic> resultData) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20), vertical: ScreenUtil().setSp(10)),
      child: Wrap(
          children: resultData.map((item) {
        int index = resultData.indexOf(item);
        String commentsText = resultData[index]["coment_text"];
        String mainText = resultData[index]["main_text"];

        return InkWell(
            onTap: () {
              seeValue("customerId").then((customerId) {
                Get.to(() => PlaceDetailScreen(
                      contentsId: resultData[index]["contents_id"],
                      customerId: int.parse(customerId),
                    ));
              });
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().setSp(10)),
                  Text(commentsText,
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small))),
                  SizedBox(height: ScreenUtil().setSp(6)),
                  Text(mainText,
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small),
                          color: app_font_grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  SizedBox(height: ScreenUtil().setSp(10)),
                  Container(
                    color: app_grey_light,
                    height: ScreenUtil().setSp(2),
                  ),
                ],
              ),
            ));
      }).toList()),
    );
  }

  Query mypageBookmarksListQuery(int page) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageBookmarksList),
          variables: {"customer_id": customerId, "page": page},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            List resultData = result.data["mypage_bookmarks_list"];
            print("🚨 bookmarkslist : ${resultData.length}");
            return Wrap(
                spacing: ScreenUtil().setSp(1),
                runSpacing: ScreenUtil().setSp(1),
                direction: Axis.horizontal,
                children: resultData.map((item) {
                  List imageLink = item["image_link"].split(",");
                  return InkWell(
                    onTap: () {
                      Get.to(() => PlaceDetailScreen(
                            contentsId: item["contents_id"],
                            customerId: customerId,
                          ));
                    },
                    child: Container(
                      width:
                          ScreenUtil().screenWidth / 3 - ScreenUtil().setSp(2),
                      height:
                          ScreenUtil().screenWidth / 3 - ScreenUtil().setSp(2),
                      child: Image.network(
                        imageLink[0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CupertinoActivityIndicator();
                        },
                      ),
                    ),
                  );
                }).toList());
          } else {
            return Container();
          }
        });
  }

  Query mypageCountQuery() {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageCount),
          variables: {"customer_id": customerId},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["mypage_count"];
            int contentsCount = resultData["contents_count"];
            int bookmarksCount = resultData["bookmarks_count"];
            int comentsCount = resultData["coments_count"];
            return mypageCountContainer(
                contentsCount, comentsCount, bookmarksCount, false);
          } else {
            return Container();
          }
        });
  }

  Container mypageCountContainer(int contentsCount, int comentsCount,
      int bookmarksCount, bool isRefreshing) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  currentTap = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("내가 쓴 글",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small))),
                  !isRefreshing
                      ? Text("$contentsCount",
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing)))
                      : CupertinoActivityIndicator(),
                  SizedBox(height: ScreenUtil().setSp(4)),
                  Container(
                      color:
                          currentTap == 1 ? Colors.black : Colors.transparent,
                      width: ScreenUtil().setSp(30),
                      height: ScreenUtil().setSp(4))
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  currentTap = 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("남긴 댓글",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small))),
                  !isRefreshing
                      ? Text("$comentsCount",
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing)))
                      : CupertinoActivityIndicator(),
                  SizedBox(height: ScreenUtil().setSp(4)),
                  Container(
                      color:
                          currentTap == 2 ? Colors.black : Colors.transparent,
                      width: ScreenUtil().setSp(30),
                      height: ScreenUtil().setSp(4))
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  currentTap = 3;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("보관함",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small))),
                  !isRefreshing
                      ? Text("$bookmarksCount",
                          style: TextStyle(
                              fontFamily: "NotoSansCJKkrBold",
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing)))
                      : CupertinoActivityIndicator(),
                  SizedBox(height: ScreenUtil().setSp(4)),
                  Container(
                      color:
                          currentTap == 3 ? Colors.black : Colors.transparent,
                      width: ScreenUtil().setSp(30),
                      height: ScreenUtil().setSp(4))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Query mypageQuery() {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypage),
          variables: {"customer_id": customerId},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            Map resultData = result.data["mypage"][0];
            // print("🚨 mypage result : $resultData");
            String nickname = resultData["nick_name"];
            String profilePhotoLink = resultData["profile_photo_link"];
            String profileText = resultData["profile_text"];
            // int point = resultData["point"];
            // int language = resultData["language"];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: ScreenUtil().setSp(70),
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setSp(70),
                        height: ScreenUtil().setSp(70),
                        decoration: profilePhotoLink == null
                            ? BoxDecoration(
                                color: app_grey,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(100)),
                              )
                            : BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(profilePhotoLink)),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(100)),
                              ),
                      ),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nickname,
                              style: TextStyle(
                                  fontFamily: "NotoSansCJKkrBold",
                                  fontSize: ScreenUtil().setSp(16),
                                  letterSpacing:
                                      ScreenUtil().setSp(letter_spacing)),
                              overflow: TextOverflow.fade,
                              maxLines: 1),
                          SizedBox(height: ScreenUtil().setSp(5)),
                          InkWell(
                            onTap: () {
                              Get.to(() => ProfileEditScreen(
                                  customerId: customerId,
                                  callbackRefetch: () => refetch()));
                            },
                            child: Text("프로필 편집",
                                style: TextStyle(
                                    fontFamily: "NotoSansCJKkrRegular",
                                    fontSize: ScreenUtil().setSp(14),
                                    color: app_font_grey,
                                    letterSpacing: ScreenUtil()
                                        .setSp(letter_spacing_small))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                profileText.length > 0
                    ? SizedBox(height: ScreenUtil().setSp(10))
                    : Container(),
                profileText.length > 0
                    ? ReadMoreText(profileText,
                        trimLines: 2,
                        colorClickableText: app_font_grey,
                        style: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small),
                          color: Colors.black,
                        ),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '더보기',
                        trimExpandedText: '접기',
                        moreStyle: TextStyle(
                          fontFamily: "NotoSansCJKkrRegular",
                          fontSize: ScreenUtil().setSp(14),
                          letterSpacing:
                              ScreenUtil().setSp(letter_spacing_small),
                          color: app_font_grey,
                        ))
                    : Container()
              ],
            );
          } else {
            return Container();
          }
        });
  }
}

class RefreshIndicator extends StatelessWidget {
  final bool isRefreshing;
  const RefreshIndicator({Key key, @required this.isRefreshing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRefreshing
        ? Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().setSp(42),
            child: Center(
              child: CupertinoActivityIndicator(),
            ))
        : Container();
  }
}
