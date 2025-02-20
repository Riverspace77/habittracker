import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:habitui/models/schedule.dart';

class ScheduleController extends GetxController {
  var schedules = <Schedule>[].obs; // 일정 리스트

  // Hive에서 일정 데이터 불러오기
  Future<void> loadSchedules() async {
    try {
      var box = await Hive.openBox<Schedule>('schedules');
      schedules.value = box.values.toList();
      print("Hive에서 일정 데이터 로드 완료: ${schedules.length}개");
    } catch (e) {
      print("Hive 데이터 로드 실패: $e");
      schedules.value = []; // 데이터가 없을 경우 빈 리스트로 유지
    }
  }

  // Hive에 일정 데이터 저장하기
  Future<void> saveSchedules() async {
    try {
      var box = await Hive.openBox<Schedule>('schedules');
      await box.clear();
      await box.addAll(schedules);
    } catch (e) {
      print("Hive 데이터 저장 실패: $e");
    }
  }
}
