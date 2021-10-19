import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/_View/MainPages/profile/profile_edit_screen.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/storage/storage.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:letsgotrip/widgets/menu_drawer.dart';

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

  @override
  void initState() {
    seeValue("customerId").then((value) {
      print("🚨 id : $value");
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
              document: gql(Queries.mypageCount),
              variables: {"customer_id": customerId},
            ),
            builder: (result, {refetch, fetchMore}) {
              if (!result.isLoading) {
                print("🚨 result : $result");
                Map resultData = result.data["mypage_count"];
                int contentsCount = resultData["contents_count"];
                int boomarksCount = resultData["bookmarks_count"];
                int comentsCount = resultData["coments_count"];

                return SafeArea(
                    child: Scaffold(
                  key: scaffoldKey,
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                            onTap: () {
                                              scaffoldKey.currentState
                                                  .openDrawer();
                                            },
                                            child: Image.asset(
                                                "assets/images/hamburger_button.png",
                                                width: ScreenUtil().setSp(28),
                                                height:
                                                    ScreenUtil().setSp(28))),
                                      ),
                                    ),
                                    Text(
                                      "마이페이지",
                                      style: TextStyle(
                                          fontSize: ScreenUtil()
                                              .setSp(appbar_title_size),
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
                              Container(
                                height: ScreenUtil().setSp(70),
                                child: Row(
                                  children: [
                                    Container(
                                      width: ScreenUtil().setSp(70),
                                      decoration: BoxDecoration(
                                          color: app_grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(width: ScreenUtil().setSp(10)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("nickname",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.4),
                                            overflow: TextOverflow.fade,
                                            maxLines: 1),
                                        SizedBox(height: ScreenUtil().setSp(5)),
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => ProfileEditScreen());
                                          },
                                          child: Text("프로필 편집",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  // fontWeight: FontWeight.bold,
                                                  color: app_font_grey,
                                                  letterSpacing: -0.35)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              Text(
                                "data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data data",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    letterSpacing: -0.35),
                              ),
                              SizedBox(height: ScreenUtil().setSp(20)),
                              Text(
                                "개인활동",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.4),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                              Container(
                                height: ScreenUtil().setSp(46),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("내가 쓴 글",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  letterSpacing: -0.35)),
                                          Text("16",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: -0.4)),
                                          Container(
                                              color: Colors.transparent,
                                              width: ScreenUtil().setSp(30),
                                              height: ScreenUtil().setSp(4))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("남긴 댓글",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  letterSpacing: -0.35)),
                                          Text("2",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: -0.4)),
                                          Container(
                                              color: Colors.transparent,
                                              width: ScreenUtil().setSp(30),
                                              height: ScreenUtil().setSp(4))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("보관함",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  letterSpacing: -0.35)),
                                          Text("26",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: -0.4)),
                                          Container(
                                              color: Colors.black,
                                              width: ScreenUtil().setSp(30),
                                              height: ScreenUtil().setSp(4))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setSp(10)),
                            ],
                          ),
                        ),
                        Container(
                          color: app_grey_light,
                          width: ScreenUtil().screenWidth,
                          height: ScreenUtil().setSp(10),
                        ),
                        Query(
                            options: QueryOptions(
                              document: gql(Queries.mypageBookmarksList),
                              variables: {"customer_id": customerId},
                            ),
                            builder: (result, {refetch, fetchMore}) {
                              if (!result.isLoading) {
                                print("🚨 result : $result");
                                // Map resultData =
                                //     result.data["mypage_bookmarks_list"];
                                if (resultData != []) {
                                  // int bookmarksId = resultData["bookmarks_id"];
                                  // int contentsId = resultData["contents_id"];
                                  // List imageLink = resultData["image_link"];
                                  return Container();
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            }),
                      ],
                    ),
                  ),
                  drawer: MenuDrawer(),
                ));
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
}
