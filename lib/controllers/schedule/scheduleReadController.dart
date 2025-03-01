import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';

class ScheduleReadController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  /// 🔍 제목을 기준으로 스케줄 찾기
  Schedule? getScheduleByTitle(String title) {
    try {
      return scheduleController.schedules.firstWhere((s) => s.title == title,
          orElse: () => throw "일정을 찾을 수 없음");
    } catch (e) {
      Get.snackbar("오류", "해당 제목의 일정을 찾을 수 없습니다.");
      return null;
    }
  }
}

/*
final ScheduleReadController readController = Get.find<ScheduleReadController>();

// 특정 제목의 스케줄 가져오기
Schedule? mySchedule = readController.getScheduleByTitle("운동하기");

if (mySchedule != null) {
  print("찾은 일정: ${mySchedule.title}, ${mySchedule.time.format(context)}");
} else {
  print("일정을 찾을 수 없음.");
}

 */
