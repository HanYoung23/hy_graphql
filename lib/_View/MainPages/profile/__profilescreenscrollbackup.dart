import 'package:cached_network_image/cached_network_image.dart';
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
  List pages = [1];

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
            child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
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
                                          scaffoldKey.currentState.openDrawer();
                                        },
                                        child: Image.asset(
                                            "assets/images/hamburger_button.png",
                                            width: ScreenUtil().setSp(28),
                                            height: ScreenUtil().setSp(28))),
                                  ),
                                ),
                                Text(
                                  "마이페이지",
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil().setSp(appbar_title_size),
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/hamburger_button.png",
                                    width: ScreenUtil().setSp(28),
                                    height: ScreenUtil().setSp(28),
                                    color: Colors.transparent,
                                  ),
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
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.4),
                          ),
                          SizedBox(height: ScreenUtil().setSp(10)),
                          mypageCountQuery(),
                          SizedBox(height: ScreenUtil().setSp(10)),
                        ],
                      ),
                    ),
                    Container(
                      color: app_grey_light,
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setSp(10),
                    ),
                    currentTap == 1 ? mypageContentsListQuery() : Container(),
                    currentTap == 2 ? mypageComentsListQuery() : Container(),
                    currentTap == 3
                        ? Expanded(
                            child: Column(
                              children: pages.map((page) {
                                return mypageBookmarksListQuery(page);
                              }).toList(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            drawer: MenuDrawer(customerId: customerId),
          ))
        : SafeArea(
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

  Query mypageContentsListQuery() {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageContentsList),
          variables: {"customer_id": customerId, "page": 1},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            // print("🚨 mypageContentsList : $result");
            List resultData = result.data["mypage_contents_list"];

            return Expanded(
              child: GridView.builder(
                  itemCount: resultData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: ScreenUtil().setSp(1),
                    crossAxisSpacing: ScreenUtil().setSp(1),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    List imageLink = resultData[index]["image_link"].split(",");

                    return InkWell(
                      onTap: () {
                        // Get.to(() => PlaceDetailScreen(
                        //       contentsId: resultData[index]["contents_id"],
                        //       customerId: customerId,
                        //     ));
                      },
                      // child: Image.network(
                      //   imageLink[0],
                      //   fit: BoxFit.cover,
                      //   loadingBuilder: (context, child, loadingProgress) {
                      //     if (loadingProgress == null) return child;
                      //     return CupertinoActivityIndicator();
                      //   },
                      // ),
                      child: CachedNetworkImage(
                        imageUrl: imageLink[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  Query mypageComentsListQuery() {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageComentsList),
          variables: {"customer_id": customerId, "page": 1},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            // print("🚨 bookmarkslist : $result");
            List resultData = result.data["mypage_coments_list"];

            return Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(20),
                    vertical: ScreenUtil().setSp(10)),
                child: ListView(
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
                                    fontSize: ScreenUtil().setSp(14),
                                    letterSpacing: -0.35)),
                            SizedBox(height: ScreenUtil().setSp(6)),
                            Text(mainText,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    letterSpacing: -0.35,
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
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Query mypageBookmarksListQuery(int page) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.mypageBookmarksList),
          variables: {"customer_id": customerId, "page": 1},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            if (result.data != null) {
              List resultData = result.data["mypage_bookmarks_list"];
              print(customerId);
              print("🚨 bookmarkslist : ${resultData.length}");
              return Expanded(
                child: GridView.builder(
                    itemCount: resultData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: ScreenUtil().setSp(1),
                      crossAxisSpacing: ScreenUtil().setSp(1),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      List imageLink =
                          resultData[index]["image_link"].split(",");

                      return InkWell(
                        onTap: () {
                          // Get.to(() => PlaceDetailScreen(
                          //       contentsId: resultData[index]["contents_id"],
                          //       customerId: customerId,
                          //     ));
                          List newPages = pages;
                          newPages.add(page + 1);
                          setState(() {
                            pages = newPages;
                          });
                        },
                        child: Image.network(
                          imageLink[0],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CupertinoActivityIndicator();
                          },
                        ),
                      );
                    }),
              );
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
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

            return Container(
              height: ScreenUtil().setSp(46),
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
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing: -0.35)),
                          Text("$contentsCount",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4)),
                          Container(
                              color: currentTap == 1
                                  ? Colors.black
                                  : Colors.transparent,
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
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing: -0.35)),
                          Text("$comentsCount",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4)),
                          Container(
                              color: currentTap == 2
                                  ? Colors.black
                                  : Colors.transparent,
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
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing: -0.35)),
                          Text("$bookmarksCount",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4)),
                          Container(
                              color: currentTap == 3
                                  ? Colors.black
                                  : Colors.transparent,
                              width: ScreenUtil().setSp(30),
                              height: ScreenUtil().setSp(4))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
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
                                borderRadius: BorderRadius.circular(100))
                            : BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(profilePhotoLink)),
                                borderRadius: BorderRadius.circular(100)),
                      ),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nickname,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4),
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
                                    fontSize: ScreenUtil().setSp(14),
                                    // fontWeight: FontWeight.bold,
                                    color: app_font_grey,
                                    letterSpacing: -0.35)),
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
