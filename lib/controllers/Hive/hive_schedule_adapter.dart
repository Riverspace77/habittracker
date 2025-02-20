import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:habitui/models/schedule.dart';

part 'hive_schedule_adapter.g.dart';

@HiveType(typeId: 0)
class HiveSchedule extends HiveObject {
  @HiveField(0)
  Scheduleset setting;

  @HiveField(1)
  String title;

  @HiveField(2)
  int iconCodePoint; // IconData는 직접 저장 불가능 → 코드포인트로 저장

  @HiveField(3)
  String description;

  @HiveField(4)
  ScheduleType type;

  @HiveField(5)
  TimeOfDay time;

  @HiveField(6)
  int colorValue; // Color 저장용

  @HiveField(7)
  List<String> reminders;

  @HiveField(8)
  DateTime scheduleStart;

  @HiveField(9)
  DateTime scheduleEnd;

  @HiveField(10)
  RepeatType repeatType;

  @HiveField(11)
  Period? period;

  @HiveField(12)
  int? count;

  @HiveField(13)
  List<String>? weekdays;

  @HiveField(14)
  int? interval;

  HiveSchedule({
    required this.setting,
    required this.title,
    required this.iconCodePoint,
    required this.description,
    required this.type,
    required this.time,
    required this.colorValue,
    required this.reminders,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.repeatType,
    this.period,
    this.count,
    this.weekdays,
    this.interval,
  });

  // Schedule 모델을 HiveSchedule로 변환하는 메서드
  factory HiveSchedule.fromSchedule(Schedule schedule) {
    return HiveSchedule(
      setting: schedule.setting,
      title: schedule.title,
      iconCodePoint: schedule.icon.icon!.codePoint, // IconData → 정수 변환
      description: schedule.description,
      type: schedule.type,
      time: schedule.time,
      colorValue: schedule.color.value, // Color → int 변환
      reminders: schedule.reminders,
      scheduleStart: schedule.scheduleStart,
      scheduleEnd: schedule.scheduleEnd,
      repeatType: schedule.repeatType,
      period: schedule.period,
      count: schedule.count,
      weekdays: schedule.weekdays,
      interval: schedule.interval,
    );
  }

  // HiveSchedule을 다시 Schedule로 변환하는 메서드
  Schedule toSchedule() {
    return Schedule(
      setting: setting,
      title: title,
      icon: Icon(IconData(iconCodePoint, fontFamily: 'MaterialIcons')),
      description: description,
      type: type,
      time: time,
      color: Color(colorValue),
      reminders: reminders,
      scheduleStart: scheduleStart,
      scheduleEnd: scheduleEnd,
      repeatType: repeatType,
      period: period,
      count: count,
      weekdays: weekdays,
      interval: interval,
    );
  }
}
