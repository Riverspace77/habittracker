import 'package:get/get.dart';
import 'package:habitui/controllers/Hive/schedule_storage.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';

class ScheduleDeleteController extends GetxController {
  final ScheduleController scheduleController = Get.find<ScheduleController>();

  /// 🗑️ **제목을 기준으로 일정 삭제**
  Future<void> deleteScheduleByTitle(String title) async {
    try {
      // 삭제할 일정 찾기
      int index =
          scheduleController.schedules.indexWhere((s) => s.title == title);

      if (index == -1) {
        throw "해당 제목의 일정을 찾을 수 없습니다.";
      }

      // 일정 리스트에서 삭제
      scheduleController.schedules.removeAt(index);

      // 🛠️ Hive에서 데이터 저장 (삭제 반영)
      await ScheduleStorage().saveSchedules();

      Get.snackbar("성공", "일정이 삭제되었습니다.");
    } catch (e) {
      Get.snackbar("오류", e.toString());
    }
  }
}

/*
final ScheduleDeleteController deleteController = Get.find<ScheduleDeleteController>();

// 특정 제목의 일정 삭제
deleteController.deleteScheduleByTitle("운동하기");

*/
