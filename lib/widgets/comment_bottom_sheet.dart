import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:letsgotrip/constants/common_value.dart';

class CommentBottomSheet extends StatefulWidget {
  const CommentBottomSheet({Key key}) : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool isLeft = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight * 0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setSp(30)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("댓글 333",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text("닫기",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: ScreenUtil().setSp(10)),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLeft = true;
                        });
                      },
                      child: Text("등록순",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing: -0.35,
                              color: isLeft ? Colors.black : app_font_grey,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: ScreenUtil().setSp(10)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLeft = false;
                        });
                      },
                      child: Text("최신순",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              letterSpacing: -0.35,
                              color: !isLeft ? Colors.black : app_font_grey,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Query(options: options, builder: builder),
          commentForm(null, "nickname", "date", "content")
        ],
      ),
    );
  }

  Column commentForm(
      String photo, String nickname, String date, String content) {
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setSp(20)),
        Container(
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil().setSp(35),
                height: ScreenUtil().setSp(35),
                decoration: photo == null
                    ? BoxDecoration(
                        color: app_grey,
                        borderRadius: BorderRadius.circular(50))
                    : BoxDecoration(
                        image: DecorationImage(image: NetworkImage(photo)),
                        borderRadius: BorderRadius.circular(50)),
              ),
              SizedBox(width: ScreenUtil().setSp(6)),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ScreenUtil().setSp(3)),
                      Row(
                        children: [
                          Text(
                            nickname,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing: -0.35,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: ScreenUtil().setSp(10)),
                          Expanded(
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                letterSpacing: -0.35,
                                color: app_font_grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setSp(3)),
                      Text(
                        content,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            letterSpacing: -0.35),
                      ),
                      SizedBox(height: ScreenUtil().setSp(3)),
                      Text(
                        "답글 달기",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            color: app_font_grey,
                            letterSpacing: -0.3),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset("assets/images/comment_toggle_button.png",
                  width: ScreenUtil().setSp(28), height: ScreenUtil().setSp(28))
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setSp(20)),
        Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setSp(1),
          color: app_grey,
        )
      ],
    );
  }
}
