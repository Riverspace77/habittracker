import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';

class ScheduleDeleteController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  // 특정 일정 삭제 (타이틀 기반)
  void deleteScheduleByTitle(String title) {
    scheduleController.schedules
        .removeWhere((schedule) => schedule.title == title);
  }
}
