class Equipment {
  late String equipmentid;
  late String equipmentname;
  late String equipmentdesc;
  late double lastreading;

  Equipment() {
    equipmentid = '';
    equipmentname = '';
    equipmentdesc = '';
    lastreading = 0.0;
  }

  Equipment.fromJson(Map<String, dynamic> json) {
    equipmentid = json['equipment'];
    equipmentname = json['name'];
    equipmentdesc = json['desc'];
    lastreading = (json.containsKey('lastreading')) ? double.parse(json['lastreading']) : 0.0;
  }

  Equipment.fromJsonForView(Map<String, dynamic> json) {
    equipmentid = json['equipmentid'];
    equipmentname = json['equipmentname'];
    equipmentdesc = json['equipmentdesc'];
    lastreading = (json.containsKey('lastreading')) ? double.parse(json['lastreading']) : 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      "equipment": equipmentid,
      "name": equipmentname,
      "desc": equipmentdesc,
      "lastreading": lastreading,
    };
  }
}
