import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:letsgotrip/functions/material_popup.dart';

class ReportDialogScreen extends StatefulWidget {
  const ReportDialogScreen({
    Key key,
  }) : super(key: key);

  @override
  _ReportDialogScreenState createState() => _ReportDialogScreenState();
}

class _ReportDialogScreenState extends State<ReportDialogScreen> {
  int currentChoice = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setSp(336),
      height: ScreenUtil().setSp(458),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(20),
        vertical: ScreenUtil().setSp(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setSp(10),
          ),
          Spacer(),
          Container(
            child: Text(
              "신고하시는 이유를 알려주세요",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                letterSpacing: -0.4,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.clip,
            ),
          ),
          Spacer(),
          Spacer(),
          choiceFirst("욕설이 포함되어 있어요"),
          choiceSecond("폭력적인 내용이 포함되어 있어요"),
          choiceThird("지속적인 스팸글 또는 도배글이에요"),
          choiceFourth("성적인 콘텐츠가 포함되어 있어요"),
          choiceFifth("기타 사유"),
          Spacer(),
          Spacer(),
          InkWell(
            onTap: () {
              Get.back();
              reportPostDonePopup(context);
            },
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().setSp(44),
              decoration: BoxDecoration(
                color: app_blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "신고하기",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Colors.white,
                    letterSpacing: letter_spacing_small,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setSp(12)),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().setSp(44),
              decoration: BoxDecoration(
                border: Border.all(
                    width: ScreenUtil().setSp(1), color: app_font_grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "취소",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color(0xff191919),
                    letterSpacing: letter_spacing_small,
                  ),
                ),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  InkWell choiceFirst(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          currentChoice = 1;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            currentChoice == 1 ? selectedButton() : unselectedButton(),
            SizedBox(width: ScreenUtil().setSp(12)),
            Text(title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  letterSpacing: letter_spacing_small,
                  color: Color(0xff191919),
                ))
          ],
        ),
      ),
    );
  }

  InkWell choiceSecond(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          currentChoice = 2;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            currentChoice == 2 ? selectedButton() : unselectedButton(),
            SizedBox(width: ScreenUtil().setSp(12)),
            Text(title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  letterSpacing: letter_spacing_small,
                  color: Color(0xff191919),
                ))
          ],
        ),
      ),
    );
  }

  InkWell choiceThird(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          currentChoice = 3;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            currentChoice == 3 ? selectedButton() : unselectedButton(),
            SizedBox(width: ScreenUtil().setSp(12)),
            Text(title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  letterSpacing: letter_spacing_small,
                  color: Color(0xff191919),
                ))
          ],
        ),
      ),
    );
  }

  InkWell choiceFourth(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          currentChoice = 4;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            currentChoice == 4 ? selectedButton() : unselectedButton(),
            SizedBox(width: ScreenUtil().setSp(12)),
            Text(title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  letterSpacing: letter_spacing_small,
                  color: Color(0xff191919),
                ))
          ],
        ),
      ),
    );
  }

  InkWell choiceFifth(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          currentChoice = 5;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            currentChoice == 5 ? selectedButton() : unselectedButton(),
            SizedBox(width: ScreenUtil().setSp(12)),
            Text(title,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  letterSpacing: letter_spacing_small,
                  color: Color(0xff191919),
                ))
          ],
        ),
      ),
    );
  }

  Container unselectedButton() {
    return Container(
      width: ScreenUtil().setSp(30),
      height: ScreenUtil().setSp(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: ScreenUtil().setSp(1), color: app_font_grey),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Container selectedButton() {
    return Container(
      width: ScreenUtil().setSp(30),
      height: ScreenUtil().setSp(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: ScreenUtil().setSp(1), color: Colors.black),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        width: ScreenUtil().setSp(30),
        height: ScreenUtil().setSp(30),
        decoration: BoxDecoration(
          color: app_blue,
          border: Border.all(width: ScreenUtil().setSp(7), color: Colors.white),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
