import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Request/timesheet_api.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/foremanEntryModal.dart';

class ForemanEntryRepository extends BaseNotifierRepo {
  final List<ForemanEntry> _foremanEntries = [];
  String _message = "";
  String _foremanid = "";
  String _currentTimesheetDate = "";

  ForemanEntryRepository(authRepo) : super(authRepo) {
    var format = DateFormat("yyyy-MM-dd");
    String formattedDate = format.format(DateTime.now());
    _currentTimesheetDate = formattedDate;
  }
  ForemanEntry get listCurrentEntry {
    return _foremanEntries.firstWhere((element) => element.date == _currentTimesheetDate, orElse: () => ForemanEntry());
  }

  List<ForemanEntry> get listAllEntries => _foremanEntries;
  String get message => _message;
  String get currentTimesheetDate => _currentTimesheetDate;
  String get foremanid => _foremanid;

  set setCurrentTimesheetDate(String date) {
    _currentTimesheetDate = date;
    notifyListeners();
  }

  set setForemanID(String foremanid) {
    _foremanid = foremanid;
    notifyListeners();
  }

  set setEntries(ForemanEntry foremanentry) {
    _foremanEntries.add(foremanentry);
    notifyListeners();
  }

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  Future<void> getAllEntriesByForeman({bool resync = false}) async {
    try {
      if (_foremanEntries.isNotEmpty && !resync) {
        setState = FutureState.Loaded;
      } else {
        Response response = await TimeSheetApi().getForemanTimesheetEntry(userRepo.authUser.userID);
        if (checkAuthenticationCode(response.statusCode)) {
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          for (var entry in responseBody) {
            ForemanEntry newEntry = ForemanEntry.fromJson(entry);
            _foremanEntries.add(newEntry);
          }
          setState = FutureState.Loaded;
        } else {
          setState = FutureState.Loaded;
        }
      }
    } catch (err) {
      setState = FutureState.Loaded;
    }
  }
}
