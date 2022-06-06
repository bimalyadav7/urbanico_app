class Subcontractor {
  late int _id;
  late String _subcontractorName;
  late String _description;
  late String _quantity;
  static int _idCount = 0;

  Subcontractor() {
    _id = -1;
    _subcontractorName = "";
    _description = "";
    _quantity = "";
    _incrementID();
  }

  int get id => _id;
  String get subcontractorName => _subcontractorName;
  String get description => _description;
  String get quantity => _quantity;

  set setContractorName(String value) {
    _subcontractorName = value;
  }

  set setDescription(String value) {
    _description = value;
  }

  set setQuantity(String value) {
    _quantity = value;
  }

  _incrementID() {
    _id = _idCount;
    _idCount++;
  }
}
