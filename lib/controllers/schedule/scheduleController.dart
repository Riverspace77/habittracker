import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:habitui/models/schedule.dart';
import 'package:habitui/controllers/Hive/hive_schedule_adapter.dart';

class ScheduleController extends GetxController {
  var schedules = <Schedule>[].obs; // UI에서 사용할 일정 리스트
  late Box<HiveSchedule> _box; // ✅ Box 타입을 HiveSchedule로 변경

  // ✅ `Box<HiveSchedule>`을 컨트롤러에 설정
  void setBox(Box<HiveSchedule> box) {
    _box = box;
    loadSchedules();
  }

  // ✅ Hive에서 일정 데이터 불러오기
  Future<void> loadSchedules() async {
    try {
      schedules.value =
          _box.values.map((hiveSchedule) => hiveSchedule.toSchedule()).toList();
      print("✅ Hive에서 일정 데이터 로드 완료: ${schedules.length}개");
    } catch (e) {
      print("❌ Hive 데이터 로드 실패: $e");
      schedules.value = [];
    }
  }

  // ✅ 일정 저장
  Future<void> saveSchedule(Schedule schedule) async {
    try {
      final hiveSchedule = HiveSchedule.fromSchedule(schedule);
      await _box.put(schedule.title, hiveSchedule); // `title`을 key로 저장
      schedules.value = _box.values.map((h) => h.toSchedule()).toList();
      print("✅ Hive에 일정 저장 완료: ${schedule.title}");
      print(schedule.completionStatus);
    } catch (e) {
      print("❌ Hive 데이터 저장 실패: $e");
    }
  }

  // ✅ 일정 삭제 (title 기반)
  Future<void> deleteSchedule(String title) async {
    try {
      await _box.delete(title);
      schedules.value = _box.values.map((h) => h.toSchedule()).toList();
      print("✅ 일정 삭제 완료: $title");
    } catch (e) {
      print("❌ Hive 데이터 삭제 실패: $e");
    }
  }

  // ✅ 일정 업데이트 (title 기반)
  Future<void> updateSchedule(String title, Schedule updatedSchedule) async {
    try {
      if (_box.containsKey(title)) {
        await _box.put(title, HiveSchedule.fromSchedule(updatedSchedule));
        schedules.value = _box.values.map((h) => h.toSchedule()).toList();
        print("✅ 일정 업데이트 완료: $title");
      } else {
        print("⚠️ 업데이트 실패: 일정이 존재하지 않습니다.");
      }
    } catch (e) {
      print("❌ Hive 데이터 업데이트 실패: $e");
    }
  }

  // ✅ 특정 title을 가진 일정 찾기
  Schedule? findScheduleByTitle(String title) {
    return _box.get(title)?.toSchedule();
  }
}
