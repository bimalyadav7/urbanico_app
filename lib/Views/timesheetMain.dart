import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:urbanico_app/Views/Timesheet/daliy_reports.dart';
import 'package:urbanico_app/Views/Timesheet/timesheet.dart';
import 'package:urbanico_app/Views/Timesheet/timesheet_equipment.dart';
import 'package:urbanico_app/Views/Timesheet/timesheet_material.dart';
import 'package:urbanico_app/Views/Timesheet/timesheet_picture.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

import '../Repository/TimesheetRepository.dart';

class TimesheetEntry extends StatefulWidget {
  @override
  _TimesheetEntryState createState() => _TimesheetEntryState();
}

class _TimesheetEntryState extends State<TimesheetEntry> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final timesheetProvider = Provider.of<TimeSheet>(context, listen: false);
    _tabController = TabController(vsync: this, length: 5);
    _tabController.addListener(() async {
      // can navigate to equipment tab without project or date
      if (timesheetProvider.date == null && _tabController.index != 0 && _tabController.index != 2) {
        if (_tabController.previousIndex == 0) _tabController.index = 0;
        if (_tabController.previousIndex == 2) _tabController.index = 2;
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: timesheetProvider.date == null
                    ? Text(AppLocalizations.of(context).translate("selectadate"))
                    : Text(AppLocalizations.of(context).translate("costcodeorquantitynotadded")),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).translate("understood"))),
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: const Color(0xFF0a0d1b),
              child: SizedBox(
                height: 42.0,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: AppConfig().primaryColor,
                  ),
                  unselectedLabelColor: Colors.grey,
                  tabs: <Widget>[
                    Tab(
                      text: AppLocalizations.of(context).translate("timesheetentry"),
                    ),
                    Tab(
                      text: AppLocalizations.of(context).translate("resourceentry"),
                    ),
                    Tab(
                      text: AppLocalizations.of(context).translate("equipment"),
                    ),
                    Tab(
                      text: AppLocalizations.of(context).translate("dailyreport"),
                    ),
                    Tab(
                      text: AppLocalizations.of(context).translate("picture"),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  TimesheetMain(tabController: _tabController, tabIndex: 0),
                  TimesheetMaterialEntry(tabController: _tabController, tabIndex: 1),
                  TimeSheetEquipmentEntry(tabController: _tabController, tabIndex: 2),
                  TimeSheetDailyReport(tabController: _tabController, tabIndex: 3),
                  TimesheetPicture(tabController: _tabController, tabIndex: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
