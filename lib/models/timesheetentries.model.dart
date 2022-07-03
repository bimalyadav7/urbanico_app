import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'timesheetentries.model.g.dart';

@HiveType(typeId: 6)
class TimesheetEntries {
  @HiveField(0)
  String date;
  @HiveField(1)
  String day;
  @HiveField(2)
  String name;
  @HiveField(3)
  String status;
  @HiveField(4)
  String enteredBy;
  @HiveField(5)
  String nowork;
  @HiveField(6)
  String timestamp;
  @HiveField(7)
  String entrydateuserid;
  @HiveField(8)
  bool isSubmitted = true;
  TimesheetEntries({
    required this.date,
    required this.day,
    required this.name,
    required this.status,
    required this.enteredBy,
    required this.nowork,
    required this.timestamp,
    required this.entrydateuserid,
    required this.isSubmitted,
  });

  TimesheetEntries copyWith({
    String? date,
    String? day,
    String? name,
    String? status,
    String? enteredBy,
    String? nowork,
    String? timestamp,
    String? entrydateuserid,
    bool? isSubmitted,
  }) {
    return TimesheetEntries(
      date: date ?? this.date,
      day: day ?? this.day,
      name: name ?? this.name,
      status: status ?? this.status,
      enteredBy: enteredBy ?? this.enteredBy,
      nowork: nowork ?? this.nowork,
      timestamp: timestamp ?? this.timestamp,
      entrydateuserid: entrydateuserid ?? this.entrydateuserid,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'day': day,
      'name': name,
      'status': status,
      'entered_by': enteredBy,
      'nowork': nowork,
      'timestamp': timestamp,
      'entrydateuserid': entrydateuserid,
      'isSubmitted': isSubmitted,
    };
  }

  factory TimesheetEntries.fromMap(Map<String, dynamic> map) {
    return TimesheetEntries(
      date: map['date'] ?? '',
      day: map['day'] ?? '',
      name: map['name'] ?? '',
      status: map['status'] ?? '',
      enteredBy: map['entered_by'] ?? '',
      nowork: map['nowork'] ?? '',
      timestamp: map['timestamp'] ?? '',
      entrydateuserid: map['entrydateuserid'] ?? '',
      isSubmitted: map['isSubmitted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimesheetEntries.fromJson(String source) => TimesheetEntries.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TimesheetEntries(date: $date, day: $day, name: $name, status: $status, entered_by: $enteredBy, nowork: $nowork, timestamp: $timestamp, entrydateuserid: $entrydateuserid, isSubmitted: $isSubmitted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimesheetEntries &&
        other.date == date &&
        other.day == day &&
        other.name == name &&
        other.status == status &&
        other.enteredBy == enteredBy &&
        other.nowork == nowork &&
        other.timestamp == timestamp &&
        other.entrydateuserid == entrydateuserid &&
        other.isSubmitted == isSubmitted;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        day.hashCode ^
        name.hashCode ^
        status.hashCode ^
        enteredBy.hashCode ^
        nowork.hashCode ^
        timestamp.hashCode ^
        entrydateuserid.hashCode ^
        isSubmitted.hashCode;
  }
}
