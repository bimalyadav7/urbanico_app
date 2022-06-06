import 'package:flutter/material.dart';
import 'package:urbanico_app/enum/appEnvironment.dart';

class AppConfig {
  // Singleton object
  static final AppConfig _singleton = AppConfig._internal();

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();

  late AppEnvironment appEnvironment;
  late String appName;
  late String description;
  late String baseUrl;
  late ThemeData themeData;
  late Color primaryColor;
  late Color secondaryColor;
  late double appWidth;
  late double appHeight;
  late String buildDate;
  late String buildVersion;
  late int tokenValidationTime;
  late String token = "";
  late int expiryOffset;
  late String platform;

  void setAppDimensions({required double appWidth, required double appHeight}) {
    this.appWidth = appWidth;
    this.appHeight = appHeight;
  }

  void setToken({required String token}) {
    this.token = token;
  }

  // Set app configuration with single function
  void setAppConfig({
    required AppEnvironment appEnvironment,
    required String appName,
    required String description,
    required String baseUrl,
    ThemeData? themeData,
    required Color primaryColor,
    required Color secondaryColor,
    required String buildDate,
    required String buildVersion,
    required int expiryOffset,
    required int tokenValidationTime,
    required String platform,
  }) {
    this.appEnvironment = appEnvironment;
    this.appName = appName;
    this.description = description;
    this.baseUrl = baseUrl;
    this.themeData = themeData ?? ThemeData();
    this.primaryColor = primaryColor;
    this.secondaryColor = secondaryColor;
    this.buildDate = buildDate;
    this.buildVersion = buildVersion;
    this.expiryOffset = expiryOffset;
    this.tokenValidationTime = tokenValidationTime;
    this.platform = platform;
  }
}
