// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workhour.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkhourDataAdapter extends TypeAdapter<WorkhourData> {
  @override
  final int typeId = 4;

  @override
  WorkhourData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkhourData(
      tsproject: fields[0] as TimesheetProject,
      user: fields[1] as User,
      workhour: fields[2] as double,
      selected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkhourData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tsproject)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.workhour)
      ..writeByte(3)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkhourDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
