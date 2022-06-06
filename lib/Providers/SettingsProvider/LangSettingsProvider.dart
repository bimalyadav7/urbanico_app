import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangSettingsProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('en');

  Locale get appLocal => _appLocale;

  LangSettingsProvider() {
    fetchLocale();
  }

  void fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
    } else {
      _appLocale = Locale(prefs.getString('language_code') ?? "");
    }
    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == const Locale("en")) {
      _appLocale = const Locale("en");
      await prefs.setString('language_code', 'en');
    } else {
      _appLocale = const Locale("es");
      await prefs.setString('language_code', 'es');
    }
    notifyListeners();
  }
}
