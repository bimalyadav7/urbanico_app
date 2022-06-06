import 'package:urbanico_app/model/resourceModel.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';

class UIKeypadRepository extends BaseNotifierRepo {
  bool _selected = false;
  String _selectedField = "";

  final List<WorkHours> _whrs = [];
  final List<ProjectEquipment> _ehrs = [];
  final List<TimeSheetProject> _quantity = [];
  final List<Resources> _resource = [];
  final List<Truck> _truckload = [];
  final List<Truck> _truckhour = [];
  final List<ProjectEquipment> _lastreading = [];

  UIKeypadRepository(authRepo) : super(authRepo);

  String get selectedFieldName => _selectedField;
  bool get keypadState => _selected;
  List<WorkHours> get selectedWorkHours => _whrs;
  List<ProjectEquipment> get selectedEquipmentHours => _ehrs;
  List<TimeSheetProject> get selectedTimesheetProjects => _quantity;
  List<Resources> get selectedProjectResources => _resource;
  List<Truck> get selectedTruckLoad => _truckload;
  List<Truck> get selectedTruckHour => _truckhour;
  List<ProjectEquipment> get selectedLastReading => _lastreading;

  set setselectedFieldName(String value) {
    _selectedField = value;
    notifyListeners();
  }

  bool selectedWorkHourPresent(WorkHours whr) {
    var result = false;
    for (var mwhr in _whrs) {
      if (mwhr.crew.id == whr.crew.id && mwhr.tsproject.id == whr.tsproject.id) {
        result = true;
      }
    }
    return result;
  }

  bool selectedEquipmentHourPresent(ProjectEquipment pequipment) {
    var result = false;
    for (var whr in _ehrs) {
      if (whr.id == pequipment.id) {
        result = true;
      }
    }
    return result;
  }

  bool selectedLastReadingPresent(ProjectEquipment pequipment) {
    var result = false;
    for (var last in _lastreading) {
      if (last.id == pequipment.id) {
        result = true;
      }
    }
    return result;
  }

  bool selectedQuantityPresent(TimeSheetProject tsproject) {
    var result = false;
    for (var tsquantity in _quantity) {
      if (tsquantity.id == tsproject.id) {
        result = true;
      }
    }
    return result;
  }

  set setSelectedTimesheetProject(TimeSheetProject tsproject) {
    _quantity.add(tsproject);
    notifyListeners();
  }

  set setSelectedWorkHours(WorkHours whrs) {
    _whrs.add(whrs);
    notifyListeners();
  }

  //for resource
  bool selectedResourcePresent(Resources resource) {
    var result = false;
    for (var res in _resource) {
      if (resource.id == res.id) {
        result = true;
      }
    }
    return result;
  }

  //for resource
  bool selectedTruckLoadPresent(Truck truck) {
    var result = false;
    for (var res in _truckload) {
      if (res.id == truck.id) {
        result = true;
      }
    }
    return result;
  }

  bool selectedTruckHourPresent(Truck truck) {
    var result = false;
    for (var res in _truckhour) {
      if (res.id == truck.id) {
        result = true;
      }
    }
    return result;
  }

  set setSelectedProjectResource(Resources resource) {
    _resource.add(resource);
    notifyListeners();
  }

  set setSelectedLastReading(List<ProjectEquipment> equipment) {
    _lastreading.addAll(equipment);
    notifyListeners();
  }

  set setSelectedEquipment(ProjectEquipment pequipment) {
    _ehrs.add(pequipment);
    notifyListeners();
  }

  set setSelectedTruckLoad(Truck truck) {
    _truckload.add(truck);
    notifyListeners();
  }

  set setSelectedTruckHour(Truck truck) {
    _truckhour.add(truck);
    notifyListeners();
  }

  void toggleKeypad() {
    _selected = !_selected;
    notifyListeners();
  }

  void enableKeypad() {
    _selected = true;
    notifyListeners();
  }

  void disableKeypad() {
    _selected = false;
    notifyListeners();
  }

  void updateWorkHours(double value) {
    for (var uwhr in _whrs) {
      uwhr.setWorkhr = value;
    }
    notifyListeners();
  }

  void updateTimesheetProjectQuantity(double value) {
    for (var tsproject in _quantity) {
      tsproject.setQuantity = value;
    }
    notifyListeners();
  }

  void updateProjectResource(double value) {
    for (var res in _resource) {
      res.setValueActual = value;
    }
    notifyListeners();
  }

  void updateTruckLoad(double value) {
    for (var res in _truckload) {
      res.setLoad = value;
    }
    notifyListeners();
  }

  void updateTruckHour(double value) {
    for (var res in _truckhour) {
      res.setHour = value;
    }
    notifyListeners();
  }

  void updateEquipmentHours(double value) {
    for (var ehr in _ehrs) {
      ehr.setEquipmentHours = value;
    }
    notifyListeners();
  }

  void updateLastReading(double value) {
    for (var last in _lastreading) {
      last.setLastReading = value;
    }
    notifyListeners();
  }

  void removeEquipmentHours(ProjectEquipment whr) {
    _ehrs.removeWhere((ehr) => (ehr.id == whr.id));
    notifyListeners();
  }

  void removeLastReading(List<ProjectEquipment> lastreadings) {
    for (var lastreading in lastreadings) {
      _lastreading.removeWhere((ehr) => (ehr.id == lastreading.id));
    }
    notifyListeners();
  }

  void removeWorkHours(WorkHours whr) {
    _whrs.removeWhere((rwhr) => (rwhr.tsproject.id == whr.tsproject.id && rwhr.crew.id == whr.crew.id));
    notifyListeners();
  }

  void removeTimesheetProject(TimeSheetProject tsproject) {
    _quantity.removeWhere((qty) => (qty.id == tsproject.id));
    notifyListeners();
  }

  void removeProjectResource(Resources resource) {
    _resource.removeWhere((res) => (res.id == resource.id));
    notifyListeners();
  }

  void removeTruckLoad(Truck truck) {
    _truckload.removeWhere((res) => (res.id == truck.id));
    notifyListeners();
  }

  void removeTruckHour(Truck truck) {
    _truckhour.removeWhere((res) => (res.id == truck.id));
    notifyListeners();
  }

  void clearAllSelections({field = "all"}) {
    switch (field) {
      case "resource":
        _truckhour.clear();
        _truckload.clear();
        _ehrs.clear();
        _quantity.clear();
        _whrs.clear();
        _lastreading.clear();

        break;
      case "workhour":
        _resource.clear();
        _truckhour.clear();
        _truckload.clear();
        _ehrs.clear();
        _lastreading.clear();

        _quantity.clear();
        break;
      case "truckload":
        _resource.clear();
        _lastreading.clear();

        _truckhour.clear();
        _ehrs.clear();
        _quantity.clear();
        _whrs.clear();
        break;
      case "truckhour":
        _resource.clear();
        _lastreading.clear();

        _truckload.clear();
        _ehrs.clear();
        _quantity.clear();
        _whrs.clear();
        break;
      case "quantity":
        _truckhour.clear();
        _truckload.clear();
        _ehrs.clear();
        _resource.clear();
        _lastreading.clear();

        _whrs.clear();
        break;
      case "equipment":
        _truckhour.clear();
        _truckload.clear();
        _resource.clear();
        _quantity.clear();
        _whrs.clear();
        _lastreading.clear();
        break;
      case "lastreading":
        _ehrs.clear();

        _truckhour.clear();
        _truckload.clear();
        _resource.clear();
        _quantity.clear();
        _whrs.clear();
        break;
      default:
        _resource.clear();
        _truckhour.clear();
        _truckload.clear();
        _ehrs.clear();
        _quantity.clear();
        _whrs.clear();
    }
  }
}
