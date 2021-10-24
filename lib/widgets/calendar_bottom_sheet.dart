import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({Key key}) : super(key: key);

  @override
  _CalendarBottomSheetState createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  var _selectedDay;
  var _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight * 0.9,
        color: Colors.white,
        child: TableCalendar(
            locale: 'ko_KO',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yM(locale).format(date),
              titleTextStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  letterSpacing: -0.45,
                  fontWeight: FontWeight.bold),
              leftChevronMargin: EdgeInsets.only(left: ScreenUtil().setSp(100)),
              leftChevronPadding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setSp(12)),
              rightChevronMargin:
                  EdgeInsets.only(right: ScreenUtil().setSp(100)),
              rightChevronPadding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setSp(12)),
            )),
      ),
    );
  }
}
