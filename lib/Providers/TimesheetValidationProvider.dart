import 'dart:async';

import 'package:flutter/foundation.dart';

class TimesheetValidationProvider extends ChangeNotifier {
  late Timer _timer;
  final int _duration = 12;

  int _tabIndex = -1;

  String _message = "";
  bool _isMessage = false;

  int get tabIndex => _tabIndex;
  bool get isMessage => _isMessage;
  String get message => _message;

  void setMessage(String message, int index) {
    try {
      _timer.cancel();
    } catch (err) {}
    _isMessage = true;
    _message = message;
    _tabIndex = index;
    notifyListeners();
    toggleMessage();
  }

  void toggleMessage() {
    _timer = Timer.periodic(Duration(seconds: _duration), (timer) {
      _tabIndex = -1;
      _message = "";
      _isMessage = false;
      timer.cancel();
      notifyListeners();
    });
  }
}
