import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:letsgotrip/_Controller/floating_button_controller.dart';
import 'package:letsgotrip/constants/common_value.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarBottomSheet extends StatefulWidget {
  final Function refetchCallback;
  const CalendarBottomSheet({Key key, @required this.refetchCallback})
      : super(key: key);

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  FloatingButtonController calendarController =
      Get.put(FloatingButtonController());
  int selectedDateRange = 0;

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
      selectedDateRange = 0;
    });
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: true,
        child: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight * 0.9 -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setSp(20)),
                  topRight: Radius.circular(ScreenUtil().setSp(20)))),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setSp(40)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20)),
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
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: ScreenUtil().setSp(letter_spacing)),
                      ),
                    ),
                    Text(
                      "게시물 설정",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkrBold",
                          fontSize: ScreenUtil().setSp(16),
                          letterSpacing: ScreenUtil().setSp(letter_spacing)),
                    ),
                    InkWell(
                      onTap: () {
                        if (isWhole || leftDate == "") {
                          calendarController.dateUpdate(
                              "2021.01.01", "3021.09.23");
                        } else {
                          calendarController.dateUpdate(leftDate, rightDate);
                        }
                        widget.refetchCallback();
                        Get.back();
                      },
                      child: Text(
                        "적용",
                        style: TextStyle(
                            color: (!isWhole && leftDate == "")
                                ? app_font_grey
                                : Colors.black,
                            fontFamily: "NotoSansCJKkrBold",
                            fontSize: ScreenUtil().setSp(16),
                            letterSpacing: ScreenUtil().setSp(letter_spacing)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setSp(30)),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(32)),
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
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(16),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                                color: isWhole ? Colors.black : Colors.grey),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setSp(14)),
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
                                fontFamily: "NotoSansCJKkrRegular",
                                fontSize: ScreenUtil().setSp(16),
                                letterSpacing:
                                    ScreenUtil().setSp(letter_spacing),
                                color: !isWhole ? Colors.black : Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(height: ScreenUtil().setSp(14)),
              Spacer(),
              !isWhole
                  ? Row(
                      children: [
                        SizedBox(width: ScreenUtil().setSp(20)),
                        rangeTag("일주일", 7),
                        Spacer(),
                        rangeTag("1개월", 30),
                        Spacer(),
                        rangeTag("3개월", 90),
                        Spacer(),
                        rangeTag("6개월", 180),
                        SizedBox(width: ScreenUtil().setSp(20)),
                      ],
                    )
                  : Container(),
              // SizedBox(height: ScreenUtil().setSp(14)),
              Spacer(),
              !isWhole
                  ? Row(
                      children: [
                        SizedBox(width: ScreenUtil().setSp(30)),
                        selectedDate("leftDate"),
                        Spacer(),
                        Text("~",
                            style: TextStyle(
                              fontFamily: "NotoSansCJKkrRegular",
                              fontSize: ScreenUtil().setSp(18),
                              letterSpacing:
                                  ScreenUtil().setSp(letter_spacing_big),
                            )),
                        Spacer(),
                        selectedDate("rightDate"),
                        SizedBox(width: ScreenUtil().setSp(30)),
                      ],
                    )
                  : Container(),
              Spacer(),
              if (!isWhole)
                Column(
                  children: [
                    selectedDateRange == 0 ? calendar(0) : Container(),
                    selectedDateRange == 7 ? calendar(7) : Container(),
                    selectedDateRange == 30 ? calendar(30) : Container(),
                    selectedDateRange == 90 ? calendar(90) : Container(),
                    selectedDateRange == 180 ? calendar(180) : Container(),
                  ],
                )
              else
                Container(),
              Spacer(),
              Spacer(),
            ],
          ),
        ));
  }

  Container calendar(int rangeDate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(34)),
      height: ScreenUtil().setSp(292),
      child: SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        todayHighlightColor: Colors.transparent,
        startRangeSelectionColor: app_blue_calendar,
        headerHeight: ScreenUtil().setSp(60),
        headerStyle: DateRangePickerHeaderStyle(
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontFamily: "NotoSansCJKkrBold",
              color: Colors.black,
              fontSize: ScreenUtil().setSp(18),
              letterSpacing: ScreenUtil().setSp(letter_spacing_big),
              fontWeight: FontWeight.bold,
            )),
        monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                textStyle: TextStyle(
                    fontFamily: "NotoSansCJKkrRegular",
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(16),
                    letterSpacing: ScreenUtil().setSp(letter_spacing)))),
        selectionTextStyle: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: ScreenUtil().setSp(letter_spacing)),
        rangeTextStyle: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            color: app_blue,
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: ScreenUtil().setSp(letter_spacing)),
        monthCellStyle: DateRangePickerMonthCellStyle(
          textStyle: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              color: Colors.black,
              fontSize: ScreenUtil().setSp(16),
              letterSpacing: ScreenUtil().setSp(letter_spacing)),
          todayTextStyle: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              color: Colors.black,
              fontSize: ScreenUtil().setSp(16),
              letterSpacing: ScreenUtil().setSp(letter_spacing)),
        ),
        initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(Duration(days: rangeDate)),
            DateTime.now().add(Duration(days: 0))),
      ),
    );
  }

  Container selectedDate(String title) {
    return Container(
      width: ScreenUtil().setWidth(140),
      height: ScreenUtil().setSp(40),
      decoration: BoxDecoration(
        border: Border.all(
            width: ScreenUtil().setSp(1),
            color: title == "leftDate"
                ? leftDate == ""
                    ? Colors.grey
                    : Colors.black
                : rightDate == ""
                    ? Colors.grey
                    : Colors.black),
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
      ),
      child: Center(
        child: Text(
          title == "leftDate" ? leftDate : rightDate,
          style: TextStyle(
            fontFamily: "NotoSansCJKkrRegular",
            fontSize: ScreenUtil().setSp(16),
            letterSpacing: ScreenUtil().setSp(letter_spacing),
          ),
        ),
      ),
    );
  }

  InkWell rangeTag(String title, int selectedDate) {
    return InkWell(
      onTap: () {
        switch (title) {
          case "일주일":
            setState(() {
              selectedDateRange = 7;
            });
            break;
          case "1개월":
            setState(() {
              selectedDateRange = 30;
            });
            break;
          case "3개월":
            setState(() {
              selectedDateRange = 90;
            });
            break;
          case "6개월":
            setState(() {
              selectedDateRange = 180;
            });
            break;
          default:
        }
        setState(() {
          leftDate = DateFormat('yyyy.MM.dd')
              .format(DateTime.now().subtract(Duration(days: selectedDate)))
              .toString();
          rightDate = DateFormat('yyyy.MM.dd')
              .format(DateTime.now().add(Duration(days: 0)))
              .toString();
        });
      },
      child: Container(
        width: ScreenUtil().setWidth(74),
        height: ScreenUtil().setSp(28),
        decoration: BoxDecoration(
          color: selectedDate == selectedDateRange ? app_blue : app_grey_tag,
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(100)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "NotoSansCJKkrRegular",
              color: selectedDate == selectedDateRange
                  ? Colors.white
                  : Colors.black,
              fontSize: ScreenUtil().setSp(12),
              letterSpacing: ScreenUtil().setSp(letter_spacing_x_small),
            ),
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
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(100)),
      ),
    );
  }

  Container checkedButton() {
    return Container(
      width: ScreenUtil().setSp(30),
      height: ScreenUtil().setSp(30),
      decoration: BoxDecoration(
        border: Border.all(width: ScreenUtil().setSp(1), color: Colors.black),
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(100)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: app_blue,
          border: Border.all(width: ScreenUtil().setSp(6), color: Colors.white),
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(100)),
        ),
      ),
    );
  }
}
