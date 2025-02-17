import 'package:get/get.dart';
import '../../models/schedule.dart';

class ScheduleController extends GetxController {
  var schedules = <Schedule>[].obs; // 일정 리스트
}


/*
final ScheduleController scheduleController = Get.find<ScheduleController>();

// 모든 스케줄 리스트 가져오기
List<Schedule> schedules = scheduleController.schedules;
 */