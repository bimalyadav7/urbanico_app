// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheetentries.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimesheetEntriesAdapter extends TypeAdapter<TimesheetEntries> {
  @override
  final int typeId = 6;

  @override
  TimesheetEntries read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimesheetEntries(
      date: fields[0] as String,
      day: fields[1] as String,
      name: fields[2] as String,
      status: fields[3] as String,
      enteredBy: fields[4] as String,
      nowork: fields[5] as String,
      timestamp: fields[6] as String,
      entrydateuserid: fields[7] as String,
      isSubmitted: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimesheetEntries obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.enteredBy)
      ..writeByte(5)
      ..write(obj.nowork)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.entrydateuserid)
      ..writeByte(8)
      ..write(obj.isSubmitted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimesheetEntriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
