import 'package:flutter/material.dart';
import 'package:urbanico_app/Views/Dashboard/dashboard.dart';
import 'package:urbanico_app/Views/Development/development.widgets.dart';
import 'package:urbanico_app/Views/Plan/planView.dart';
import 'package:urbanico_app/Views/timesheet.new.dart' as TimeEntryNew;
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/appEnvironment.dart';

class SideMenuItem {
  String name;
  Widget widget;
  IconData icon;
  SideMenuItem({required this.name, required this.widget, required this.icon});
}

class SideMenu {
  static List<SideMenuItem> sideMenus = [
    SideMenuItem(
      name: "dashboard",
      icon: Icons.dashboard,
      widget: const DashBoard(),
    ),
    SideMenuItem(
      name: "timesheet",
      icon: Icons.access_time,
      widget: TimeEntryNew.TimesheetEntry(),
    ),
    SideMenuItem(
      name: "planview",
      icon: Icons.calendar_today,
      widget: PlanView(),
    ),
  ];
  static List<SideMenuItem> sideMenusDemo = [
    SideMenuItem(
      name: "develop",
      icon: Icons.exit_to_app,
      widget: DevelopmentWidgets(),
    ),
  ];

  static List<SideMenuItem> get menuitems {
    if (AppConfig().appEnvironment == AppEnvironment.PROD) {
      sideMenusDemo.clear();
    }
    return sideMenus + sideMenusDemo;
  }
}
