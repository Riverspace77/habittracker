import 'package:habitui/controllers/Hive/hive_schedule_adapter.dart';
import 'package:hive/hive.dart';

class HiveScheduleService {
  static const String boxName = "scheduleBox";

  // 박스 열기
  static Future<Box<HiveSchedule>> openBox() async {
    return await Hive.openBox<HiveSchedule>(boxName);
  }

  // 일정 저장
  static Future<void> saveSchedule(HiveSchedule schedule) async {
    final box = await openBox();
    await box.add(schedule);
  }

  // 일정 목록 가져오기
  static Future<List<HiveSchedule>> getSchedules() async {
    final box = await openBox();
    return box.values.toList();
  }

  // 일정 업데이트
  static Future<void> updateSchedule(int key, HiveSchedule schedule) async {
    final box = await openBox();
    await box.put(key, schedule);
  }

  // 일정 삭제
  static Future<void> deleteSchedule(int key) async {
    final box = await openBox();
    await box.delete(key);
  }

  // 모든 일정 삭제
  static Future<void> clearSchedules() async {
    final box = await openBox();
    await box.clear();
  }
}
