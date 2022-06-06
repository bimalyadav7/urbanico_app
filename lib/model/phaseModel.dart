class Phase {
  late String parentID;
  late String phaseid;
  late String projectID;
  late String phasecode;
  late String phasedesc;

  Phase() {
    phaseid = '';
    projectID = '';
    parentID = '';
    phasecode = '';
    phasedesc = '';
  }

  Phase.fromJson(Map<String, dynamic> json) {
    parentID = json['parentID'];
    projectID = json['projectID'];
    phaseid = json['phaseid'];
    phasecode = json['phasecode'];
    phasedesc = json['phasedesc'];
  }
}
