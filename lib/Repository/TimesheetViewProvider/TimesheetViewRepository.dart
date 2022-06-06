import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:urbanico_app/Request/project_setup_api.dart';
import 'package:urbanico_app/Request/user_api.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/costCodeModel.dart';
import 'package:urbanico_app/model/dailyEntryModal.dart';
import 'package:urbanico_app/model/equipmentModel.dart';
import 'package:urbanico_app/model/pictureModal.dart';
import 'package:urbanico_app/model/projectModel.dart';
import 'package:urbanico_app/model/resourceModel.dart';
import 'package:urbanico_app/model/subcontractorModel.dart';
import 'package:urbanico_app/model/userModel.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Request/timesheet_api.dart';
import 'package:http/http.dart' as http;
import 'package:urbanico_app/appConfig.dart';

Map<String, String> headerType = {
  "Content-Type": "application/x-www-form-urlencoded",
  "Authorization": "Bearer " + AppConfig().token.toString(),
  "APICaller": AppConfig().platform.toString(),
};

class TimeSheetViewRepo extends BaseNotifierRepo {
  late DateTime _date;
  late String _forDate;
  late String _forUserID;
  String _msg = "";
  String _templateStatus = "";
  Map<String, dynamic> _dailyReport = {};

  TimeSheetViewRepo(authRepo) : super(authRepo) {
    _forUserList = [];
    _forDate = "";
    _forUserID = "";
    _msg = "";
    _templateStatus = "";
    _dailyReport = {};
    _init();
  }

  final List<TimeSheetProject> _projects = [];
  final List<Crew> _crews = [];
  final List<Crew> _absentCrews = [];
  final List<String> _trucks = [];
  final List<WorkHours> _workHours = [];
  final List<Equipment> _equipmentList = [];
  final List<Picture> _pictures = [];
  List<User> _forUserList = [];

  String get forUser => _forUserID;
  String get forDate => _forDate;
  List<User> get forUserList => _forUserList;
  String get message => _msg;
  String get templateStatus => _templateStatus;
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

  DateTime get date => _date;

  Future<bool> isTimesheetDateFilled(DateTime pickedDate, String entrypersonid) async {
    try {
      var response = await TimeSheetApi().checkDateFilled(entrypersonid, pickedDate.toString().split(" ")[0].toString());
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
        return false;
      } else if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody["response"] == "true" || responseBody["response"] == true) return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  late String _materialDelivered;
  late String _workPerformed;
  late String _delays;
  late String _safetyAccidents;
  late String _visitors;
  late String _rework;
  late String _extraWork;
  late List<Subcontractor> _subcontractorList;

  void _init() {
    _workPerformed = "";
    _materialDelivered = "";
    _delays = "";
    _safetyAccidents = "";
    _visitors = "";
    _rework = "";
    _extraWork = "";
    _subcontractorList = [];
  }

  Map<String, String> toJson() {
    List<Map<String, String>> subcontractordata = [];
    for (var sub in subContractorList) {
      var value = {
        "sc_name": sub.subcontractorName.trim(),
        "sc_desc": sub.description.trim(),
        "sc_qty": sub.quantity.trim(),
      };
      subcontractordata.add(value);
    }
    return {
      "workperformed": workPerformed.trim(),
      "materialdelivery": materialDelivered.trim(),
      "safetyoraccidents": safetyAccidents.trim(),
      "visitors": visitors.trim(),
      "delays": delays.trim(),
      "rework": rework.trim(),
      "extrawork": extraWork.trim(),
      "subcontractors": jsonEncode(subcontractordata)
    };
  }

  String get materialDelivered => _materialDelivered;
  String get workPerformed => _workPerformed;
  String get delays => _delays;
  String get safetyAccidents => _safetyAccidents;
  String get visitors => _visitors;
  String get rework => _rework;
  String get extraWork => _extraWork;

  List<Subcontractor> get subContractorList => _subcontractorList;

  Future<void> getDailyReportByDate(String userid, String date) async {
    String _latestdate = date.split(" ")[0];
    try {
      var dailyReportRes = await TimeSheetApi().getDailyReport(userid, _latestdate);
      if (checkAuthenticationCode(dailyReportRes.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (dailyReportRes.statusCode == 200) {
        Map resBody = jsonDecode(dailyReportRes.body)["response"][0];
        List subContractor = jsonDecode(dailyReportRes.body)["subcontractors"];

        setMaterialDelivered = resBody["materialdelivery"];
        setRework = resBody["rework"];
        setExtraWork = resBody["extrawork"];
        setSafetyAccidents = resBody["safetyoraccidents"];
        setVisitors = resBody["visitors"];
        setWorkPerformed = resBody["workperformed"];
        setDelays = resBody["delays"];
        for (var subcontractor in subContractor) {
          Subcontractor sub = Subcontractor();
          sub.setContractorName = subcontractor["sc_name"];
          sub.setDescription = subcontractor["sc_desc"];
          sub.setQuantity = subcontractor["sc_qty"];
          addSubContractor = sub;
        }
      }
    } catch (err) {
      _init();
    }
  }

  set setForUserList(List<User> value) {
    _forUserList = value;
    notifyListeners();
  }

  set setForDate(String value) {
    _forDate = value;
    setState = FutureState.Uninitialized;
    // notifyListeners();
  }

  set setForUser(String value) {
    _forUserID = value;
    notifyListeners();
  }

  set setMaterialDelivered(String value) {
    _materialDelivered = value;
    notifyListeners();
  }

  set setWorkPerformed(String value) {
    _workPerformed = value;
    notifyListeners();
  }

  set setDelays(String value) {
    _delays = value;
    notifyListeners();
  }

  set setSafetyAccidents(String value) {
    _safetyAccidents = value;
    notifyListeners();
  }

  set setVisitors(String value) {
    _visitors = value;
    notifyListeners();
  }

  set setRework(String value) {
    _rework = value;
    notifyListeners();
  }

  set setExtraWork(String value) {
    _extraWork = value;
    notifyListeners();
  }

  set addSubContractor(Subcontractor sub) {
    _subcontractorList.add(sub);
    notifyListeners();
  }

  removeSubContractor(Subcontractor sub) {
    _subcontractorList.remove(sub);
    notifyListeners();
  }

  void clearDailyReport() {
    _subcontractorList.clear();
    _init();
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

  set setTemplateStatus(String msg) {
    _templateStatus = msg;
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
    _date = DateTime.now();
    _templateStatus = "";
    _projects.clear();
    _crews.clear();
    _workHours.clear();
    _trucks.clear();
    _equipmentList.clear();
    _msg = "";
    if (_dailyReport.isNotEmpty) _dailyReport.clear();
    _absentCrews.clear();
    _pictures.clear();
  }

  Future setMaterialValues() async {
    setState = FutureState.Loading;
    for (int i = 0; i < _projects.length; i++) {
      var response = await ProjectSetupApi().fetchCostCodeResource(_projects[i].phase.projectID, _projects[i].costCode.costcodeID);
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        Map<String, dynamic> data = responseBody["response"];
        _projects[i].concrete.setValueMath = double.parse(data["concunit"]);
        _projects[i].base.setValueMath = double.parse(data["baseunit"]);
        _projects[i].truck.setValueMath = double.parse(data["truckunit"]);
      }
    }
    setState = FutureState.Loaded;
  }

  Future parseEntryPostData(String entrypersonid) async {
    var result = await TimeSheetApi().postDailyEntry(parseWorkHourEntry(entrypersonid), parseResourceEntry(entrypersonid),
        parseEquipmentEntry(entrypersonid), dailyReport, parseAbsentEmployeeData(), parsePicturesData());
    if (checkAuthenticationCode(result.statusCode)) {
      setState = FutureState.Unauthenticated;
    }
    return result;
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
          workhour.tsproject.project.projectID,
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
          tsproject.project.projectID,
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
      DailyEquipmentData dentrydata = DailyEquipmentData(tsproject.id.toString(), tsproject.project.projectID,
          tsproject.costCode.costcodeID, tsproject.quantity.toString(), tsproject.listEquipments.asMap());
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

  Future<List<User>> getAllUser({bool resync = false}) async {
    List<User> users = [];
    try {
      http.Response response = await UserApi().fetchAllUser();
      var userContact = '';
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        for (var user in responseBody["response"]) {
          User newUser = User.fromJson(user);
          if (userContact != newUser.contact) users.add(newUser);
          userContact = newUser.contact;
        }
      }
      return users;
    } catch (err) {
      return users;
    }
  }

  Future<void> getLatestEntryByDate({fordate = ""}) async {
    clearLists();
    String date = (fordate == "") ? _forDate : fordate;
    String _latestdate = date;
    _date = DateTime.parse(date);
    try {
      var overallRes = await TimeSheetApi().getRowColumnCountForDate(userRepo.authUser.userID, _latestdate);
      var timesheetRes = await TimeSheetApi().getWorkHoursByDate(userRepo.authUser.userID, _latestdate);
      var resourceRes = await TimeSheetApi().getResourceByDate(userRepo.authUser.userID, _latestdate);
      var equipmentRes = await TimeSheetApi().getEquipmentByDate(userRepo.authUser.userID, _latestdate);
      var pictureRes = await TimeSheetApi().getPictureByDate(userRepo.authUser.userID, _latestdate);
      var absentRes = await TimeSheetApi().getAbsentByDate(userRepo.authUser.userID, _latestdate);
      var truckRes = await TimeSheetApi().getTruckByDate(userRepo.authUser.userID, _latestdate);

      if (checkAuthenticationCode(overallRes.statusCode) ||
          checkAuthenticationCode(timesheetRes.statusCode) ||
          checkAuthenticationCode(resourceRes.statusCode) ||
          checkAuthenticationCode(equipmentRes.statusCode) ||
          checkAuthenticationCode(pictureRes.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (timesheetRes.statusCode == 200 &&
          resourceRes.statusCode == 200 &&
          equipmentRes.statusCode == 200 &&
          pictureRes.statusCode == 200) {
        setState = FutureState.Loading;

        _forUserList = await getAllUser();
        if (_forUserList.isEmpty) {
          _msg = "fail";
          setState = FutureState.Loaded;
          return;
        }
        List overallResBody = jsonDecode(overallRes.body)["response"];
        List timesheetResBody = jsonDecode(timesheetRes.body)["response"];
        List resourceResBody = jsonDecode(resourceRes.body)["response"];
        List equipmentResBody = jsonDecode(equipmentRes.body)["response"];
        List pictureResBody = jsonDecode(pictureRes.body)["images"];
        List absentResBody = jsonDecode(absentRes.body)["response"];
        List truckResBody = jsonDecode(truckRes.body)["response"];
        TimeSheetProject tempProject = TimeSheetProject();
        Crew thisCrew = Crew();

        // for (var data in timesheetResBody) {
        for (var data in overallResBody) {
          var tsdataTS = timesheetResBody.firstWhere(
              (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
              orElse: () => false);
          TimeSheetProject tsproject = TimeSheetProject();
          Project project = Project();
          CostCode costCode = CostCode();
          if (tsdataTS == false) {
            var tsdataEQ = equipmentResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => false);
            project = Project.fromJson(tsdataEQ);
            costCode = CostCode.fromJson(tsdataEQ);
          } else {
            project = Project.fromJson(tsdataTS);
            costCode = CostCode.fromJson(tsdataTS);
          }
          tsproject.setProject = project;
          tsproject.setCostCode = costCode;
          tsproject.setQuantity = double.parse(data['qty'] ?? "0");
          if (!(tempProject.project.projectID == tsproject.project.projectID &&
              tempProject.costCode.costcodeID == tsproject.costCode.costcodeID)) {
            var equipments = equipmentResBody
                .where((element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']));

            for (var element in equipments) {
              Equipment equipment = Equipment.fromJsonForView(element);
              ProjectEquipment pequipment = ProjectEquipment();
              pequipment.setEquipment = equipment;
              pequipment.setEquipmentHours = double.parse(element["equipmenthour"] ?? "0");
              pequipment.setLastReading = double.parse(element["lastreading"] ?? "0");
              tsproject.setEquipment = pequipment;
            }
            Base baseVal = Base();
            baseVal.setValueMath = double.parse(resourceResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => {"mathbaseton": "0"})["mathbaseton"]);
            baseVal.setValueActual = double.parse(resourceResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => {"actual_base_ton": "0"})["actual_base_ton"]);

            Concrete concreteVal = Concrete();
            concreteVal.setValueMath = double.parse(resourceResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => {"mathconcretecy": "0"})["mathconcretecy"]);

            concreteVal.setValueActual = double.parse(resourceResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => {"actualconcretey": "0"})["actualconcretey"]);
            TruckValue truckVal = TruckValue();
            truckVal.setValueMath = double.parse(resourceResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => {"mathtruckhr": "0"})["mathtruckhr"]);
            truckVal.setValueActual = double.parse(resourceResBody.firstWhere(
                (element) => (element["projectID"] == data['projectID'] && element["costcodeID"] == data['costcodeID']),
                orElse: () => {"actual_truck_hr": "0"})["actual_truck_hr"]);
            for (int j = 0; j < truckResBody.length; j++) {
              if (truckResBody[j]["costcodeID"] == tsproject.costCode.costcodeID &&
                  truckResBody[j]["projectID"] == tsproject.project.projectID) {
                Truck truck = Truck();
                truck.setHour = double.parse(truckResBody[j]["truckhours"] ?? "0");
                truck.setLoad = double.parse(truckResBody[j]["truckloads"] ?? "0");
                truck.setTicket = truckResBody[j]["ticket"];
                truck.setTruckID = truckResBody[j]["truckname"];
                tsproject.setTruckInList = truck;
                if (!_trucks.contains(truckResBody[j]["truckname"])) _trucks.add(truckResBody[j]["truckname"]);
              }
            }

            tsproject.setConcrete = concreteVal;
            tsproject.setBase = baseVal;
            tsproject.setTruck = truckVal;
            _projects.add(tsproject);
            tempProject = tsproject;
          } else {
            tsproject = tempProject;
          }
          if (tsdataTS) {
            WorkHours workHour = WorkHours();

            User user = forUserList.firstWhere((element) => (element.userID == tsdataTS["userID"]));
            thisCrew = Crew();
            thisCrew.setCrew = user;
            bool presentUser = false;
            for (var element in _crews) {
              if (element.crew.userID == user.userID) presentUser = true;
            }

            if (!presentUser) {
              _crews.add(thisCrew);
            }

            workHour.setCrew = thisCrew;
            workHour.setTSProject = tsproject;
            workHour.setWorkhr = double.parse(tsdataTS['work_hour'] ?? "0");

            _workHours.add(workHour);
          }
        }

        for (var element in _projects[0].listEquipments) {
          setEquipment = element.equipment;
        }
        for (int k = 0; k < absentResBody.length; k++) {
          User absUser = User.fromJson(absentResBody[k]);
          absUser.userID = absentResBody[k]["userid"];
          Crew absCrew = Crew();
          absCrew.setCrew = absUser;
          absCrew.setAttendance = false;
          _crews.add(absCrew);
          _absentCrews.add(absCrew);
        }
        for (var i = 0; i < pictureResBody.length; i++) {
          Picture picture = Picture();
          var rng = Random();
          Directory tempDir = await Directory.systemTemp.createTemp();
          http.Response imageRes = await http.get(Uri.parse(AppConfig().baseUrl + pictureResBody[i]["image_url"]), headers: headerType);
          if (checkAuthenticationCode(imageRes.statusCode)) {
            setState = FutureState.Unauthenticated;
          }
          File file = File(tempDir.path + rng.nextInt(100).toString());
          file.writeAsBytesSync(imageRes.bodyBytes);
          picture.setDescription = pictureResBody[i]["notes"];
          picture.setPicture = file;
          setPictures = picture;
        }
        await getDailyReportByDate(userRepo.authUser.userID, date);
        setState = FutureState.Loaded;
      } else {
        _msg = "fail";
        setState = FutureState.Loaded;
      }
    } catch (err) {
      _msg = "fail";
      setState = FutureState.Loaded;
    }
  }

  void testSomeThings() {
    UserRepository userRepo = UserRepository();
    print(userRepo.authUser);
  }

  Future<void> getCrewListForForeman(String userid) async {
    try {
      if (templateStatus == "success") {
        setTemplateStatus = "success";
      } else {
        var response = await TimeSheetApi().getForemanCrewList(userid);
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          for (var data in responseBody) {
            User user = User.fromJson(data);
            Crew crew = Crew();
            crew.setCrew = user;
            _crews.add(crew);
          }
          setTemplateStatus = "success";
        } else {
          setTemplateStatus = "No Data";
        }
      }
    } catch (err) {
      setTemplateStatus = "Error: ${err.toString()}";
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
