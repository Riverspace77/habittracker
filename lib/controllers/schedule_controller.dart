import 'package:get/get.dart';
import '../models/schedule.dart';
import 'package:flutter/material.dart';

class ScheduleController extends GetxController {
  var schedules = <Schedule>[].obs; // 여러 개의 일정 저장
  var tempSchedule = Schedule(
    title: "",
    icon: const Icon(Icons.star),
    description: "",
    type: ScheduleType.daily,
    time: const TimeOfDay(hour: 8, minute: 0),
    color: Colors.blue,
    reminders: [],
    repeat: [],
    schedule_start: DateTime.now(),
    schedule_end: DateTime.now().add(const Duration(days: 30)),
  ).obs; // 새 일정 작성 중 임시 저장

  // 일정 제목 업데이트
  void updateTitle(String title) {
    tempSchedule.update((val) {
      val?.title = title;
    });
  }

  // 일정 설명 업데이트
  void updateDescription(String description) {
    tempSchedule.update((val) {
      val?.description = description;
    });
  }

  // 아이콘 업데이트
  void updateIcon(Icon icon) {
    tempSchedule.update((val) {
      val?.icon = icon;
    });
  }

  // 색상 업데이트
  void updateColor(Color color) {
    tempSchedule.update((val) {
      val?.color = color;
    });
  }

  // 일정 유형 업데이트
  void updateType(ScheduleType type) {
    tempSchedule.update((val) {
      val?.type = type;
    });
  }

  // 반복 주기 업데이트
  void updateRepeat(List<String> repeat) {
    tempSchedule.update((val) {
      val?.repeat = repeat;
    });
  }

  // 일정 시작 날짜 업데이트
  void updateScheduleStart(DateTime start) {
    tempSchedule.update((val) {
      val?.schedule_start = start;
    });
  }

  // 일정 종료 날짜 업데이트
  void updateScheduleEnd(DateTime end) {
    tempSchedule.update((val) {
      val?.schedule_end = end;
    });
  }

  // 새로운 일정 추가
  void addSchedule() {
    schedules.add(tempSchedule.value);
    resetTempSchedule();
  }

  // 임시 일정 초기화
  void resetTempSchedule() {
    tempSchedule.value = Schedule(
      title: "",
      icon: const Icon(Icons.star),
      description: "",
      type: ScheduleType.daily,
      time: const TimeOfDay(hour: 8, minute: 0),
      color: Colors.blue,
      reminders: [],
      repeat: [],
      schedule_start: DateTime.now(),
      schedule_end: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
