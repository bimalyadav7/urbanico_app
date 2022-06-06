// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheetproject.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimesheetProjectAdapter extends TypeAdapter<TimesheetProject> {
  @override
  final int typeId = 5;

  @override
  TimesheetProject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimesheetProject(
      project: fields[0] as Project,
      phase: fields[1] as Phase,
      costcode: fields[2] as CostCode,
      quantity: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TimesheetProject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.project)
      ..writeByte(1)
      ..write(obj.phase)
      ..writeByte(2)
      ..write(obj.costcode)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimesheetProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
