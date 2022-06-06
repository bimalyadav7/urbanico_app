import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:urbanico_app/models/costcode.model.dart';
import 'package:urbanico_app/models/phase.model.dart';
import 'package:urbanico_app/models/project.model.dart';
import 'package:urbanico_app/models/timesheetproject.model.dart';
import 'package:urbanico_app/models/user.model.dart';
import 'package:urbanico_app/models/workhour.model.dart';
import 'package:uuid/uuid.dart';

var timesheetNotifier = ChangeNotifierProvider<TimesheetProvider>((ref) => TimesheetProvider());

abstract class TimesheetProviderNotifiers {
  void notifyTimesheetProjects(Box<TimesheetProject> box);
  void notifyWorkhourData(Box<WorkhourData> box);
  void notifyUsers(Box<User> box);
}

class TimesheetProvider with ChangeNotifier implements TimesheetProviderNotifiers {
  List<WorkhourData> workhours = [];
  List<TimesheetProject> tsprojects = [];
  List<User> users = [];
  DateTime entryDate = DateTime.now();
  List<User> absentUsers = [];

  TimesheetProvider() {
    initBox();
  }

  void initBox() async {
    var tpbox = await Hive.openBox<TimesheetProject>('tsproject');
    var ubox = await Hive.openBox<User>('user');
    var whbox = await Hive.openBox<WorkhourData>('workhourdata');
    notifyTimesheetProjects(tpbox);
    notifyUsers(ubox);
    notifyWorkhourData(whbox);
    notifyListeners();
  }

  void clearBox() async {
    var tpbox = await Hive.openBox<TimesheetProject>('tsproject');
    var ubox = await Hive.openBox<User>('user');
    var whbox = await Hive.openBox<WorkhourData>('workhourdata');
    await tpbox.clear();
    await ubox.clear();
    await whbox.clear();
    notifyTimesheetProjects(tpbox);
    notifyUsers(ubox);
    notifyWorkhourData(whbox);
    notifyListeners();
  }

  void toggleWorkhourSelection(WorkhourData data) {
    data.selected = !data.selected;
    notifyListeners();
  }

  void updateWorkhour(WorkhourData data, double value) {
    data.workhour = value;
    data.save();
    notifyListeners();
  }

  void addWorkhour(WorkhourData data) {
    var box = Hive.box<WorkhourData>('workhourdata');
    box.add(data);
    notifyWorkhourData(box);
  }

  void makeAbsent(User user) {
    absentUsers.add(user);
    notifyListeners();
  }

  void makePresent(User user) {
    absentUsers.removeWhere((element) => element == user);
    notifyListeners();
  }

  void addProject() {
    String puuid = Uuid().v1();
    String phuuid = Uuid().v1();
    String ccid = Uuid().v1();

    Project p = Project(projectID: puuid, projectCode: "projectCode", projectName: "projectName", projectDesc: "projectDesc");
    Phase ph = Phase(parentID: puuid, phaseid: "ID", projectID: phuuid, phasecode: "phasecode", phasedesc: "phasedesc");
    CostCode cc = CostCode(costcodeID: ccid, costcodeName: "costcodeName", costcodeDesc: "costcodeDesc");
    TimesheetProject tsproject = TimesheetProject(project: p, phase: ph, costcode: cc, quantity: 0);
    var box = Hive.box<TimesheetProject>('tsproject');

    box.add(tsproject);
    notifyTimesheetProjects(box);
    notifyListeners();
  }

  void removeProject(TimesheetProject tsproject) {
    var box = Hive.box<TimesheetProject>('tsproject');
    var whbox = Hive.box<WorkhourData>('workhourData');
    List<WorkhourData> matchedData = whbox.values.where((element) => element.tsproject == tsproject).toList();
    for (var element in matchedData) {
      element.delete();
    }
    tsproject.delete();
    notifyTimesheetProjects(box);
    notifyWorkhourData(whbox);
    notifyListeners();
  }

  void addUser() async {
    var box = await Hive.openBox<User>('user');
    box.add(User(userID: Uuid().v1(), name: "name", contact: "contact"));
    notifyUsers(box);
    notifyListeners();
  }

  void removeUser(User user) {
    var box = Hive.box<User>('user');
    var whbox = Hive.box<WorkhourData>('workhourData');
    List<WorkhourData> matchedData = whbox.values.where((element) => element.user == user).toList();
    for (var element in matchedData) {
      element.delete();
    }
    user.delete();
    notifyUsers(box);
    notifyWorkhourData(whbox);
    notifyListeners();
  }

  double getWorkhourTotalForUser(User user) {
    double temp = 0;
    for (int i = 0; i < workhours.length; i++) {
      if (workhours[i].user == user) {
        temp += workhours[i].workhour;
      }
    }
    return temp;
  }

  double getWorkhourTotalForProject(TimesheetProject tsp) {
    double temp = 0;
    for (int i = 0; i < workhours.length; i++) {
      if (workhours[i].tsproject == tsp) {
        temp += workhours[i].workhour;
      }
    }
    return temp;
  }

  double getAllTotal() {
    double total = 0;
    for (var hours in workhours) {
      total += hours.workhour;
    }
    return total;
  }

  @override
  void notifyTimesheetProjects(Box<TimesheetProject> box) {
    tsprojects = box.values.toList();
  }

  @override
  void notifyUsers(Box<User> box) {
    users = box.values.toList();
  }

  @override
  void notifyWorkhourData(Box<WorkhourData> box) {
    workhours = box.values.toList();
  }
}
