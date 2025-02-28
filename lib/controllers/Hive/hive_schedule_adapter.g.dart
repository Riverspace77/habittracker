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
      timeHour: fields[5] as int,
      timeMinute: fields[6] as int,
      colorValue: fields[7] as int,
      reminders: (fields[8] as List).cast<String>(),
      scheduleStart: fields[9] as DateTime,
      scheduleEnd: fields[10] as DateTime,
      repeatType: fields[11] as RepeatType,
      period: fields[12] as Period?,
      count: fields[13] as int?,
      weekdays: (fields[14] as List?)?.cast<String>(),
      interval: fields[15] as int?,
      countProgress: (fields[16] as Map?)?.cast<String, int>(),
      timeProgress: (fields[17] as Map?)?.cast<String, double>(),
      checkProgress: (fields[18] as Map?)?.cast<String, bool>(),
      completionStatus: (fields[19] as Map?)?.cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveSchedule obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.timeHour)
      ..writeByte(6)
      ..write(obj.timeMinute)
      ..writeByte(7)
      ..write(obj.colorValue)
      ..writeByte(8)
      ..write(obj.reminders)
      ..writeByte(9)
      ..write(obj.scheduleStart)
      ..writeByte(10)
      ..write(obj.scheduleEnd)
      ..writeByte(11)
      ..write(obj.repeatType)
      ..writeByte(12)
      ..write(obj.period)
      ..writeByte(13)
      ..write(obj.count)
      ..writeByte(14)
      ..write(obj.weekdays)
      ..writeByte(15)
      ..write(obj.interval)
      ..writeByte(16)
      ..write(obj.countProgress)
      ..writeByte(17)
      ..write(obj.timeProgress)
      ..writeByte(18)
      ..write(obj.checkProgress)
      ..writeByte(19)
      ..write(obj.completionStatus);
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

class RepeatTypeAdapter extends TypeAdapter<RepeatType> {
  @override
  final int typeId = 1;

  @override
  RepeatType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatType.multipleweek;
      case 1:
        return RepeatType.multiple;
      case 2:
        return RepeatType.weekday;
      case 3:
        return RepeatType.intervalDay;
      case 4:
        return RepeatType.intervalWeek;
      default:
        return RepeatType.multipleweek;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatType obj) {
    switch (obj) {
      case RepeatType.multipleweek:
        writer.writeByte(0);
        break;
      case RepeatType.multiple:
        writer.writeByte(1);
        break;
      case RepeatType.weekday:
        writer.writeByte(2);
        break;
      case RepeatType.intervalDay:
        writer.writeByte(3);
        break;
      case RepeatType.intervalWeek:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodAdapter extends TypeAdapter<Period> {
  @override
  final int typeId = 2;

  @override
  Period read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Period.weak;
      case 1:
        return Period.month;
      case 2:
        return Period.year;
      default:
        return Period.weak;
    }
  }

  @override
  void write(BinaryWriter writer, Period obj) {
    switch (obj) {
      case Period.weak:
        writer.writeByte(0);
        break;
      case Period.month:
        writer.writeByte(1);
        break;
      case Period.year:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScheduleTypeAdapter extends TypeAdapter<ScheduleType> {
  @override
  final int typeId = 3;

  @override
  ScheduleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScheduleType.make;
      case 1:
        return ScheduleType.off;
      default:
        return ScheduleType.make;
    }
  }

  @override
  void write(BinaryWriter writer, ScheduleType obj) {
    switch (obj) {
      case ScheduleType.make:
        writer.writeByte(0);
        break;
      case ScheduleType.off:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchedulesetAdapter extends TypeAdapter<Scheduleset> {
  @override
  final int typeId = 4;

  @override
  Scheduleset read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Scheduleset.count;
      case 1:
        return Scheduleset.time;
      case 2:
        return Scheduleset.check;
      default:
        return Scheduleset.count;
    }
  }

  @override
  void write(BinaryWriter writer, Scheduleset obj) {
    switch (obj) {
      case Scheduleset.count:
        writer.writeByte(0);
        break;
      case Scheduleset.time:
        writer.writeByte(1);
        break;
      case Scheduleset.check:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchedulesetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
