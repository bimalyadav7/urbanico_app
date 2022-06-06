import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'project.model.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  String projectID;
  @HiveField(1)
  String projectCode;
  @HiveField(2)
  String projectName;
  @HiveField(3)
  String projectDesc;
  @HiveField(4)
  String? startDate;
  @HiveField(5)
  String? endDate;
  @HiveField(6)
  String? projectStatus;
  @HiveField(7)
  String? projectOwner;
  @HiveField(8)
  String? status;
  Project({
    required this.projectID,
    required this.projectCode,
    required this.projectName,
    required this.projectDesc,
    this.startDate,
    this.endDate,
    this.projectStatus,
    this.projectOwner,
    this.status,
  });

  Project copyWith({
    String? projectID,
    String? projectCode,
    String? projectName,
    String? projectDesc,
    String? startDate,
    String? endDate,
    String? projectStatus,
    String? projectOwner,
    String? status,
  }) {
    return Project(
      projectID: projectID ?? this.projectID,
      projectCode: projectCode ?? this.projectCode,
      projectName: projectName ?? this.projectName,
      projectDesc: projectDesc ?? this.projectDesc,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectStatus: projectStatus ?? this.projectStatus,
      projectOwner: projectOwner ?? this.projectOwner,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectID': projectID,
      'projectCode': projectCode,
      'projectName': projectName,
      'projectDesc': projectDesc,
      'startDate': startDate,
      'endDate': endDate,
      'projectStatus': projectStatus,
      'projectOwner': projectOwner,
      'status': status,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      projectID: map['projectID'] ?? '',
      projectCode: map['projectCode'] ?? '',
      projectName: map['projectName'] ?? '',
      projectDesc: map['projectDesc'] ?? '',
      startDate: map['startDate'],
      endDate: map['endDate'],
      projectStatus: map['projectStatus'],
      projectOwner: map['projectOwner'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) => Project.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Project(projectID: $projectID, projectCode: $projectCode, projectName: $projectName, projectDesc: $projectDesc, startDate: $startDate, endDate: $endDate, projectStatus: $projectStatus, projectOwner: $projectOwner, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Project &&
        other.projectID == projectID &&
        other.projectCode == projectCode &&
        other.projectName == projectName &&
        other.projectDesc == projectDesc &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.projectStatus == projectStatus &&
        other.projectOwner == projectOwner &&
        other.status == status;
  }

  @override
  int get hashCode {
    return projectID.hashCode ^
        projectCode.hashCode ^
        projectName.hashCode ^
        projectDesc.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        projectStatus.hashCode ^
        projectOwner.hashCode ^
        status.hashCode;
  }
}
