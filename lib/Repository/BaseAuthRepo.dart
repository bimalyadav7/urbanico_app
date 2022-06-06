import 'package:flutter/cupertino.dart';
import 'package:urbanico_app/enum/authStatus.dart';

class BaseAuthRepo extends ChangeNotifier {
  Status _status = Status.Uninitialized;

  BaseAuthRepo();

  Status get status => _status;
  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }
}
