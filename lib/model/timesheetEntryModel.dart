class TimesheetEntry {
  late String sn;
  late String date;
  late String day;
  late String name;
  late String status;
  late String enteredBy;
  late String nowork;
  bool selected = false;

  TimesheetEntry() {
    sn = '';
    date = '';
    day = '';
    name = '';
    status = '';
    enteredBy = '';
    nowork = '';
  }

  TimesheetEntry.fromJson(Map<String, dynamic> json) {
    sn = json['sn'].toString();
    date = json['date'];
    day = json['day'];
    name = json['name'];
    status = json['status'];
    enteredBy = json['entered_by'];
    nowork = json['nowork'];
  }
}
