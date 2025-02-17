import 'package:habitui/controllers/Hive/hive_schedule_adapter.dart';
import 'package:habitui/controllers/Hive/hive_schedule_service.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:get/get.dart';

class ScheduleStorage {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  // Hive에서 일정 불러와서 scheduleController에 저장
  Future<void> loadSchedules() async {
    final hiveSchedules = await HiveScheduleService.getSchedules();
    scheduleController.schedules.clear();
    scheduleController.schedules
        .addAll(hiveSchedules.map((h) => h.toSchedule()).toList());
  }

  // 현재 일정 리스트를 Hive에 저장
  Future<void> saveSchedules() async {
    await HiveScheduleService.clearSchedules(); // 기존 데이터 삭제
    for (var schedule in scheduleController.schedules) {
      await HiveScheduleService.saveSchedule(
          HiveSchedule.fromSchedule(schedule));
    }
  }
}

/*
final storage = ScheduleStorage();
await storage.loadSchedules();



final storage = ScheduleStorage();
await storage.saveSchedules();
*/
