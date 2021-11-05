import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/widgets/loading_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';

class PlaceDetailAdScreen extends StatefulWidget {
  final Map mapData;
  const PlaceDetailAdScreen({Key key, @required this.mapData})
      : super(key: key);

  @override
  _PlaceDetailAdScreenState createState() => _PlaceDetailAdScreenState();
}

class _PlaceDetailAdScreenState extends State<PlaceDetailAdScreen> {
  int currentIndex = 1;
  List imageLink;
  String mainText;
  String locationLink;

  onPageChanged() {}

  @override
  void initState() {
    setState(() {
      imageLink = widget.mapData["imageLink"];
      mainText = widget.mapData["mainText"];
      locationLink = widget.mapData["locationLink"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setWidth(375),
                height: ScreenUtil().setHeight(44),
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
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
                      "게시물",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(appbar_title_size),
                          fontWeight: FontWeight.bold),
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
              Stack(
                children: [
                  Positioned(
                    child: CarouselSlider(
                        items: imageLink.map((url) {
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              "$currentIndex/${imageLink.length}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(12)),
                            ),
                          )),
                    ),
                  )
                ],
              ),
              SizedBox(height: ScreenUtil().setSp(14)),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Container(
                        decoration: BoxDecoration(
                            color: app_grey,
                            borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(14),
                          vertical: ScreenUtil().setSp(6),
                        ),
                        child: Text(
                          mainText,
                          style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                        )),
                    SizedBox(height: ScreenUtil().setHeight(10)),
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
                    SizedBox(height: ScreenUtil().setSp(20)),
                    SizedBox(height: ScreenUtil().setSp(50)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}