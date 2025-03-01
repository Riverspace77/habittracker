// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_adapters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
