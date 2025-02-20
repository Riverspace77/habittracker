import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/Hive/schedule_storage.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';

class ScheduleEditController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  var editingSchedule = Rxn<Schedule>(); // 현재 편집 중인 스케줄

  // 제목을 기준으로 일정 찾기
  void findScheduleByTitle(String title) {
    try {
      final schedule = scheduleController.schedules.firstWhere(
          (s) => s.title == title,
          orElse: () => throw "일정을 찾을 수 없음");
      editingSchedule.value = schedule;
    } catch (e) {
      editingSchedule.value = null;
      Get.snackbar("오류", "해당 제목의 일정을 찾을 수 없습니다.");
    }
  }

  // 일정 제목 업데이트
  void updateTitle(String title) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.title = title;
      });
    }
  }

  // 일정 설명 업데이트
  void updateDescription(String description) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.description = description;
      });
    }
  }

  // 일정 색상 업데이트
  void updateColor(Color color) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.color = color;
      });
    }
  }

  // 일정 시간 업데이트
  void updateTime(TimeOfDay time) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.time = time;
      });
    }
  }

  // 반복 유형 업데이트
  void updateRepeatType(RepeatType repeatType) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.repeatType = repeatType;
      });
    }
  }

  // 일정 시작 날짜 업데이트
  void updateScheduleStart(DateTime start) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.scheduleStart = start;
      });
    }
  }

  // 일정 종료 날짜 업데이트
  void updateScheduleEnd(DateTime end) {
    if (editingSchedule.value != null) {
      editingSchedule.update((val) {
        val?.scheduleEnd = end;
      });
    }
  }

  // 변경 사항을 Hive에 반영
  void saveEditedSchedule() async {
    if (editingSchedule.value != null) {
      int index = scheduleController.schedules
          .indexWhere((s) => s.title == editingSchedule.value!.title);

      if (index != -1) {
        // 리스트 업데이트
        scheduleController.schedules[index] = editingSchedule.value!;

        // 🔥 Hive에 저장
        await ScheduleStorage().saveSchedules();

        Get.snackbar("성공", "일정이 성공적으로 업데이트되었습니다.");
      } else {
        Get.snackbar("오류", "업데이트할 일정을 찾을 수 없습니다.");
      }
    }
  }
}
/*
final ScheduleEditController editController = Get.find<ScheduleEditController>();

// 특정 제목을 가진 스케줄 찾기
editController.findScheduleByTitle("운동하기");

// 찾은 스케줄 가져오기
Schedule? foundSchedule = editController.editingSchedule.value;


// 제목 수정
editController.updateTitle("새로운 제목");

// 설명 수정
editController.updateDescription("운동을 매일 30분씩");

// 색상 수정
editController.updateColor(Colors.red);

// 시간 수정
editController.updateTime(const TimeOfDay(hour: 9, minute: 0));

// 시작 날짜 변경
editController.updateScheduleStart(DateTime(2025, 3, 1));

// 종료 날짜 변경
editController.updateScheduleEnd(DateTime(2025, 3, 30));

editController.saveEditedSchedule();

*/
