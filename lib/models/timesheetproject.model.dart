import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:urbanico_app/models/costcode.model.dart';
import 'package:urbanico_app/models/phase.model.dart';
import 'package:urbanico_app/models/project.model.dart';

part 'timesheetproject.model.g.dart';

@HiveType(typeId: 5)
class TimesheetProject extends HiveObject {
  @HiveField(0)
  Project project;
  @HiveField(1)
  Phase phase;
  @HiveField(2)
  CostCode costcode;
  @HiveField(3)
  double quantity;
  TimesheetProject({
    required this.project,
    required this.phase,
    required this.costcode,
    required this.quantity,
  });

  TimesheetProject copyWith({
    Project? project,
    Phase? phase,
    CostCode? costcode,
    double? quantity,
  }) {
    return TimesheetProject(
      project: project ?? this.project,
      phase: phase ?? this.phase,
      costcode: costcode ?? this.costcode,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project': project.toMap(),
      'phase': phase.toMap(),
      'costcode': costcode.toMap(),
      'quantity': quantity,
    };
  }

  factory TimesheetProject.fromMap(Map<String, dynamic> map) {
    return TimesheetProject(
      project: Project.fromMap(map['project']),
      phase: Phase.fromMap(map['phase']),
      costcode: CostCode.fromMap(map['costcode']),
      quantity: map['quantity']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimesheetProject.fromJson(String source) => TimesheetProject.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TimesheetProject(project: $project, phase: $phase, costcode: $costcode, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimesheetProject &&
        other.project == project &&
        other.phase == phase &&
        other.costcode == costcode &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return project.hashCode ^ phase.hashCode ^ costcode.hashCode ^ quantity.hashCode;
  }
}
