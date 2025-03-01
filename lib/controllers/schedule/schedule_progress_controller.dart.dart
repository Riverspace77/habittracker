import 'package:get/get.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';

class ScheduleProgressController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  // 타이틀로 특정 스케줄 찾기
  Schedule? getScheduleByTitle(String title) {
    if (scheduleController.schedules.isEmpty) {
      print("스케줄 데이터가 없음.");
      return null;
    }
    try {
      return scheduleController.schedules.firstWhere(
        (s) => s.title == title,
        orElse: () => throw "일정을 찾을 수 없습니다.",
      );
    } catch (e) {
      Get.snackbar("오류", e.toString());
      return null;
    }
  }

  /*final ScheduleProgressController progressController = Get.find<ScheduleProgressController>();

Schedule? mySchedule = progressController.getScheduleByTitle("운동하기");

if (mySchedule != null) {
  print("찾은 일정: ${mySchedule.title}, 시작 날짜: ${mySchedule.scheduleStart}");
} else {
  print("해당 제목의 일정이 없습니다.");
}
*/

  // 특정 날짜의 진행도 가져오기 (타이틀 기반)
  dynamic getProgressByTitle(String title, DateTime date) {
    Schedule? schedule = getScheduleByTitle(title);
    if (schedule == null) return null;

    DateTime dateOnly = DateTime(date.year, date.month, date.day); // ⬅ 시간 제거

    switch (schedule.setting) {
      case Scheduleset.count:
        return schedule.countProgress?[dateOnly] ?? 0;
      case Scheduleset.time:
        return schedule.timeProgress?[dateOnly] ?? 0.0;
      case Scheduleset.check:
        return schedule.checkProgress?[dateOnly] ?? false;
    }
  }

  /*
  DateTime today = DateTime.now();
  dynamic progress = progressController.getProgressByTitle("운동하기", today);

if (progress != null) {
  print("오늘 운동하기 진행도: $progress");
} else {
  print("진행도를 찾을 수 없습니다.");
}
 */

  // 특정 날짜의 진행도 업데이트 (타이틀 기반 & Hive 저장)
  Future<void> updateProgressByTitle(
      String title, DateTime date, dynamic value) async {
    Schedule? schedule = getScheduleByTitle(title);
    if (schedule == null) return;

    DateTime dateOnly = DateTime(date.year, date.month, date.day); // ⬅ 시간 제거

    switch (schedule.setting) {
      case Scheduleset.count:
        if (value is int) {
          schedule.countProgress?[dateOnly] = value;
          _updateCompletionStatus(
              schedule, dateOnly, value, schedule.count ?? 1);
        }
        break;
      case Scheduleset.time:
        if (value is double) {
          schedule.timeProgress?[dateOnly] = value;
          _updateCompletionStatus(
              schedule, dateOnly, value, schedule.time.hour.toDouble());
        }
        break;
      case Scheduleset.check:
        if (value is bool) schedule.checkProgress?[dateOnly] = value;
        break;
    }

    // 변경된 데이터 저장 (Hive에 즉시 반영)

    scheduleController.schedules.refresh();
    await scheduleController.saveSchedule(schedule);
  }

  /*
    final ScheduleProgressController progressController = Get.find<ScheduleProgressController>();

    DateTime today = DateTime.now();
    await progressController.updateProgressByTitle("운동하기", today, true); // 체크 완료

    */

  //  변경된 데이터 저장
  void _updateCompletionStatus(
      Schedule schedule, DateTime date, dynamic progress, dynamic goal) {
    if (progress is num && goal is num) {
      if (progress >= goal) {
        schedule.completionStatus?[date] = true;
      } else {
        schedule.completionStatus?[date] = false;
      }
    }
  }
}
