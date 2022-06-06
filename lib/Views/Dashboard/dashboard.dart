import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:urbanico_app/Repository/ForemanEntryRepository.dart';
import 'package:urbanico_app/Views/Dashboard/components/podInformation.dart';
import 'package:urbanico_app/Views/Dashboard/components/timesheetAnalysis.dart';
import 'package:urbanico_app/Views/Dashboard/components/timesheetListView.dart';
import 'package:urbanico_app/Repository/PODRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class DashBoard extends StatefulWidget {
  const DashBoard();

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Widget> tabs = [
    DashCalendar(),
    ProjectSummary(),
    TimesheetAnalysisPage(),
  ];
  late int tabIndex;
  @override
  void initState() {
    tabIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 5,
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          MaterialButton(
                              elevation: (tabIndex == 0) ? 4 : 2,
                              color: (tabIndex == 0) ? AppConfig().primaryColor : Colors.white,
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.calendar_today),
                                  Text(
                                    AppLocalizations.of(context).translate("calendar"),
                                    style: const TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (tabIndex != 0) {
                                  setState(() {
                                    tabIndex = 0;
                                  });
                                }
                              }),
                          const SizedBox(
                            width: 4,
                          ),
                          MaterialButton(
                              elevation: (tabIndex == 1) ? 4 : 2,
                              color: (tabIndex == 1) ? AppConfig().primaryColor : Colors.white,
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.list),
                                  Text(
                                    AppLocalizations.of(context).translate("entrieslist"),
                                    style: const TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (tabIndex != 1) {
                                  setState(() {
                                    tabIndex = 1;
                                  });
                                }
                              }),
                          const SizedBox(
                            width: 4,
                          ),
                          MaterialButton(
                              elevation: (tabIndex == 2) ? 4 : 2,
                              color: (tabIndex == 2) ? AppConfig().primaryColor : Colors.white,
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.analytics_outlined),
                                  Text(
                                    AppLocalizations.of(context).translate("analysis"),
                                    style: const TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (tabIndex != 2) {
                                  setState(() {
                                    tabIndex = 2;
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                    Expanded(child: tabs[tabIndex])
                  ],
                ))),
      ],
    ));
  }
}

class DashCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 7,
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // selectedColor: AppConfig().primaryColor.withAlpha(200),
              // todayColor: AppConfig().primaryColor,
              // markersColor: Colors.brown[700],
              outsideDaysVisible: false,
              // highlightSelected: true,
              // selectedStyle: const TextStyle(color: Colors.black),
              // todayStyle: const TextStyle(color: Colors.black),
            ),
            onDaySelected: (day1, day2) {
              var format = DateFormat("yyyy-MM-dd");
              String formattedDate = format.format(day2);
              Provider.of<ForemanEntryRepository>(context, listen: false).setCurrentTimesheetDate = formattedDate;
              Provider.of<PODRepository>(context, listen: false).setCurrentPODDate = formattedDate;
            },
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 3,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppConfig().primaryColor),
                      child: Text(
                        AppLocalizations.of(context).translate("planoftheday") + " (POD)",
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  Expanded(flex: 9, child: PODInformation())
                ])),
          ),
        ),
      ],
    );
  }
}
