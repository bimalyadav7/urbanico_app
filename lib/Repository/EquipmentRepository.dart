import 'dart:convert';

import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/equipmentModel.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Request/equipment_api.dart';

class EquipmentRepository extends BaseNotifierRepo {
  final List<Equipment> _equipments = [];
  String _message = "";

  EquipmentRepository(authRepo) : super(authRepo) {
    // getAllEquipments();
  }

  List<Equipment> get listEquipments => _equipments;
  String get message => _message;

  set setEquipments(Equipment equipment) {
    _equipments.add(equipment);
    notifyListeners();
  }

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  Future<void> getAllEquipments({resync = false}) async {
    if (!(_equipments.isNotEmpty) || resync) {
      try {
        _equipments.clear();
        var response = await EquipmentApi().fetchAllEquipment();
        if (checkAuthenticationCode(response.statusCode)) {
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          setState = FutureState.Loading;
          var equipmentCode = '';
          var responseBody = jsonDecode(response.body);
          for (var equipment in responseBody["equipments"]) {
            Equipment newEquipment = Equipment.fromJson(equipment);
            if (equipmentCode != newEquipment.equipmentid) _equipments.add(newEquipment);
            equipmentCode = newEquipment.equipmentid;
          }
          setState = FutureState.Loaded;
        } else {
          setState = FutureState.Loaded;
        }
      } catch (err) {
        setState = FutureState.Loaded;
      }
    }
  }
}
