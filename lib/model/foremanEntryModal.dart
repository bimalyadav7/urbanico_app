class ForemanEntry {
  late int serialno;
  late String entrydateuserid;
  late String date;
  late String day;
  late String name;
  late String status;
  late String enteredby;
  late String nowork;

  ForemanEntry() {
    entrydateuserid = '';
    serialno = 0;
    date = '';
    day = '';
    name = '';
    status = '';
    enteredby = '';
    nowork = '';
  }

  ForemanEntry.fromJson(Map<String, dynamic> json) {
    entrydateuserid = json['entrydateuserid'];
    serialno = json['sn'];
    date = json['date'];
    day = json['day'];
    name = json['name'];
    status = json['status'];
    enteredby = json['entered_by'];
    nowork = json['nowork'];
  }

  Map<String, dynamic> toJson() {
    return {
      "entrydateuserid": entrydateuserid,
      "sn": serialno,
      "date": date,
      "day": day,
      "name": name,
      "status": status,
      "entered_by": enteredby,
      "nowork": nowork,
    };
  }
}
