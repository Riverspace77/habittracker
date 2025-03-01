import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';

class StatsController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  // 수행해야 하는 날짜 수 (`totalGoal`)
  int getTotalGoal(Schedule schedule) {
    return schedule.getOccurrences().length;
  }

// 완료한 날짜 수 (`totalSuccess`)
  int getTotalSuccess(Schedule schedule) {
    if (schedule.completionStatus != null &&
        schedule.completionStatus!.isNotEmpty) {
      return schedule.completionStatus!.values.where((v) => v == true).length;
    }
    return schedule.checkProgress?.values.where((v) => v == true).length ?? 0;
  }

// 실패한 날짜 수 (`totalFail`)
  int getTotalFail(Schedule schedule) {
    if (schedule.completionStatus != null &&
        schedule.completionStatus!.isNotEmpty) {
      return schedule.completionStatus!.values.where((v) => v == false).length;
    }
    return schedule.checkProgress?.values.where((v) => v == false).length ?? 0;
  }

  // 성공률 (`successRate`) → `(totalSuccess / totalGoal) * 100`
  int getSuccessRate(Schedule schedule) {
    int totalGoal = getTotalGoal(schedule);
    int totalSuccess = getTotalSuccess(schedule);
    return (totalGoal > 0) ? ((totalSuccess / totalGoal) * 100).toInt() : 0;
  }

  // 연속 성공 횟수 (`continSuccess`)
  int getContinSuccess(Schedule schedule) {
    Map<DateTime, bool>? progressMap;

    // completionStatus를 우선 사용하고, 비어 있다면 checkProgress 사용
    if (schedule.completionStatus != null &&
        schedule.completionStatus!.isNotEmpty) {
      progressMap = schedule.completionStatus;
    } else {
      progressMap = schedule.checkProgress;
    }

    if (progressMap == null || progressMap.isEmpty) return 0;

    List<DateTime> sortedDates = progressMap.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 최신 날짜부터 정렬

    int count = 0;
    for (var date in sortedDates) {
      if (progressMap[date] == true) {
        count++;
      } else {
        break; // 중단되면 연속 성공 종료
      }
    }
    return count;
  }

  // **최대 연속 성공 횟수 (`maxContinSuccess`)**
  int getMaxContinSuccess(Schedule schedule) {
    Map<DateTime, bool>? progressMap;

    if (schedule.completionStatus != null &&
        schedule.completionStatus!.isNotEmpty) {
      progressMap = schedule.completionStatus;
    } else {
      progressMap = schedule.checkProgress;
    }

    if (progressMap == null || progressMap.isEmpty) return 0;

    List<DateTime> sortedDates = progressMap.keys.toList()
      ..sort((a, b) => a.compareTo(b)); // 과거 날짜부터 정렬

    int maxCount = 0;
    int currentCount = 0;

    for (var date in sortedDates) {
      if (progressMap[date] == true) {
        currentCount++;
        maxCount = currentCount > maxCount ? currentCount : maxCount;
      } else {
        currentCount = 0; // 실패하면 연속 성공 수 초기화
      }
    }
    return maxCount;
  }

  // 총 진행도 (`totalProgress`)
  num getTotalProgress(Schedule schedule) {
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

  // 실패 진행도 (`totalFailProgress`) → `(목표값 * totalGoal) - totalProgress`
  num getTotalFailProgress(Schedule schedule) {
    int totalGoal = getTotalGoal(schedule);
    num target = (schedule.setting == Scheduleset.count)
        ? (schedule.count ?? 1) * totalGoal
        : (schedule.setting == Scheduleset.time)
            ? (schedule.time.hour * 3600 + schedule.time.minute * 60) *
                totalGoal
            : totalGoal;

    num totalProgress = getTotalProgress(schedule);

    return target - totalProgress;
  }
}
