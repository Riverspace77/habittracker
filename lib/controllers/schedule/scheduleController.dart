import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:habitui/models/schedule.dart';

class ScheduleController extends GetxController {
  var schedules = <Schedule>[].obs; // 일정 리스트
  late Box<Schedule> _box; // 열린 Hive 박스를 저장할 변수

  // 메인에서 박스를 열어서 Controller에 전달받는 메서드
  void setBox(Box<Schedule> box) {
    _box = box;
    loadSchedules(); // 박스를 설정한 후 일정 불러오기
  }

  // Hive에서 일정 데이터 불러오기
  Future<void> loadSchedules() async {
    try {
      schedules.value = _box.values.toList();
      print("✅ Hive에서 일정 데이터 로드 완료: ${schedules.length}개");
    } catch (e) {
      print("❌ Hive 데이터 로드 실패: $e");
      schedules.value = []; // 예외 발생 시 빈 리스트 유지
    }
  }

  // 일정 저장 (기존 데이터 삭제 없이 업데이트)
  Future<void> saveSchedule(Schedule schedule) async {
    try {
      await _box.add(schedule); // `title`을 key로 사용
      schedules.value = _box.values.toList(); // UI 업데이트
      print("✅ Hive에 일정 저장 완료: ${schedule.title}");
    } catch (e) {
      print("❌ Hive 데이터 저장 실패: $e");
    }
  }

  // 일정 삭제 (title 기반)
  Future<void> deleteSchedule(String title) async {
    try {
      await _box.delete(title); // `title`을 key로 삭제
      schedules.value = _box.values.toList(); // UI 업데이트
      print("✅ 일정 삭제 완료: $title");
    } catch (e) {
      print("❌ Hive 데이터 삭제 실패: $e");
    }
  }

  // 일정 업데이트 (title 기반)
  Future<void> updateSchedule(String title, Schedule updatedSchedule) async {
    try {
      if (_box.containsKey(title)) {
        await _box.put(title, updatedSchedule); // 기존 title key에 업데이트
        schedules.value = _box.values.toList(); // UI 업데이트
        print("✅ 일정 업데이트 완료: $title");
      } else {
        print("⚠️ 업데이트 실패: 일정이 존재하지 않습니다.");
      }
    } catch (e) {
      print("❌ Hive 데이터 업데이트 실패: $e");
    }
  }

  // 특정 title을 가진 일정 찾기
  Schedule? findScheduleByTitle(String title) {
    return _box.get(title);
  }
}
