import 'package:flutter/foundation.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/enum/authStatus.dart';
import 'package:urbanico_app/enum/futureState.dart';

class BaseNotifierRepo with ChangeNotifier {
  late UserRepository _userRepository;
  late FutureState _state;

  BaseNotifierRepo(userRepo) {
    _userRepository = userRepo;
    initSuper();
  }

  void initSuper() {
    _state = FutureState.Uninitialized;
  }

  UserRepository get userRepo => _userRepository;
  FutureState get getState => _state;

  set setState(FutureState state) {
    _state = state;
    notifyListeners();
    if (state == FutureState.Unauthenticated) _setUnAuthenticated();
  }

  bool checkAuthenticationCode(statusCode) {
    if (statusCode == 403 || statusCode == 401) {
      return true;
    }
    return false;
  }

  void _setUnAuthenticated() {
    _userRepository.isReAuth = true;
    _userRepository.setStatus = Status.Unauthenticated;
  }
}
