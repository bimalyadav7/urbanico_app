import 'dart:convert';

import 'package:urbanico_app/model/subcontractorModel.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';

class DailyReportRepo extends BaseNotifierRepo {
  late String _materialDelivered;
  late String _workPerformed;
  late String _delays;
  late String _safetyAccidents;
  late String _visitors;
  late String _rework;
  late String _extraWork;
  late List<Subcontractor> _subcontractorList;

  DailyReportRepo(authRepo) : super(authRepo) {
    _init();
  }

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
    notifyListeners();
  }
}
