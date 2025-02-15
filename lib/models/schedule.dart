import 'package:flutter/material.dart';

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
  List<String> repeat;
  DateTime schedule_start;
  DateTime schedule_end;

  Schedule({
    required this.setting,
    required this.title,
    required this.icon,
    required this.description,
    required this.type,
    required this.time,
    required this.color,
    required this.reminders,
    required this.repeat,
    required this.schedule_start,
    required this.schedule_end,
  });
}
