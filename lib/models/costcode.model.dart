import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'costcode.model.g.dart';

@HiveType(typeId: 2)
class CostCode {
  @HiveField(0)
  String costcodeID;
  @HiveField(1)
  String costcodeName;
  @HiveField(2)
  String costcodeDesc;
  @HiveField(3)
  String? unit;
  @HiveField(4)
  String? location;
  CostCode({
    required this.costcodeID,
    required this.costcodeName,
    required this.costcodeDesc,
    this.unit,
    this.location,
  });

  CostCode copyWith({
    String? costcodeID,
    String? costcodeName,
    String? costcodeDesc,
    String? unit,
    String? location,
  }) {
    return CostCode(
      costcodeID: costcodeID ?? this.costcodeID,
      costcodeName: costcodeName ?? this.costcodeName,
      costcodeDesc: costcodeDesc ?? this.costcodeDesc,
      unit: unit ?? this.unit,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'costcodeID': costcodeID,
      'costcodeName': costcodeName,
      'costcodeDesc': costcodeDesc,
      'unit': unit,
      'location': location,
    };
  }

  factory CostCode.fromMap(Map<String, dynamic> map) {
    return CostCode(
      costcodeID: map['costcodeID'] ?? '',
      costcodeName: map['costcodeName'] ?? '',
      costcodeDesc: map['costcodeDesc'] ?? '',
      unit: map['unit'],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CostCode.fromJson(String source) => CostCode.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CostCode(costcodeID: $costcodeID, costcodeName: $costcodeName, costcodeDesc: $costcodeDesc, unit: $unit, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CostCode &&
        other.costcodeID == costcodeID &&
        other.costcodeName == costcodeName &&
        other.costcodeDesc == costcodeDesc &&
        other.unit == unit &&
        other.location == location;
  }

  @override
  int get hashCode {
    return costcodeID.hashCode ^ costcodeName.hashCode ^ costcodeDesc.hashCode ^ unit.hashCode ^ location.hashCode;
  }
}
