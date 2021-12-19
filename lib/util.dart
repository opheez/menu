import 'package:flutter/material.dart';

String formatDate(DateTime selectedDate) {
  return "${indexToDay[selectedDate.weekday]}  ${selectedDate.year.toString()}-"
      "${selectedDate.month.toString().padLeft(2, '0')}-"
      "${selectedDate.day.toString().padLeft(2, '0')}";
}

DateTime dateTimeToDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

int getDayIdx(DateTime date) {
  DateTime today = dateTimeToDate(DateTime.now());
  date = dateTimeToDate(date);
  return 6 - today.difference(date).inDays;
}

DateTime idxToDay(DateTime date, int idx) {
  DateTime day = dateTimeToDate(date);
  return day.subtract(Duration(days: 6 - idx));
}

double convertToMetric(String entryType, double val, {bool reverse = false}) {
  if (entryType == 'height') {
    return reverse ? val / 2.54 : (val * 2.54);
  } else if (entryType == 'weight') {
    return reverse ? val * 2.205 : (val / 2.205);
  }
  return 0;
}

Map indexToDay = {
  1: "Mon",
  2: "Tues",
  3: "Wed",
  4: "Thurs",
  5: "Fri",
  6: "Sat",
  7: "Sun"
};

class RowWrapper extends StatelessWidget {
  final Widget child;
  double heightPercent;
  double paddingPercent;

  RowWrapper({
    required this.child,
    this.heightPercent = 0.093,
    this.paddingPercent = 0.02,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: heightPercent * size.height,
        color: Colors.grey[100],
        padding: EdgeInsets.all(size.height * this.paddingPercent),
        margin: EdgeInsets.all(size.height * 0.001),
        child: child);
  }
}
