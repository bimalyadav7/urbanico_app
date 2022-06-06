import 'dart:convert';
import 'package:http/http.dart';
import 'package:urbanico_app/Exceptions/TimesheetValidationException.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/costCodeModel.dart';
import 'package:urbanico_app/model/dailyEntryModal.dart';
import 'package:urbanico_app/model/equipmentModel.dart';
import 'package:urbanico_app/model/phaseModel.dart';
import 'package:urbanico_app/model/pictureModal.dart';
import 'package:urbanico_app/model/projectModel.dart';
import 'package:urbanico_app/model/resourceModel.dart';
import 'package:urbanico_app/model/userModel.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Request/auth_api.dart';
import 'package:urbanico_app/Request/equipment_api.dart';
import 'package:urbanico_app/Request/project_setup_api.dart';
import 'package:urbanico_app/Request/timesheet_api.dart';

class TimeSheet extends BaseNotifierRepo {
  DateTime? _date;
  String _msg = "";
  FutureState _templateStatus = FutureState.Uninitialized;
  String _equipmentTemplateStatus = "";
  Map<String, dynamic> _dailyReport = {};

  TimeSheet(authRepo) : super(authRepo) {
    _msg = "";
    _templateStatus = FutureState.Uninitialized;
    _dailyReport = {};
    _date = null;
  }

  final List<TimeSheetProject> _projects = [];
  final List<Crew> _crews = [];
  final List<Crew> _absentCrews = [];
  final List<String> _trucks = [];
  final List<WorkHours> _workHours = [];
  final List<Equipment> _equipmentList = [];
  final List<Picture> _pictures = [];

  String get message => _msg;
  FutureState get templateStatus => _templateStatus;
  String get equipmentTemplateStatus => _equipmentTemplateStatus;
  List<TimeSheetProject> get listProjects => _projects;
  List<Crew> get listCrews => _crews;
  List<Crew> get listAbsentCrews => _absentCrews;
  List<String> get listTruckName => _trucks;
  List<Equipment> get listEquipments => _equipmentList;

  Map<String, dynamic> get dailyReport => _dailyReport;
  List<WorkHours> get listWorkHours => _workHours;
  List<Picture> get pictures => _pictures;
  String getTicketForTruck(String truckname) {
    String ticket = "";
    for (var tsproject in _projects) {
      Truck truck = tsproject.listTruck.singleWhere((test) => (test.truckID == truckname));
      ticket = truck.ticket;
    }
    return ticket;
  }

  DateTime? get date => _date;

  Future<bool> isTimesheetDateFilled(DateTime pickedDate, String entrypersonid) async {
    try {
      Response response = await TimeSheetApi().checkDateFilled(entrypersonid, pickedDate.toString().split(" ")[0].toString());
      if (checkAuthenticationCode(response.statusCode)) {
        return true;
      } else if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody["response"] == "true" || responseBody["response"] == true) return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  void clearWorkHourData() {
    _workHours.clear();
    notifyListeners();
  }

  void clearMaterials() {
    _projects.map((tsproject) {
      tsproject.clearMaterialValues();
    });
    notifyListeners();
  }

  void clearEquipments() {
    // _equipmentList.clear();
    _projects.map((tsproject) {
      tsproject.clearEquipmentValues();
    });
    notifyListeners();
  }

  set setPictures(Picture pic) {
    _pictures.add(pic);
    notifyListeners();
  }

  removePictures(Picture pic) {
    _pictures.remove(pic);
    notifyListeners();
  }

  set setMessage(String msg) {
    _msg = msg;
    notifyListeners();
  }

  set setTruck(String truckname) {
    _trucks.add(truckname);
    notifyListeners();
  }

  set setTemplateStatus(FutureState msg) {
    _templateStatus = msg;
    notifyListeners();
  }

  set setEquipmentTemplateStatus(String msg) {
    _equipmentTemplateStatus = msg;
    notifyListeners();
  }

  set setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  set setProjectsAll(List<TimeSheetProject> costcodes) {
    _projects.addAll(costcodes);
    notifyListeners();
  }

  set setProjects(TimeSheetProject costcode) {
    _projects.add(costcode);
    notifyListeners();
  }

  set setWorkHours(WorkHours whrs) {
    _workHours.add(whrs);
  }

  set removeWorkHours(WorkHours whrs) {
    _workHours.remove(whrs);
    notifyListeners();
  }

  set removeTruckName(String truck) {
    _trucks.remove(truck);
    for (var tsproject in _projects) {
      Truck removeTruck = tsproject.listTruck.singleWhere((test) => (test.truckID == truck));
      tsproject.removeTruckFromList(removeTruck);
    }
    notifyListeners();
  }

  set setEquipment(Equipment equipment) {
    if (!listEquipments.contains(equipment)) _equipmentList.add(equipment);
    notifyListeners();
  }

  set removeEquipment(Equipment equipment) {
    _equipmentList.remove(equipment);
    notifyListeners();
  }

  set removeProjects(TimeSheetProject costcode) {
    _projects.remove(costcode);
    notifyListeners();
  }

  set removeCrews(Crew crew) {
    _crews.remove(crew);
    notifyListeners();
  }

  set setCrews(Crew crew) {
    if (!listCrews.contains(crew)) _crews.add(crew);
    notifyListeners();
  }

  set setAbsentCrew(Crew crew) {
    crew.setAttendance = false;
    for (var whrs in _workHours) {
      if (whrs.crew.id == crew.id) {
        whrs.setWorkhr = 0.0;
      }
    }
    _absentCrews.add(crew);
    notifyListeners();
  }

  removeAbsentCrew(Crew crew) {
    crew.setAttendance = true;
    _absentCrews.remove(crew);
    notifyListeners();
  }

  set setDailyReport(Map<String, dynamic> dailyReport) {
    _dailyReport = dailyReport;
    notifyListeners();
  }

  void clearLists() {
    _date = null;
    _templateStatus = FutureState.Uninitialized;
    _equipmentTemplateStatus = "";
    _projects.clear();
    _crews.clear();
    _workHours.clear();
    _trucks.clear();
    _equipmentList.clear();
    _msg = "";
    if (_dailyReport.isNotEmpty) _dailyReport.clear();
    _absentCrews.clear();
    _pictures.clear();
    notifyListeners();
  }

  Future setMaterialValues() async {
    for (int i = 0; i < _projects.length; i++) {
      var response = await ProjectSetupApi().fetchCostCodeResource(_projects[i].phase.projectID, _projects[i].costCode.costcodeID);
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        setState = FutureState.Loading;
        var responseBody = jsonDecode(response.body);
        Map<String, dynamic> data = responseBody["response"];
        _projects[i].concrete.setValueMath = double.parse(data["concunit"]);
        _projects[i].base.setValueMath = double.parse(data["baseunit"]);
        _projects[i].truck.setValueMath = double.parse(data["truckunit"]);
      }
    }
    setState = FutureState.Loaded;
  }

  validateEntryPostData(String entrypersonid) {
    DailyEntry parsedWorkHourEntry = parseWorkHourEntry(entrypersonid);
    try {
      bool responseWorkHour = validateWorkHoursData(parsedWorkHourEntry);
      bool responseEquipment = validateEquipmentsData();
      if (responseWorkHour && responseEquipment) {
        return true;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future parseEntryPostData(String entrypersonid) async {
    DailyEntry parsedEquipmentEntry = parseEquipmentEntry(entrypersonid);
    DailyEntry parsedWorkHourEntry = parseWorkHourEntry(entrypersonid);

    // Map<String, String> responseWorkHour =
    //     validateWorkHoursData(parsedWorkHourEntry);
    // Map<String, String> responseEquipment = validateEquipmentsData();
    // if (responseWorkHour["response"] == "Fail") {
    //   return jsonEncode({
    //     "response": responseWorkHour["response"],
    //     "err": responseWorkHo ur["err"],
    //     "controllerIndex": 0
    //   });
    // }
    // if (responseEquipment["response"] == "Fail") {
    //   return jsonEncode({
    //     "response": responseEquipment["response"],
    //     "err": responseEquipment["err"],
    //     "controllerIndex": 2
    //   });
    // }

    var result = await TimeSheetApi().postDailyEntry(parsedWorkHourEntry, parseResourceEntry(entrypersonid), parsedEquipmentEntry,
        dailyReport, parseAbsentEmployeeData(), parsePicturesData());
    return result.body;
  }

  bool validateWorkHoursData(DailyEntry parsedWorkHourEntry) {
    double workHourTotal = 0.0;
    for (int j = 0; j < parsedWorkHourEntry.dailyEntryList.length; j++) {
      workHourTotal += double.parse(parsedWorkHourEntry.dailyEntryList[j]['workhour']);
    }
    if (workHourTotal <= 0.0) {
      if (listEquipments.isNotEmpty && listProjects.isNotEmpty) return true;
      throw WorkHourException();
    }
    return true;
  }

  bool validateEquipmentsData() {
    for (int j = 0; j < listProjects.length; j++) {
      for (int i = 0; i < listProjects[j].listEquipments.length; i++) {
        if (!listProjects[j].listEquipments[i].isValid) {
          throw EquipmentReadingException(
              equipmentname: listProjects[j].listEquipments[i].equipment.equipmentname,
              previousReading: listProjects[j].listEquipments[i].prevlastreading);
        }
      }
    }

    for (int k = 0; k < listEquipments.length; k++) {
      double equipmentTotal = 0.0;
      for (int j = 0; j < listProjects.length; j++) {
        equipmentTotal += listProjects[j].listEquipments[k].equipmentHours;
      }
      if (equipmentTotal != 10.0) {
        throw EquipmentTotalHourException(equipmentname: listProjects[0].listEquipments[k].equipment.equipmentname);
      }
    }
    return true;
  }

  dynamic entryParseTest(String entrypersonid) {
    var result = {
      "timesheetData": parseWorkHourEntry(entrypersonid),
      "resourceData": parseResourceEntry(entrypersonid),
      "equipmentData": parseEquipmentEntry(entrypersonid),
      "dailyreportData": dailyReport,
      "absentEmployeeData": parseAbsentEmployeeData(),
      "pictureData": parsePicturesData()
    };
    return result;
  }

  DailyEntry parseWorkHourEntry(String entrypersonid) {
    List<Map<String, String>> postDataTimesheet = [];

    for (var workhour in listWorkHours) {
      DailyEntryData dentrydata = DailyEntryData(
          workhour.tsproject.id.toString(),
          workhour.tsproject.phase.projectID,
          workhour.tsproject.costCode.costcodeID,
          workhour.crew.crew.userID,
          workhour.tsproject.quantity.toString(),
          workhour.workhr.toString());
      postDataTimesheet.add(dentrydata.toJson());
    }

    DailyEntry dentryTimesheet = DailyEntry(entrypersonid, date.toString().split(" ")[0].toString(), postDataTimesheet);
    return dentryTimesheet;
  }

  DailyEntry parseResourceEntry(String entrypersonid) {
    List<Map<String, String>> postDataResource = [];

    for (var tsproject in listProjects) {
      DailyResourceData dentrydata = DailyResourceData(
          tsproject.id.toString(),
          tsproject.phase.projectID,
          tsproject.costCode.costcodeID,
          tsproject.quantity.toString(),
          tsproject.concrete.valueActual.toString(),
          tsproject.base.valueActual.toString(),
          tsproject.truck.valueActual.toString(),
          tsproject.listTruck.asMap());
      postDataResource.add(dentrydata.toJson());
    }

    DailyEntry dentryResource = DailyEntry(entrypersonid, date.toString().split(" ")[0].toString(), postDataResource);

    return dentryResource;
  }

  DailyEntry parseEquipmentEntry(String entrypersonid) {
    List<Map<String, dynamic>> postDataEquipment = [];

    for (var tsproject in listProjects) {
      DailyEquipmentData dentrydata = DailyEquipmentData(tsproject.id.toString(), tsproject.phase.projectID, tsproject.costCode.costcodeID,
          tsproject.quantity.toString(), tsproject.listEquipments.asMap());
      postDataEquipment.add(dentrydata.toJson());
    }

    DailyEntry dentryEquipment = DailyEntry(entrypersonid, date.toString().split(" ")[0].toString(), postDataEquipment);

    return dentryEquipment;
  }

  String parseAbsentEmployeeData() {
    List<String> absentEmp = _absentCrews.map((crew) {
      return crew.crew.userID;
    }).toList();
    return jsonEncode(absentEmp);
  }

  String parsePicturesData() {
    List<dynamic> picture = _pictures.map((pic) {
      PictureEntry picEntry = PictureEntry(base64Encode(pic.picture.readAsBytesSync()), pic.description);
      return picEntry;
    }).toList();
    return jsonEncode(picture);
  }

  void testSomeThings() {
    UserRepository userRepo = UserRepository();
    print(userRepo.authUser);
  }

  Future<void> getCrewListForForeman(String userid) async {
    try {
      if (_templateStatus == FutureState.Loaded) {
        _templateStatus = FutureState.Loaded;
      } else {
        _templateStatus = FutureState.Loading;
        var response = await TimeSheetApi().getForemanCrewList(userid);
        if (checkAuthenticationCode(response.statusCode)) {
          _templateStatus = FutureState.Uninitialized;
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          _crews.clear();
          for (var data in responseBody) {
            User user = User.fromJson(data);
            Crew crew = Crew();
            crew.setCrew = user;
            _crews.add(crew);
          }
          _templateStatus = FutureState.Loaded;
        } else {
          _templateStatus = FutureState.Loaded;
        }
      }
      notifyListeners();
    } catch (err) {
      _templateStatus = FutureState.Uninitialized;
      setState = FutureState.Loaded;
    }
  }

  Future<void> getEquipmentTemplate(String userid) async {
    try {
      if (equipmentTemplateStatus == "success") {
        _equipmentTemplateStatus = "success";
      } else {
        var response = await EquipmentApi().fetchTemplateEquipment(userid);
        if (checkAuthenticationCode(response.statusCode)) {
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          _equipmentList.clear();
          for (var project in listProjects) {
            project.clearEquipmentValues();
          }
          var responseBody = jsonDecode(response.body);
          for (var data in responseBody["data"]) {
            Equipment temp = Equipment.fromJsonForView(data);
            _equipmentList.add(temp);
          }

          for (var i = 0; i < listProjects.length; i++) {
            for (var j = 0; j < listEquipments.length; j++) {
              ProjectEquipment tempequipment = ProjectEquipment();
              tempequipment.setEquipment = listEquipments[j];
              tempequipment.setIsTemplate = true;
              listProjects[i].setEquipment = tempequipment;
            }
          }
          _equipmentTemplateStatus = "success";
        } else if (response.statusCode == 404) {
          var response = await AuthApi().refreshToken();
          if (response.statusCode == 200) {
            var responseBody = jsonDecode(response.body);
            if (responseBody["response"] == "success") {
              return responseBody["token"];
            }
          }
        } else {
          _equipmentTemplateStatus = "No Data";
        }
      }
      notifyListeners();
    } catch (err) {
      _equipmentTemplateStatus = "error";
      setState = FutureState.Loaded;
    }
  }

  void refresh() {
    notifyListeners();
  }
}

class TimeSheetProject {
  late int _id;
  late Project _project;
  late Phase _phase;
  late CostCode _costCode;
  late double _quantity;
  late Concrete _concrete;
  late Base _base;
  late TruckValue _truckValue;
  late List<Truck> _trucks;
  late List<ProjectEquipment> _equipments;
  bool isEmpty = false;

  static int _idCount = 0;
  TimeSheetProject() {
    incrementID();
    _project = Project();
    _phase = Phase();
    _costCode = CostCode();
    _quantity = 0;
    _base = Base();
    _concrete = Concrete();
    _truckValue = TruckValue();
    _trucks = [];
    _equipments = [];
  }

  TimeSheetProject.emptyProject() {
    isEmpty = true;
  }

  int get id => _id;
  Project get project => _project;
  Phase get phase => _phase;
  CostCode get costCode => _costCode;
  double get quantity => _quantity;
  Concrete get concrete => _concrete;
  Base get base => _base;
  TruckValue get truck => _truckValue;
  List<Truck> get listTruck => _trucks;
  List<ProjectEquipment> get listEquipments => _equipments;

  set setQuantity(double qty) {
    _quantity = qty;
  }

  set setConcrete(Concrete conc) {
    _concrete = conc;
  }

  set setBase(Base base) {
    _base = base;
  }

  set setTruck(TruckValue truck) {
    _truckValue = truck;
  }

  set setTruckInList(Truck truck) {
    _trucks.add(truck);
  }

  set setEquipment(ProjectEquipment equipment) {
    _equipments.add(equipment);
  }

  set setEquipmentList(List<ProjectEquipment> equipmentlist) {
    _equipments.addAll(equipmentlist);
  }

  set setProject(Project project) {
    _project = project;
  }

  set setCostCode(CostCode costCode) {
    _costCode = costCode;
  }

  set setPhase(Phase phase) {
    _phase = phase;
  }

  // Future<void> setMaterialValue() async {
  //   var response = await ProjectSetupApi().fetchCostCodeResource(_phase.projectID, _costCode.costcodeID);
  //   if(checkauth)
  //   else if (response.statusCode == 200) {
  //     var responseBody = jsonDecode(response.body);
  //     Map<String, dynamic> data = responseBody["response"];
  //     _concrete.setValueMath = double.parse(data["concunit"]);
  //     _base.setValueMath = double.parse(data["baseunit"]);
  //     _truckValue.setValueMath = double.parse(data["truckunit"]);
  //   }
  // }

  removeCostCode() {
    _costCode.init();
  }

  removePhase() {
    _phase = Phase();
  }

  removeTruckFromList(Truck truck) {
    _trucks.remove(truck);
  }

  removeEquipment(ProjectEquipment equipment) {
    _equipments.remove(equipment);
  }

  bool checkEquipmentTemplate(Equipment equipment) {
    return _equipments.firstWhere((element) => element.equipment.equipmentid == equipment.equipmentid).isTemplate;
  }

  removeEquipmentByEquipmentid(Equipment equipment) {
    _equipments.removeWhere((pequipment) => pequipment.equipment.equipmentid == equipment.equipmentid);
  }

  clearMaterialValues() {
    _base.setValueActual = 0.0;
    _concrete.setValueActual = 0.0;
    _truckValue.setValueActual = 0.0;

    for (var truck in _trucks) {
      truck.setLoad = 0.0;
      truck.setHour = 0.0;
    }
  }

  clearEquipmentValues() {
    _equipments.clear();
  }

  void incrementID() {
    _id = _idCount;
    _idCount++;
  }
}

class Crew {
  late int _id;
  late User _crew;
  late bool _isPresent;
  Crew() {
    _crew = User();
    _id = -1;
    _isPresent = true;
  }

  int get id => _id;
  User get crew => _crew;
  bool get isPresent => _isPresent;

  set setCrew(User user) {
    _id = int.parse(user.userID);
    _crew = user;
  }

  set setAttendance(bool value) {
    _isPresent = value;
  }
}

class WorkHours {
  late double _workhr;
  late TimeSheetProject _tsproject;
  late Crew _crew;

  WorkHours() {
    _workhr = 0.0;
    _tsproject = TimeSheetProject();
    _crew = Crew();
  }

  double get workhr => _workhr;
  TimeSheetProject get tsproject => _tsproject;
  Crew get crew => _crew;

  set setWorkhr(double wh) {
    _workhr = wh;
  }

  set setTSProject(TimeSheetProject tsproject) {
    _tsproject = tsproject;
  }

  set setCrew(Crew crew) {
    _crew = crew;
  }
}

class ProjectEquipment {
  late int _id;
  late Equipment _equipment;
  late double _equipmentHours;
  late double _lastreading;

  late bool _isValid;
  bool _isTemplate = false;

  static int _idCount = 0;

  int get id => _id;

  Equipment get equipment => _equipment;
  double get equipmentHours => _equipmentHours;
  double get lastreading => _lastreading;
  double get prevlastreading => _equipment.lastreading;
  bool get isValid => _isValid;
  bool get isTemplate => _isTemplate;

  set setIsTemplate(bool template) {
    _isTemplate = template;
  }

  set setEquipment(Equipment equipment) {
    _equipment = equipment;
  }

  set setLastReading(double value) {
    _lastreading = value;
  }

  set setPrevLastReading(double value) {
    _equipment.lastreading = value;
  }

  set setEquipmentHours(double value) {
    _equipmentHours = value;
  }

  set setValid(bool value) {
    _isValid = value;
  }

  ProjectEquipment() {
    incrementID();
    _equipment = Equipment();
    _equipmentHours = 0.0;
    _lastreading = 0.0;
    _isValid = false;
  }

  void removeEquipment() {
    setEquipment = Equipment();
  }

  void removeEquipmentHours() {
    _equipmentHours = 0.0;
  }

  void incrementID() {
    _id = _idCount;
    _idCount++;
  }
}
