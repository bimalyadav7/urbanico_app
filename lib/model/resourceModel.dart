class Resources {
  late String _title;
  late double _valueMath;
  late double _valueActual;
  late double _valueField;
  late int _id;
  static int _idCount = 0;
  Resources() {
    incrementID();
    _valueMath = 0.0;
    _valueActual = 0.0;
    _valueField = 0.0;
    _title = "";
  }
  int get id => _id;
  String get title => _title;
  double get valueMath => _valueMath;
  double get valueActual => _valueActual;
  double getValueField(double qty) {
    _valueField = double.parse((_valueActual / (_valueMath * qty) - 1).toStringAsPrecision(2));
    return _valueField * 100;
  }

  set setValueMath(double value) {
    _valueMath = value;
  }

  set setValueActual(double value) {
    _valueActual = value;
  }

  set setTitle(String title) {
    _title = title;
  }

  void incrementID() {
    _id = _idCount;
    _idCount++;
  }
}

class Base extends Resources {
  Base() {
    setTitle = "Base";
  }
}

class Concrete extends Resources {
  Concrete() {
    setTitle = "Conc";
  }
}

class TruckValue extends Resources {
  TruckValue() {
    setTitle = "Truck";
  }
}

class Truck {
  late int _id;
  late String _truckID;
  late String _ticket;
  late double _hour;
  late double _load;
  static int _idCount = 0;

  Truck() {
    incrementID();
    _truckID = "";
    _ticket = "";
    _hour = 0.0;
    _load = 0.0;
  }

  incrementID() {
    _id = _idCount;
    _idCount++;
  }

  String get truckID => _truckID;
  String get ticket => _ticket;
  double get hour => _hour;
  double get load => _load;
  int get id => _id;

  set setTruckID(String id) {
    _truckID = id;
  }

  set setTicket(String ticket) {
    _ticket = ticket;
  }

  set setHour(double hour) {
    _hour = hour;
  }

  set setLoad(double load) {
    _load = load;
  }
}
