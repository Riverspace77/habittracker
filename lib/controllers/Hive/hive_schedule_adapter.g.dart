// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_schedule_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveScheduleAdapter extends TypeAdapter<HiveSchedule> {
  @override
  final int typeId = 0;

  @override
  HiveSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSchedule(
      setting: fields[0] as Scheduleset,
      title: fields[1] as String,
      iconCodePoint: fields[2] as int,
      description: fields[3] as String,
      type: fields[4] as ScheduleType,
      time: fields[5] as TimeOfDay,
      colorValue: fields[6] as int,
      reminders: (fields[7] as List).cast<String>(),
      scheduleStart: fields[8] as DateTime,
      scheduleEnd: fields[9] as DateTime,
      repeatType: fields[10] as RepeatType,
      period: fields[11] as Period?,
      count: fields[12] as int?,
      weekdays: (fields[13] as List?)?.cast<String>(),
      interval: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSchedule obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.setting)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.iconCodePoint)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.colorValue)
      ..writeByte(7)
      ..write(obj.reminders)
      ..writeByte(8)
      ..write(obj.scheduleStart)
      ..writeByte(9)
      ..write(obj.scheduleEnd)
      ..writeByte(10)
      ..write(obj.repeatType)
      ..writeByte(11)
      ..write(obj.period)
      ..writeByte(12)
      ..write(obj.count)
      ..writeByte(13)
      ..write(obj.weekdays)
      ..writeByte(14)
      ..write(obj.interval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
