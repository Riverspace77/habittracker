import 'package:flutter/material.dart';

// 반복 유형을 정의하는 Enum
enum RepeatType {
  multipleweek, //주당 여러번
  multiple, // 연,월당 여러 번
  weekday, // 요일 지정
  intervalDay, // 몇일마다
  intervalWeek // 몇주마다
}

enum Period { weak, month, year }

// 일정 유형 Enum
enum ScheduleType { make, off }

// 일정 설정 유형 Enum
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

  Period? period; //
  int? count; // 기간당 여러 번의 횟수
  List<String>? weekdays; // 요일 지정
  int? interval; // 몇일마다, 몇주마다 (공용)

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
  }) {
    _setDefaultValues();
  }

  /// `repeatType`에 따라 필요한 변수를 기본값으로 설정
  void _setDefaultValues() {
    switch (repeatType) {
      case RepeatType.multipleweek:
      case RepeatType.multiple:
        period ??= Period.weak;
        count ??= 1;
        break;
      case RepeatType.weekday:
        weekdays ??= ['Monday']; // 기본값: 월요일
        break;
      case RepeatType.intervalDay:
      case RepeatType.intervalWeek:
        interval ??= 1; // 기본값: 1일 또는 1주
        break;
    }
  }
}
