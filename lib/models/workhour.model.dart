import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:urbanico_app/models/timesheetproject.model.dart';
import 'package:urbanico_app/models/user.model.dart';

part 'workhour.model.g.dart';

@HiveType(typeId: 4)
class WorkhourData extends HiveObject {
  @HiveField(0)
  TimesheetProject tsproject;
  @HiveField(1)
  User user;
  @HiveField(2)
  double workhour;
  @HiveField(3)
  bool selected;
  WorkhourData({
    required this.tsproject,
    required this.user,
    required this.workhour,
    this.selected = false,
  });

  WorkhourData copyWith({
    TimesheetProject? tsproject,
    User? user,
    double? workhour,
    bool? selected,
  }) {
    return WorkhourData(
      tsproject: tsproject ?? this.tsproject,
      user: user ?? this.user,
      workhour: workhour ?? this.workhour,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tsproject': tsproject.toMap(),
      'user': user.toMap(),
      'workhour': workhour,
      'selected': selected,
    };
  }

  factory WorkhourData.fromMap(Map<String, dynamic> map) {
    return WorkhourData(
      tsproject: TimesheetProject.fromMap(map['tsproject']),
      user: User.fromMap(map['user']),
      workhour: map['workhour']?.toDouble() ?? 0.0,
      selected: map['selected'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkhourData.fromJson(String source) => WorkhourData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WorkhourData(tsproject: $tsproject, user: $user, workhour: $workhour, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkhourData &&
        other.tsproject == tsproject &&
        other.user == user &&
        other.workhour == workhour &&
        other.selected == selected;
  }

  @override
  int get hashCode {
    return tsproject.hashCode ^ user.hashCode ^ workhour.hashCode ^ selected.hashCode;
  }
}
