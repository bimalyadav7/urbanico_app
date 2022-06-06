import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'phase.model.g.dart';

@HiveType(typeId: 1)
class Phase {
  @HiveField(0)
  String parentID;
  @HiveField(1)
  String phaseid;
  @HiveField(2)
  String projectID;
  @HiveField(3)
  String phasecode;
  @HiveField(4)
  String phasedesc;
  Phase({
    required this.parentID,
    required this.phaseid,
    required this.projectID,
    required this.phasecode,
    required this.phasedesc,
  });

  Phase copyWith({
    String? parentID,
    String? phaseid,
    String? projectID,
    String? phasecode,
    String? phasedesc,
  }) {
    return Phase(
      parentID: parentID ?? this.parentID,
      phaseid: phaseid ?? this.phaseid,
      projectID: projectID ?? this.projectID,
      phasecode: phasecode ?? this.phasecode,
      phasedesc: phasedesc ?? this.phasedesc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentID': parentID,
      'phaseid': phaseid,
      'projectID': projectID,
      'phasecode': phasecode,
      'phasedesc': phasedesc,
    };
  }

  factory Phase.fromMap(Map<String, dynamic> map) {
    return Phase(
      parentID: map['parentID'] ?? '',
      phaseid: map['phaseid'] ?? '',
      projectID: map['projectID'] ?? '',
      phasecode: map['phasecode'] ?? '',
      phasedesc: map['phasedesc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Phase.fromJson(String source) => Phase.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Phase(parentID: $parentID, phaseid: $phaseid, projectID: $projectID, phasecode: $phasecode, phasedesc: $phasedesc)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Phase &&
        other.parentID == parentID &&
        other.phaseid == phaseid &&
        other.projectID == projectID &&
        other.phasecode == phasecode &&
        other.phasedesc == phasedesc;
  }

  @override
  int get hashCode {
    return parentID.hashCode ^ phaseid.hashCode ^ projectID.hashCode ^ phasecode.hashCode ^ phasedesc.hashCode;
  }
}
