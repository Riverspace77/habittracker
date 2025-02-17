import 'package:flutter/material.dart';

// 반복 유형을 정의하는 Enum
enum RepeatType {
  multipleweek, // 주당 여러 번
  multiple, // 연, 월당 여러 번
  weekday, // 요일 지정
  intervalDay, // 몇 일마다
  intervalWeek // 몇 주마다
}

enum Period { weak, month, year }

enum ScheduleType { make, off }

enum Scheduleset { count, time, check }

class Schedule {
  Scheduleset setting;
  String title;
  Icon icon;
  String description;
  ScheduleType type;
  TimeOfDay time;
  Color color;
  List<String> reminders;
  DateTime scheduleStart;
  DateTime scheduleEnd;
  RepeatType repeatType;

  Period? period;
  int? count;
  List<String>? weekdays;
  int? interval;

  // 수행 진행도 저장
  Map<DateTime, int>? countProgress;
  Map<DateTime, double>? timeProgress;
  Map<DateTime, bool>? checkProgress;

  Schedule({
    required this.setting,
    required this.title,
    required this.icon,
    required this.description,
    required this.type,
    required this.time,
    required this.color,
    required this.reminders,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.repeatType,
    this.period,
    this.count,
    this.weekdays,
    this.interval,
    Map<DateTime, int>? countProgress,
    Map<DateTime, double>? timeProgress,
    Map<DateTime, bool>? checkProgress,
  }) {
    this.countProgress = countProgress ?? {};
    this.timeProgress = timeProgress ?? {};
    this.checkProgress = checkProgress ?? {};
    _setDefaultValues();
  }

  void _setDefaultValues() {
    switch (repeatType) {
      case RepeatType.multipleweek:
      case RepeatType.multiple:
        period ??= Period.weak;
        count ??= 1;
        break;
      case RepeatType.weekday:
        weekdays ??= ['월'];
        break;
      case RepeatType.intervalDay:
      case RepeatType.intervalWeek:
        interval ??= 1;
        break;
    }
  }

  List<DateTime> getOccurrences() {
    List<DateTime> occurrences = [];
    DateTime current = scheduleStart;

    while (current.isBefore(scheduleEnd) ||
        current.isAtSameMomentAs(scheduleEnd)) {
      switch (repeatType) {
        case RepeatType.multipleweek:
        case RepeatType.multiple:
          occurrences.add(current);
          break;
        case RepeatType.weekday:
          if (weekdays != null &&
              weekdays!.contains(_getWeekdayName(current))) {
            occurrences.add(current);
          }
          break;
        case RepeatType.intervalDay:
          occurrences.add(current);
          current = current.add(Duration(days: interval ?? 1));
          continue;
        case RepeatType.intervalWeek:
          occurrences.add(current);
          current = current.add(Duration(days: (interval ?? 1) * 7));
          continue;
      }
      current = current.add(Duration(days: 1));
    }
    return occurrences;
  }

  String _getWeekdayName(DateTime date) {
    return ["월", "화", "수", "목", "금", "토", "일"][date.weekday - 1];
  }

  dynamic getProgress(DateTime date) {
    switch (setting) {
      case Scheduleset.count:
        return countProgress?[date] ?? 0;
      case Scheduleset.time:
        return timeProgress?[date] ?? 0.0;
      case Scheduleset.check:
        return checkProgress?[date] ?? false;
    }
  }

  void updateProgress(DateTime date, dynamic value) {
    switch (setting) {
      case Scheduleset.count:
        if (value is int) countProgress?[date] = value;
        break;
      case Scheduleset.time:
        if (value is double) timeProgress?[date] = value;
        break;
      case Scheduleset.check:
        if (value is bool) checkProgress?[date] = value;
        break;
    }
  }
}
