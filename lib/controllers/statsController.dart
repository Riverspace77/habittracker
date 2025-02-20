import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';

class StatsController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  // `title`을 기반으로 특정 스케줄 찾기
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

  // 수행해야 하는 날짜 수 (`totalGoal`)
  int getTotalGoal(String title) {
    Schedule? schedule = getScheduleByTitle(title);
    return schedule?.getOccurrences().length ?? 0;
  }

  // 완료한 날짜 수 (`totalSuccess`)
  int getTotalSuccess(String title) {
    Schedule? schedule = getScheduleByTitle(title);
    return schedule?.checkProgress?.values.where((v) => v == true).length ?? 0;
  }

  // 3️⃣ 실패한 날짜 수 (`totalFail`)
  int getTotalFail(String title) {
    Schedule? schedule = getScheduleByTitle(title);
    return schedule?.completionStatus?.values.where((v) => v == false).length ??
        0;
  }

  // 성공률 (`successRate`) → `(totalSuccess / totalGoal) * 100`
  int getSuccessRate(String title) {
    int totalGoal = getTotalGoal(title);
    int totalSuccess = getTotalSuccess(title);
    return (totalGoal > 0) ? ((totalSuccess / totalGoal) * 100).toInt() : 0;
  }

  // 연속 성공 횟수 (`continSuccess`)
  int getContinSuccess(String title) {
    Schedule? schedule = getScheduleByTitle(title);
    if (schedule == null || schedule.checkProgress == null) return 0;

    List<DateTime> sortedDates = schedule.checkProgress!.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 최신 날짜부터 정렬

    int count = 0;
    for (var date in sortedDates) {
      if (schedule.checkProgress![date] == true) {
        count++;
      } else {
        break; // 중단되면 연속 성공 종료
      }
    }
    return count;
  }

  //총 진행도 (`totalProgress`)
  num getTotalProgress(String title) {
    Schedule? schedule = getScheduleByTitle(title);
    if (schedule == null) return 0;

    if (schedule.setting == Scheduleset.count) {
      return schedule.countProgress?.values
              .fold(0, (sum, value) => sum! + value) ??
          0;
    } else if (schedule.setting == Scheduleset.time) {
      return schedule.timeProgress?.values
              .fold(0.0, (sum, value) => sum! + value) ??
          0.0;
    } else {
      return schedule.checkProgress?.values.where((v) => v == true).length ?? 0;
    }
  }

  // 실패 진행도 (`totalFail`) → `(목표값 * totalGoal) - totalProgress`
  num getTotalFailProgress(String title) {
    Schedule? schedule = getScheduleByTitle(title);
    if (schedule == null) return 0;

    int totalGoal = getTotalGoal(title);
    num target = (schedule.setting == Scheduleset.count)
        ? (schedule.count ?? 1) * totalGoal
        : (schedule.setting == Scheduleset.time)
            ? (schedule.time.hour * 3600 + schedule.time.minute * 60) *
                totalGoal
            : totalGoal;

    num totalProgress = getTotalProgress(title);

    return target - totalProgress;
  }
}
