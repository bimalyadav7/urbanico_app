import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Request/auth_api.dart';
import 'package:urbanico_app/Request/user_api.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/userModel.dart';
import 'package:urbanico_app/enum/authStatus.dart';

final serviceurl = AppConfig().baseUrl;
Map<String, String> headerType = {
  "Content-Type": "application/x-www-form-urlencoded",
};

class UserRepository extends ChangeNotifier {
  static int called = 0;

  late SharedPreferences preferences;
  late User _user;
  Status _status = Status.Uninitialized;

  bool _reAuth = false;
  bool _isIncorrectCreds = false;
  String _message = "";

  User get authUser => _user;
  Status get status => _status;
  bool get isIncorrectCreds => _isIncorrectCreds;
  bool get reAuth => _reAuth;
  String get authMessage => _message;

  UserRepository() {
    initAuth();
    called++;
  }

  initAuth() async {
    preferences = await SharedPreferences.getInstance();
    String _userData = preferences.getString("userdata") ?? jsonEncode(User());
    User _tempUser = User.fromJson(jsonDecode(_userData));
    if (_tempUser.name.isNotEmpty && _tempUser.email.isNotEmpty) {
      _user = _tempUser;
      AppConfig().setToken(token: preferences.getString("token") ?? "");
      setStatus = Status.Authenticated;
    } else {
      setStatus = Status.Uninitialized;
    }
  }

  Future<bool> checkValidity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int expiryTime = pref.getInt("expiry") ?? 0;
    int nowTime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    if (nowTime > expiryTime - AppConfig().expiryOffset) {
      return await tokenRefresher();
    }
    AppConfig().setToken(token: pref.getString("token") ?? "");
    setStatus = Status.Authenticated;
    return true;
  }

  Future<bool> tokenRefresher() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var response = await AuthApi().refreshToken();
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody["response"] == "success") {
          pref.setString("token", responseBody["token"]);
          setStatus = Status.Authenticated;
          return true;
        }
      }
      setStatus = Status.Unauthenticated;
      return false;
    } catch (err) {
      setStatus = Status.Unauthenticated;
      return false;
    }
  }

  set isReAuth(bool status) {
    _reAuth = status;
  }

  set setLoginStatus(bool status) {
    _isIncorrectCreds = status;
    notifyListeners();
  }

  set setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  set setUser(User user) {
    _user = user;
    notifyListeners();
  }

  set setMessage(String message) {
    _message = message;
  }

  Future<bool> login(String email, String password) async {
    try {
      _message = "";
      setStatus = Status.Authenticating;
      var response = await http
          .post(Uri.parse(serviceurl + "index.php?method=user-login"), headers: headerType, body: {"email": email, "password": password});
      var responseBody = jsonDecode(response.body);
      if (responseBody['response'] == "success") {
        _user = User.fromJson(responseBody['userdata']);
        _isIncorrectCreds = false;
        preferences.setString("userdata", jsonEncode(authUser));
        preferences.setString("previous_logger", authUser.email.toString());
        setStatus = Status.Authenticated;
        return true;
      }
      _message = "Username or Password is incorrect. Try Again.";
      _isIncorrectCreds = true;
      setStatus = Status.Unauthenticated;
      return false;
    } catch (err) {
      print(err);
      _message = "Timed out : Network Error.";
      _isIncorrectCreds = true;
      setStatus = Status.Unauthenticated;
      return false;
    }
  }

  Future<void> loginv2(String email, String password) async {
    try {
      _message = "";
      setStatus = Status.Authenticating;
      var response = await http.post(Uri.parse(serviceurl + "v2/login"),
          headers: headerType, body: {"email": email, "password": password}).timeout(const Duration(seconds: 30));
      var responseBody = jsonDecode(response.body);
      if (responseBody['response'] == "success") {
        _user = User.fromJson(responseBody['userdata']);
        _isIncorrectCreds = false;
        preferences.setString("userdata", jsonEncode(authUser));
        preferences.setString("previous_logger", authUser.email.toString());
        preferences.setString("token", responseBody['token']);
        AppConfig().setToken(token: preferences.getString("token") ?? "");
        var jwtdata = JwtDecoder.decode(responseBody['token']);
        preferences.setInt("expiry", jwtdata['exp']);
        isReAuth = false;
        setStatus = Status.Authenticated;
      } else {
        _isIncorrectCreds = true;
        _message = "Username or Password is incorrect. Try Again.";
        setStatus = Status.Unauthenticated;
      }
    } catch (err) {
      print(err);
      _isIncorrectCreds = true;
      _message = err.toString();
      setStatus = Status.Unauthenticated;
    }
  }

  Future<bool> reloginv2(String email, String password) async {
    try {
      var response = await http.post(Uri.parse(serviceurl + "v2/login"),
          headers: headerType, body: {"email": email, "password": password}).timeout(const Duration(seconds: 30));
      var responseBody = jsonDecode(response.body);
      if (responseBody['response'] == "success") {
        _user = User.fromJson(responseBody['userdata']);
        _isIncorrectCreds = false;
        preferences.setString("userdata", jsonEncode(authUser));
        preferences.setString("previous_logger", authUser.email.toString());
        preferences.setString("token", responseBody['token']);
        var jwtdata = JwtDecoder.decode(responseBody['token']);
        preferences.setInt("expiry", jwtdata['exp']);
        isReAuth = false;
        setStatus = Status.Authenticated;
        return true;
      }
      _isIncorrectCreds = true;
      setStatus = Status.Unauthenticated;
      return false;
    } catch (err) {
      print(err);
      _isIncorrectCreds = true;
      setStatus = Status.Unauthenticated;
      return false;
    }
  }

  Future preservedlogout() async {
    // preferences.remove("userdata");
    isReAuth = true;
    setUser = User();
    setStatus = Status.Unauthenticated;
  }

  Future logout() async {
    isReAuth = false;
    preferences.remove("userdata");
    setUser = User();
    setStatus = Status.Unauthenticated;
  }
}

class MultiUserRepository extends BaseNotifierRepo {
  final List<User> _users = [];
  String _message = "";
  String get message => _message;
  List<User> get listUsers => _users;

  MultiUserRepository(authRepo) : super(authRepo) {
    // getAllUser();
  }

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  set setUsers(User user) {
    _users.add(user);
    notifyListeners();
  }

  Future<void> getAllUser({bool resync = false}) async {
    try {
      if (_users.isNotEmpty && !resync) {
        setState = FutureState.Loaded;
      } else {
        setState = FutureState.Loading;
        _users.clear();
        var response = await UserApi().fetchAllUser();
        var userContact = '';
        if (checkAuthenticationCode(response.statusCode)) {
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          for (var user in responseBody["response"]) {
            User newUser = User.fromJson(user);
            if (userContact != newUser.contact) _users.add(newUser);
            userContact = newUser.contact;
          }
          setState = FutureState.Loaded;
        } else {
          setState = FutureState.Loaded;
        }
      }
    } catch (err) {
      setState = FutureState.Unauthenticated;
    }
  }
}
