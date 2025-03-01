import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:habitui/models/schedule.dart';

part 'hive_schedule_adapter.g.dart';

@HiveType(typeId: 0) // ⬅️ 유니크한 typeId 사용
class HiveSchedule extends HiveObject {
  @HiveField(0)
  Scheduleset setting;

  @HiveField(1)
  String title;

  @HiveField(2)
  int iconCodePoint; // IconData는 저장 불가능 → 코드포인트 변환

  @HiveField(3)
  String description;

  @HiveField(4)
  ScheduleType type;

  @HiveField(5)
  int timeHour; // TimeOfDay → int (시간)

  @HiveField(6)
  int timeMinute; // TimeOfDay → int (분)

  @HiveField(7)
  int colorValue; // Color 저장용

  @HiveField(8)
  List<String> reminders;

  @HiveField(9)
  DateTime scheduleStart;

  @HiveField(10)
  DateTime scheduleEnd;

  @HiveField(11)
  RepeatType repeatType;

  @HiveField(12)
  Period? period;

  @HiveField(13)
  int? count;

  @HiveField(14)
  List<String>? weekdays;

  @HiveField(15)
  int? interval;

  // ✅ 진행도 저장
  @HiveField(16)
  Map<String, int>? countProgress;

  @HiveField(17)
  Map<String, double>? timeProgress;

  @HiveField(18)
  Map<String, bool>? checkProgress;

  @HiveField(19)
  Map<String, bool>? completionStatus;

  HiveSchedule({
    required this.setting,
    required this.title,
    required this.iconCodePoint,
    required this.description,
    required this.type,
    required this.timeHour,
    required this.timeMinute,
    required this.colorValue,
    required this.reminders,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.repeatType,
    this.period,
    this.count,
    this.weekdays,
    this.interval,
    this.countProgress,
    this.timeProgress,
    this.checkProgress,
    this.completionStatus,
  });

  // ✅ Schedule → HiveSchedule 변환 메서드
  factory HiveSchedule.fromSchedule(Schedule schedule) {
    return HiveSchedule(
      setting: schedule.setting,
      title: schedule.title,
      iconCodePoint: schedule.icon.icon!.codePoint, // IconData → 정수 변환
      description: schedule.description,
      type: schedule.type,
      timeHour: schedule.time.hour,
      timeMinute: schedule.time.minute,
      colorValue: schedule.color.value, // Color → int 변환
      reminders: schedule.reminders,
      scheduleStart: schedule.scheduleStart,
      scheduleEnd: schedule.scheduleEnd,
      repeatType: schedule.repeatType,
      period: schedule.period,
      count: schedule.count,
      weekdays: schedule.weekdays,
      interval: schedule.interval,
      countProgress: _convertDateTimeMap(schedule.countProgress),
      timeProgress: _convertDateTimeDoubleMap(schedule.timeProgress),
      checkProgress: _convertDateTimeBoolMap(schedule.checkProgress),
      completionStatus: _convertDateTimeBoolMap(schedule.completionStatus),
    );
  }

  // ✅ HiveSchedule → Schedule 변환 메서드
  Schedule toSchedule() {
    return Schedule(
      setting: setting,
      title: title,
      icon: Icon(IconData(iconCodePoint, fontFamily: 'MaterialIcons')),
      description: description,
      type: type,
      time: TimeOfDay(hour: timeHour, minute: timeMinute),
      color: Color(colorValue),
      reminders: reminders,
      scheduleStart: scheduleStart,
      scheduleEnd: scheduleEnd,
      repeatType: repeatType,
      period: period,
      count: count,
      weekdays: weekdays,
      interval: interval,
      countProgress: _convertStringIntMap(countProgress),
      timeProgress: _convertStringDoubleMap(timeProgress),
      checkProgress: _convertStringBoolMap(checkProgress),
      completionStatus: _convertStringBoolMap(completionStatus),
    );
  }

  // ✅ 진행도 데이터 변환 (DateTime → String)
  static Map<String, int>? _convertDateTimeMap(Map<DateTime, int>? input) {
    return input?.map((key, value) => MapEntry(key.toIso8601String(), value));
  }

  static Map<String, double>? _convertDateTimeDoubleMap(
      Map<DateTime, double>? input) {
    return input?.map((key, value) => MapEntry(key.toIso8601String(), value));
  }

  static Map<String, bool>? _convertDateTimeBoolMap(
      Map<DateTime, bool>? input) {
    return input?.map((key, value) => MapEntry(key.toIso8601String(), value));
  }

  // ✅ 진행도 데이터 복원 (String → DateTime)
  static Map<DateTime, int>? _convertStringIntMap(Map<String, int>? input) {
    return input?.map((key, value) => MapEntry(DateTime.parse(key), value));
  }

  static Map<DateTime, double>? _convertStringDoubleMap(
      Map<String, double>? input) {
    return input?.map((key, value) => MapEntry(DateTime.parse(key), value));
  }

  static Map<DateTime, bool>? _convertStringBoolMap(Map<String, bool>? input) {
    return input?.map((key, value) => MapEntry(DateTime.parse(key), value));
  }
}
