// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      projectID: fields[0] as String,
      projectCode: fields[1] as String,
      projectName: fields[2] as String,
      projectDesc: fields[3] as String,
      startDate: fields[4] as String?,
      endDate: fields[5] as String?,
      projectStatus: fields[6] as String?,
      projectOwner: fields[7] as String?,
      status: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.projectID)
      ..writeByte(1)
      ..write(obj.projectCode)
      ..writeByte(2)
      ..write(obj.projectName)
      ..writeByte(3)
      ..write(obj.projectDesc)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.projectStatus)
      ..writeByte(7)
      ..write(obj.projectOwner)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
