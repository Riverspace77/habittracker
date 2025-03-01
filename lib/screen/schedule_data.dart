import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habitui/models/schedule.dart';

var tempSchedule = Schedule(
  setting: Scheduleset.check,
  title: "dslfkj",
  icon: const Icon(Icons.star),
  description:
      "holalalaariouh;awjflkwejgvlwejngvlwrpowpbkvpawbKMKLEQRHIQERHJGVOPWJFPOUF9G0WEUJFGOKLEJFGKQEHGIUQEHFGKLQJNGFKLYGOIWEJNFGWEKNGKWEHGOEWRJ",
  type: ScheduleType.make,
  time: const TimeOfDay(hour: 6, minute: 0),
  color: Colors.blue,
  reminders: [],
  scheduleStart: DateTime.now(),
  scheduleEnd: DateTime.now().add(const Duration(days: 30)),
  repeatType: RepeatType.weekday,
  period: Period.weak, // 기본값 설정
).obs; // 일정 생성 중 임시 저장 객체
