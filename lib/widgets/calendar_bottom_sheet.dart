import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({Key key}) : super(key: key);

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  // String _selectedDate = '';
  // String _dateCount = '';
  // String _range = '';
  // String _rangeCount = '';

  bool isWhole = false;
  String leftDate = "";
  String rightDate = "";

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        leftDate =
            DateFormat('yyyy.MM.dd').format(args.value.startDate).toString();
        rightDate = DateFormat('yyyy.MM.dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
      }
      // else if (args.value is DateTime) {
      //   _selectedDate = args.value.toString();
      //   print("🚨 _selectedDate : $_selectedDate");
      // } else if (args.value is List<DateTime>) {
      //   _dateCount = args.value.length.toString();
      //   print("🚨 _dateCount : $_dateCount");
      // } else {
      //   _rangeCount = args.value.length.toString();
      //   print("🚨 _rangeCount : $_rangeCount");
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().setSp(640),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(40)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "게시물 설정",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: -0.4,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "적용",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      letterSpacing: -0.4,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(32)),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isWhole = true;
                    });
                  },
                  child: Row(
                    children: [
                      isWhole ? checkedButton() : nonCheckedButton(),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Text(
                        "전체 기간",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: -0.4,
                            color: isWhole ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(14)),
                InkWell(
                  onTap: () {
                    setState(() {
                      isWhole = false;
                    });
                  },
                  child: Row(
                    children: [
                      !isWhole ? checkedButton() : nonCheckedButton(),
                      SizedBox(width: ScreenUtil().setSp(10)),
                      Text(
                        "원하는 기간 게시물만 모아보기",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: -0.4,
                            color: !isWhole ? Colors.black : Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // SizedBox(height: ScreenUtil().setHeight(14)),
          Spacer(),
          !isWhole
              ? Row(
                  children: [
                    SizedBox(width: ScreenUtil().setSp(20)),
                    rangeTag("일주일"),
                    Spacer(),
                    rangeTag("1개월"),
                    Spacer(),
                    rangeTag("3개월"),
                    Spacer(),
                    rangeTag("6개월"),
                    SizedBox(width: ScreenUtil().setSp(20)),
                  ],
                )
              : Container(),
          // SizedBox(height: ScreenUtil().setHeight(14)),
          Spacer(),
          !isWhole
              ? Row(
                  children: [
                    SizedBox(width: ScreenUtil().setSp(30)),
                    selectedDate("leftDate"),
                    Spacer(),
                    Text("~",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          letterSpacing: -0.45,
                        )),
                    Spacer(),
                    selectedDate("rightDate"),
                    SizedBox(width: ScreenUtil().setSp(30)),
                  ],
                )
              : Container(),
          Spacer(),
          !isWhole
              ? Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(34)),
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    todayHighlightColor: Colors.transparent,
                    startRangeSelectionColor: app_blue_calendar,
                    headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(18),
                          letterSpacing: -0.45,
                          fontWeight: FontWeight.bold,
                        )),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(16),
                                letterSpacing: -0.4))),
                    selectionTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4),
                    rangeTextStyle: TextStyle(
                        color: app_blue,
                        fontSize: ScreenUtil().setSp(16),
                        letterSpacing: -0.4),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(16),
                          letterSpacing: -0.4),
                      todayTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(16),
                          letterSpacing: -0.4),
                    ),
                  ),
                )
              : Container(),
          Spacer(),
          Spacer(),
        ],
      ),
    ));
  }

  Container selectedDate(String title) {
    return Container(
      width: ScreenUtil().setSp(140),
      height: ScreenUtil().setSp(40),
      decoration: BoxDecoration(
        border: Border.all(
            width: ScreenUtil().setSp(1),
            color: title == "leftDate" ? Colors.grey : Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title == "leftDate" ? leftDate : rightDate,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: -0.4,
          ),
        ),
      ),
    );
  }

  Container rangeTag(String title) {
    return Container(
      width: ScreenUtil().setSp(74),
      height: ScreenUtil().setSp(28),
      decoration: BoxDecoration(
          color: app_grey_tag, borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(12),
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }

  Container nonCheckedButton() {
    return Container(
      width: ScreenUtil().setSp(30),
      height: ScreenUtil().setSp(30),
      decoration: BoxDecoration(
        border: Border.all(width: ScreenUtil().setSp(1), color: Colors.grey),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Container checkedButton() {
    return Container(
      width: ScreenUtil().setSp(30),
      height: ScreenUtil().setSp(30),
      decoration: BoxDecoration(
        border: Border.all(width: ScreenUtil().setSp(1), color: Colors.black),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: app_blue,
          border: Border.all(width: ScreenUtil().setSp(6), color: Colors.white),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
