// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhaseAdapter extends TypeAdapter<Phase> {
  @override
  final int typeId = 1;

  @override
  Phase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Phase(
      parentID: fields[0] as String,
      phaseid: fields[1] as String,
      projectID: fields[2] as String,
      phasecode: fields[3] as String,
      phasedesc: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Phase obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.parentID)
      ..writeByte(1)
      ..write(obj.phaseid)
      ..writeByte(2)
      ..write(obj.projectID)
      ..writeByte(3)
      ..write(obj.phasecode)
      ..writeByte(4)
      ..write(obj.phasedesc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
