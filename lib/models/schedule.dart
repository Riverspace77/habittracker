import 'package:flutter/material.dart';

enum ScheduleType { daily, weekly, monthly }

class Schedule {
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
