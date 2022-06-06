import 'dart:convert';

import 'package:urbanico_app/model/resourceModel.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';

class DailyEntryData {
  late String tsprojectID;
  late String projectID;
  late String costCodeID;
  late String userID;
  late String qty;
  late String workhour;

  DailyEntryData(tsprojectID, projectID, costCodeID, userID, quantity, workhour) {
    this.tsprojectID = tsprojectID;
    this.userID = userID;
    this.projectID = projectID;
    this.costCodeID = costCodeID;
    qty = quantity;
    this.workhour = workhour;
  }
  DailyEntryData.fromJson(Map<String, dynamic> json) {
    tsprojectID = '';
    userID = '';
    projectID = '';
    costCodeID = '';
    qty = '';
  }

  Map<String, String> toJson() {
    return {
      "tsprojectID": tsprojectID,
      "userID": userID,
      "projectID": projectID,
      "costCodeID": costCodeID,
      "qty": qty,
      "workhour": workhour,
    };
  }
}

class DailyResourceData {
  late String tsprojectID;
  late String projectID;
  late String costCodeID;
  late String qty;
  late String concrete;
  late String base;
  late String truck;
  late List<Map<String, String>> truckInfo;

  DailyResourceData(tsprojectID, projectID, costCodeID, quantity, aConcrete, aBase, aTruck, truckMap) {
    this.tsprojectID = tsprojectID;
    this.projectID = projectID;
    this.costCodeID = costCodeID;
    qty = quantity;
    concrete = aConcrete;
    base = aBase;
    truck = aTruck;
    truckMapper(truckMap);
  }

  void truckMapper(Map<int, Truck> truckMap) {
    truckInfo = [];
    truckMap.forEach((index, truck) {
      var value = {
        "truckname": truck.truckID,
        "ticket": truck.ticket,
        "truck_hours": truck.hour.toString(),
        "truck_loads": truck.load.toString(),
      };

      truckInfo.add(value);
    });
  }

  DailyResourceData.fromJson(Map<String, dynamic> json) {
    tsprojectID = '';
    projectID = '';
    costCodeID = '';
    qty = '';
    concrete = '';
    base = '';
    truck = '';
    truckInfo = [{}];
  }

  Map<String, String> toJson() {
    return {
      "tsprojectID": tsprojectID,
      "projectID": projectID,
      "costCodeID": costCodeID,
      "qty": qty,
      "actual_concrete_cy": concrete,
      "actual_base_ton": base,
      "actual_truck_hr": truck,
      "truck_info": jsonEncode(truckInfo)
    };
  }
}

class DailyEquipmentData {
  late String tsprojectID;
  late String projectID;
  late String costCodeID;
  late String qty;

  late List<Map<String, dynamic>> equipmentInfo;

  DailyEquipmentData(tsprojectID, projectID, costCodeID, quantity, equipmentMap) {
    this.tsprojectID = tsprojectID;
    this.projectID = projectID;
    this.costCodeID = costCodeID;
    qty = quantity;
    equipmentMapper(equipmentMap);
  }

  void equipmentMapper(Map<int, ProjectEquipment> equipmentMap) {
    equipmentInfo = [];
    equipmentMap.forEach((index, equipment) {
      var value = {
        "equipment": equipment.equipment.equipmentid,
        "equipment_hour": equipment.equipmentHours.toString(),
        "last_reading": equipment.lastreading.toString(),
      };

      equipmentInfo.add(value);
    });
  }

  DailyEquipmentData.fromJson(Map<String, dynamic> json) {
    tsprojectID = '';
    projectID = '';
    costCodeID = '';
    qty = '';
    equipmentInfo = [{}];
  }

  Map<String, dynamic> toJson() {
    return {"tsprojectID": tsprojectID, "projectID": projectID, "costCodeID": costCodeID, "qty": qty, "equipmentInfo": equipmentInfo};
  }
}

class PictureEntry {
  late String picture;
  late String description;

  PictureEntry(picture, description) {
    this.picture = picture;
    this.description = description;
  }
  // DailyEntry.fromJson(Map<String, dynamic> json) {
  //   userID = '';
  //   projectID = '';
  //   costCodeID='';
  //   qty = '';
  // }

  Map<String, dynamic> toJson() {
    return {
      "picture": picture,
      "description": description,
    };
  }
}

class DailyEntry {
  late String entrydate;
  late String entrypersonid;
  late String submitAction;
  late List<Map<String, dynamic>> dailyEntryList;

  DailyEntry(entrypersonid, entrydate, dailyEntryList) {
    submitAction = "Submit Timesheet";
    this.entrypersonid = entrypersonid;
    this.entrydate = entrydate;
    this.dailyEntryList = dailyEntryList;
  }
  // DailyEntry.fromJson(Map<String, dynamic> json) {
  //   userID = '';
  //   projectID = '';
  //   costCodeID='';
  //   qty = '';
  // }

  Map<String, dynamic> toJson() {
    return {"entrydate": entrydate, "entrypersonid": entrypersonid, "dailyEntryData": dailyEntryList, "submit_action": submitAction};
  }
}
