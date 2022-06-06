import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Request/POD/pod_api.dart';
import 'package:urbanico_app/enum/futureState.dart';

class PODRepository extends BaseNotifierRepo {
  late String _message;
  List _pods = [];
  String _currentPODDate = "";

  String get message => _message;
  String get currentPODDate => _currentPODDate;
  List get getPod => _pods;

  PODRepository(authRepo) : super(authRepo) {
    _pods = [];
    _message = "";
    var format = DateFormat("yyyy-MM-dd");
    String formattedDate = format.format(DateTime.now());
    _currentPODDate = formattedDate;
    setState = FutureState.Uninitialized;
  }

  set setCurrentPODDate(String date) {
    _currentPODDate = date;
    setState = FutureState.Uninitialized;
  }

  set setPod(List pods) {
    _pods = pods;
    notifyListeners();
  }

  set setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  Future<void> getPODByDate({bool resync = false}) async {
    try {
      _pods.clear();
      var response = await PODApi().fetchPODByDate(userRepo.authUser.userID, _currentPODDate);
      setState = FutureState.Loading;
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        for (var pod in responseBody["data"]) {
          _pods.add(pod);
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
