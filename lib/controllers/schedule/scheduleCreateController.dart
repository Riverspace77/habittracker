import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';

class ScheduleCreateController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  var tempSchedule = Schedule(
    setting: Scheduleset.check,
    title: "",
    icon: const Icon(Icons.star),
    description: "",
    type: ScheduleType.make,
    time: const TimeOfDay(hour: 8, minute: 0),
    color: Colors.blue,
    reminders: [],
    scheduleStart: DateTime.now(),
    scheduleEnd: DateTime.now().add(const Duration(days: 30)),
    repeatType: RepeatType.weekday,
    period: Period.weak, // 기본값 설정
  ).obs; // 일정 생성 중 임시 저장 객체

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

  // 반복 유형 업데이트
  void updateRepeatType(RepeatType repeatType) {
    tempSchedule.update((val) {
      val?.repeatType = repeatType;
    });
  }

  // 기간 업데이트 (once, multiple 경우 필수)
  void updatePeriod(Period period) {
    tempSchedule.update((val) {
      val?.period = period;
    });
  }

  // 횟수 업데이트 (multiple 경우 필수)
  void updateCount(int count) {
    tempSchedule.update((val) {
      val?.count = count;
    });
  }

  // 요일 선택 업데이트 (weekday 경우 필수)
  void updateWeekdays(List<String> weekdays) {
    tempSchedule.update((val) {
      val?.weekdays = weekdays;
    });
  }

  // 반복 간격 업데이트 (intervalDay, intervalWeek 경우 필수)
  void updateInterval(int interval) {
    tempSchedule.update((val) {
      val?.interval = interval;
    });
  }

  // 일정 시작 날짜 업데이트
  void updateScheduleStart(DateTime start) {
    tempSchedule.update((val) {
      val?.scheduleStart = start;
    });
  }

  // 일정 종료 날짜 업데이트
  void updateScheduleEnd(DateTime end) {
    tempSchedule.update((val) {
      val?.scheduleEnd = end;
    });
  }

  // 시간 업데이트
  void updateTime(TimeOfDay time) {
    tempSchedule.update((val) {
      val?.time = time;
    });
  }

  // setting 업데이트
  void updateSetting(Scheduleset setting) {
    tempSchedule.update((val) {
      val?.setting = setting;
    });
  }

  // 새로운 일정 추가
  void addSchedule() {
    scheduleController.schedules.add(Schedule(
      setting: tempSchedule.value.setting,
      title: tempSchedule.value.title,
      icon: tempSchedule.value.icon,
      description: tempSchedule.value.description,
      type: tempSchedule.value.type,
      time: tempSchedule.value.time,
      color: tempSchedule.value.color,
      reminders: List.from(tempSchedule.value.reminders), // 리스트 복사
      scheduleStart: tempSchedule.value.scheduleStart,
      scheduleEnd: tempSchedule.value.scheduleEnd,
      repeatType: tempSchedule.value.repeatType,
      period: tempSchedule.value.period,
      count: tempSchedule.value.count,
      weekdays: tempSchedule.value.weekdays,
      interval: tempSchedule.value.interval,
    ));
    resetTempSchedule();
  }

  // 임시 일정 초기화
  void resetTempSchedule() {
    tempSchedule.value = Schedule(
      setting: Scheduleset.check,
      title: "",
      icon: const Icon(Icons.star),
      description: "",
      type: ScheduleType.make,
      time: const TimeOfDay(hour: 8, minute: 0),
      color: Colors.blue,
      reminders: [],
      scheduleStart: DateTime.now(),
      scheduleEnd: DateTime.now().add(const Duration(days: 30)),
      repeatType: RepeatType.weekday,
      period: Period.weak,
    );
  }
}
