class CostCode {
  late String costcodeID;
  late String costcodeName;
  late String costcodeDesc;
  late String unit;
  late String location;

  CostCode() {
    init();
  }

  void init() {
    costcodeID = '';
    costcodeName = '';
    costcodeDesc = '';
    unit = '';
    location = '';
  }

  CostCode.fromJson(Map<String, dynamic> json) {
    costcodeID = json['costcodeID'];
    costcodeName = json['costcodeName'];
    costcodeDesc = json['costcodeDesc'];
    unit = json['unit'];
    location = json['location'];
  }
}
