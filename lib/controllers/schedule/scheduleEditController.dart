import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import '../../models/schedule.dart';

class ScheduleUpdateController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

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
  ).obs; // 일정 수정 중 임시 저장 객체

  // 특정 일정 불러오기 (수정할 일정 찾기)
  void loadScheduleByTitle(String title) {
    int index = scheduleController.schedules
        .indexWhere((schedule) => schedule.title == title);
    if (index != -1) {
      tempSchedule.value = Schedule(
        title: scheduleController.schedules[index].title,
        icon: scheduleController.schedules[index].icon,
        description: scheduleController.schedules[index].description,
        type: scheduleController.schedules[index].type,
        time: scheduleController.schedules[index].time,
        color: scheduleController.schedules[index].color,
        reminders: List.from(scheduleController.schedules[index].reminders),
        repeat: List.from(scheduleController.schedules[index].repeat),
        schedule_start: scheduleController.schedules[index].schedule_start,
        schedule_end: scheduleController.schedules[index].schedule_end,
      );
    }
  }

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

  // 시간 업데이트
  void updateTime(TimeOfDay time) {
    tempSchedule.update((val) {
      val?.time = time;
    });
  }

  // 수정된 일정 저장
  void saveUpdatedSchedule() {
    int index = scheduleController.schedules
        .indexWhere((schedule) => schedule.title == tempSchedule.value.title);
    if (index != -1) {
      scheduleController.schedules[index] = tempSchedule.value;
    }
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
