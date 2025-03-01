import 'package:hive/hive.dart';
import 'package:habitui/models/schedule.dart';

part 'enum_adapters.g.dart';

// 🔹 RepeatType Adapter
@HiveType(typeId: 1)
enum RepeatType {
  @HiveField(0)
  multipleweek,
  @HiveField(1)
  multiple,
  @HiveField(2)
  weekday,
  @HiveField(3)
  intervalDay,
  @HiveField(4)
  intervalWeek,
}

// 🔹 Period Adapter
@HiveType(typeId: 2)
enum Period {
  @HiveField(0)
  weak,
  @HiveField(1)
  month,
  @HiveField(2)
  year,
}

// 🔹 ScheduleType Adapter
@HiveType(typeId: 3)
enum ScheduleType {
  @HiveField(0)
  make,
  @HiveField(1)
  off,
}

// 🔹 Scheduleset Adapter
@HiveType(typeId: 4)
enum Scheduleset {
  @HiveField(0)
  count,
  @HiveField(1)
  time,
  @HiveField(2)
  check,
}
