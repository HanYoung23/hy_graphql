import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/graphql_query.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';

class AnnounceDetailScreen extends StatefulWidget {
  final int noticeId;
  const AnnounceDetailScreen({Key key, @required this.noticeId})
      : super(key: key);

  @override
  _AnnounceDetailScreenState createState() => _AnnounceDetailScreenState();
}

class _AnnounceDetailScreenState extends State<AnnounceDetailScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(Queries.notice),
          variables: {"notice_id": widget.noticeId},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (!result.isLoading && result.data != null) {
            print("🚨 notice : $result");

            Map resultData = result.data["notice"][0];

            // int noticeId = resultData["notice_id"];
            String noticeTitle = resultData["notice_title"];
            String imageLinks = resultData["image_link"];
            List imageLink = imageLinks.split(",");
            String noticeText = resultData["notice_text"];
            String date = resultData["regist_date"];
            // String editDate = resultData["edit_date"];
            if (date != null) {
              date = date.substring(0, 10).replaceAll(RegExp(r'-'), ".");
            }
            // int check = resultData["check"];

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil().setSp(20)),
                        Container(
                          width: ScreenUtil().setWidth(375),
                          height: ScreenUtil().setHeight(44),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setSp(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                    "assets/images/arrow_back.png",
                                    width: ScreenUtil().setSp(arrow_back_size),
                                    height:
                                        ScreenUtil().setSp(arrow_back_size)),
                              ),
                              Text(
                                "공지사항",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil().setSp(appbar_title_size),
                                    letterSpacing: -0.4,
                                    fontWeight: appbar_title_weight),
                              ),
                              Image.asset("assets/images/arrow_back.png",
                                  color: Colors.transparent,
                                  width: ScreenUtil().setSp(arrow_back_size),
                                  height: ScreenUtil().setSp(arrow_back_size)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              // color: check == 1 ? app_blue_light : Colors.white,
                              color: Colors.white,
                              width: ScreenUtil().screenWidth,
                              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: ScreenUtil().setSp(4)),
                                  Text(
                                    noticeTitle,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(16),
                                        letterSpacing: -0.4),
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: ScreenUtil().setSp(6)),
                                  date != null
                                      ? Text(date,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(14),
                                              color: app_font_grey,
                                              letterSpacing: -0.35))
                                      : Text("null",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(14),
                                              color: app_font_grey,
                                              letterSpacing: -0.35)),
                                  SizedBox(height: ScreenUtil().setSp(4)),
                                ],
                              ),
                            ),
                            Container(
                              color: app_grey,
                              height: ScreenUtil().setSp(1),
                            ),
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
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
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
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setSp(100)),
                                        ),
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
                            Container(
                              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                noticeText,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  letterSpacing: -0.35,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
