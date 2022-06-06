import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Views/TimesheetView/daliy_reports.dart';
import 'package:urbanico_app/Views/TimesheetView/timesheet_equipment.dart';
import 'package:urbanico_app/Views/TimesheetView/timesheet_material.dart';
import 'package:urbanico_app/Views/TimesheetView/timesheet_picture.dart';
import 'package:urbanico_app/Views/TimesheetView/timesheetView.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class TimesheetView extends StatelessWidget {
  const TimesheetView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 42.0,
          elevation: 3,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: AppConfig().primaryColor,
          title: const Text(
            "Timesheet View",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: const TimesheetViewBody());
  }
}

class TimesheetViewBody extends StatefulWidget {
  const TimesheetViewBody();
  @override
  _TimesheetViewBodyState createState() => _TimesheetViewBodyState();
}

class _TimesheetViewBodyState extends State<TimesheetViewBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    var tsViewProvider = Provider.of<TimeSheetViewRepo>(context);

    if (tsViewProvider.getState == FutureState.Uninitialized) {
      tsViewProvider.getLatestEntryByDate();
    } else if (tsViewProvider.getState == FutureState.Loaded) {
      return Container(
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
                  TimesheetViewMain(tabController: _tabController),
                  TimesheetMaterialEntry(tabController: _tabController),
                  TimeSheetEquipmentEntry(tabController: _tabController),
                  TimeSheetDailyReportView(tabController: _tabController),
                  TimesheetPicture(tabController: _tabController),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (tsViewProvider.getState == FutureState.Unauthenticated) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Access Denied. Please login agan by pressing button below."),
          MaterialButton(
            child: const Text("Relogin"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ));
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[CircularProgressIndicator(), Text("Loading Timesheet")],
      ),
    );
  }
}
