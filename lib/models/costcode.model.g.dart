// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'costcode.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CostCodeAdapter extends TypeAdapter<CostCode> {
  @override
  final int typeId = 2;

  @override
  CostCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CostCode(
      costcodeID: fields[0] as String,
      costcodeName: fields[1] as String,
      costcodeDesc: fields[2] as String,
      unit: fields[3] as String?,
      location: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CostCode obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.costcodeID)
      ..writeByte(1)
      ..write(obj.costcodeName)
      ..writeByte(2)
      ..write(obj.costcodeDesc)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
