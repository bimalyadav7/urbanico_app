import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Providers/TimesheetValidationProvider.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Views/Timesheet/components/costCodeCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/crewCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/dateSelector.dart';
import 'package:urbanico_app/Views/Timesheet/components/nextButton.dart';
import 'package:urbanico_app/Views/Timesheet/components/projectCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/costCodeSelector.dart';
import 'package:urbanico_app/Views/Timesheet/components/crewselector.dart';
import 'package:urbanico_app/Views/Timesheet/components/quantityCard.dart';
import 'package:urbanico_app/Views/TimesheetNew/components/tableStickyHeader.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/tools/appLocalization.dart';
import 'package:urbanico_app/tools/internetChecker.dart';

import 'package:urbanico_app/tools/keypadTool.dart';

timeSheetEntryDateContainer(child) => SizedBox(width: 152, height: 160, child: Card(child: child));

timeSheetDataLoadingDialog(context) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: SizedBox(
              height: 300.0,
              child: Center(
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[CircularProgressIndicator(), Text("Loading...")],
                  ),
                ),
              )));
    });

timeSheetDataErrorDialog(context, message) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(content: Text(message));
    });
timeSheetAlertDialog(context, message) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"))
        ],
      );
    });

class TimesheetMain extends StatelessWidget {
  final TabController tabController;
  final int tabIndex;
  const TimesheetMain({required this.tabController, this.tabIndex = -1});

  timeSheetCostCodeDataContainer(child) => SizedBox(
      width: 160,
      height: 170,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          borderOnForeground: true,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: child,
          )));
  timeSheetCrewDataContainer(child) => SizedBox(
      width: 160,
      height: 74,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          borderOnForeground: true,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: child,
          )));
  timeSheetWorkHourDataContainer(child) => SizedBox(
      width: 160,
      height: 74,
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          borderOnForeground: true,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: child,
          )));
  timeSheetAttendanceContainer(child) => SizedBox(width: 160, height: 74, child: Card(elevation: 1, child: child));
  timeSheetManHourCalculationContainer(child, height) => SizedBox(
      width: 160,
      height: height,
      child: Card(
          color: Colors.black,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(
                color: Colors.black,
              )),
          borderOnForeground: true,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            alignment: Alignment.center,
            child: child,
          )));
  timeSheetWorkHourCalculationContainer(child, height) => SizedBox(
      width: 160,
      height: height,
      child: Card(
          elevation: 1,
          child: Center(
            child: child,
          )));

  timeSheetDataContainerHeader(text, {style}) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      );

  timeSheetDataContainerText(text, {style}) => Text(
        text,
        style: const TextStyle(fontSize: 17.0),
      );
  timeSheetTotalHeaderContainer(child) => SizedBox(
      width: 160,
      height: 170,
      child: Card(
          color: Colors.black,
          borderOnForeground: true,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            alignment: Alignment.center,
            child: child,
          )));
  List<Widget> _makeTitleColumn(timesheetData) {
    List<Widget> _tempTitleColumn = [];
    for (var i = 0; i < timesheetData.listProjects.length; i++) {
      _tempTitleColumn.add(timeSheetCostCodeDataContainer(Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProjectCard(timesheetData.listProjects[i]),
          CostCodeCard(timesheetData.listProjects[i]),
          QuantityCard(timesheetData.listProjects[i])
        ],
      )));
    }
    _tempTitleColumn.add(timeSheetTotalHeaderContainer(
      Text(
        "Total Work Hours",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig().primaryColor, fontSize: 18),
      ),
    ));

    _tempTitleColumn.add(timeSheetCostCodeDataContainer(AddProjectButton()));

    return _tempTitleColumn;
  }

  /// Simple generator for row titles
  List<Widget> _makeTitleRow(timesheetData) {
    List<Widget> _tempTitleRow = [];
    for (var i = 0; i < timesheetData.listCrews.length; i++) {
      _tempTitleRow.add(timeSheetCrewDataContainer(CrewCard(timesheetData.listCrews[i])));
    }
    _tempTitleRow.add(timeSheetManHourCalculationContainer(
        Text(
          "Total Man Hours",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConfig().primaryColor),
        ),
        63.0));
    return _tempTitleRow;
  }

  List<Widget> _makeWorkHourData(timesheetData) {
    List<Widget> _totalManHoursRow = [];

    for (var i = 0; i < timesheetData.listCrews.length; i++) {
      if (timesheetData.listCrews[i].isPresent) {
        double workHrsTotal = 0;
        List<WorkHours> whrs = timesheetData.listWorkHours.where((workhour) => workhour.crew.id == timesheetData.listCrews[i].id).toList();
        for (WorkHours hours in whrs) {
          workHrsTotal += hours.workhr;
        }
        _totalManHoursRow.add(timeSheetWorkHourCalculationContainer(
            Text(workHrsTotal.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig().primaryColor)), 74.0));
      } else {
        _totalManHoursRow.add(timeSheetWorkHourCalculationContainer(
            Container(
              color: Colors.redAccent,
            ),
            74.0));
      }
    }
    return _totalManHoursRow;
  }

  List<List<Widget>> _makeData(timesheetData) {
    double totalWorkHour = 0.0;
    final List<List<Widget>> output = [];
    for (int i = 0; i < timesheetData.listProjects.length; i++) {
      final List<Widget> row = [];

      double projectCrewsSum = 0.0;
      for (int j = 0; j < timesheetData.listCrews.length + 1; j++) {
        if (j < timesheetData.listCrews.length) {
          var user = timesheetData.listCrews[j];
          var project = timesheetData.listProjects[i];

          if (user.isPresent) {
            WorkHours whr;
            List<WorkHours> whrs = [];
            whrs = timesheetData.listWorkHours
                .where((workhours) => (workhours.tsproject.id == project.id && workhours.crew.id == user.id))
                .toList();

            if (whrs.isEmpty) {
              whr = WorkHours();
              whr.setCrew = user;
              whr.setTSProject = project;
              timesheetData.setWorkHours = whr;
            } else {
              whr = whrs.first;
            }
            projectCrewsSum += whr.workhr;
            row.add(timeSheetWorkHourDataContainer(WorkHourField(whr)));
          } else {
            row.add(timeSheetWorkHourDataContainer(Container(
              color: Colors.redAccent,
            )));
          }
        } else {
          totalWorkHour += projectCrewsSum;
          row.add(timeSheetManHourCalculationContainer(
              Text(projectCrewsSum.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig().primaryColor)), 62.0));
        }
      }

      output.add(row);
    }
    List<Widget> workhourdata = _makeWorkHourData(timesheetData);
    List<Widget> blankData = [];
    workhourdata.add(
        (timeSheetWorkHourCalculationContainer(Text(totalWorkHour.toString(), style: const TextStyle(fontWeight: FontWeight.bold)), 62.0)));

    output.add(workhourdata);

    for (var i = 0; i < timesheetData.listCrews.length + 1; i++) {
      if (i < timesheetData.listCrews.length) {
        blankData.add(timeSheetAttendanceContainer(AttendanceSwitcher(timesheetData.listCrews[i])));
      } else {
        blankData.add(timeSheetWorkHourCalculationContainer(const Text(""), 62.0));
      }
    }
    output.add(blankData);
    return output;
  }

  @override
  Widget build(BuildContext context) {
    if (tabController.index == tabIndex) {
      var timesheetRepo = Provider.of<TimeSheet>(context);
      if (timesheetRepo.templateStatus == FutureState.Uninitialized) {
        timesheetRepo.getCrewListForForeman(Provider.of<UserRepository>(context, listen: false).authUser.userID);
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[CircularProgressIndicator(), Text("Loading crew")],
          ),
        );
      } else if (timesheetRepo.templateStatus == FutureState.Loading) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[CircularProgressIndicator(), Text("Loading crew")],
          ),
        );
      } else if (timesheetRepo.templateStatus == FutureState.Loaded) {
        return Container(
            padding: const EdgeInsets.only(top: 4),
            child: Column(children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: (Provider.of<TimesheetValidationProvider>(context).isMessage &&
                        (Provider.of<TimesheetValidationProvider>(context, listen: false).tabIndex == tabController.index ||
                            Provider.of<TimesheetValidationProvider>(context, listen: false).tabIndex == -1))
                    ? Container(
                        color: Colors.redAccent,
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  Provider.of<TimesheetValidationProvider>(context, listen: false).message,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                ),
                              ],
                            )),
                      )
                    : Container(),
              ),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Expanded(
                    child: TableSimple(
                      crewColumn: _makeTitleColumn(timesheetRepo),
                      projectRow: _makeTitleRow(timesheetRepo),
                      data: _makeData(timesheetRepo),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  AnimatedContainer(
                    width: Provider.of<UIKeypadRepository>(context, listen: false).keypadState ? 224.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    child: KeyPad(),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ]),
              ),
              SizedBox(
                height: 54,
                child: Container(
                  padding: const EdgeInsets.only(top: 3, right: 24, left: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AddCrewButton(),
                          const SizedBox(
                            width: 12,
                          ),
                          RefreshButton()
                        ],
                      )),
                      // Flexible(child: SaveDraftButton()),
                      Flexible(child: NextButton(tabController)),
                    ],
                  ),
                ),
              ),
            ]));
      }
    }
    return Container();
  }
}

class AttendanceSwitcher extends StatelessWidget {
  final Crew crew;
  const AttendanceSwitcher(this.crew);

  @override
  Widget build(BuildContext context) {
    var timesheetData = Provider.of<TimeSheet>(context);
    return Container(
      color: (crew.isPresent) ? Colors.greenAccent : Colors.redAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text((crew.isPresent) ? 'Present' : 'Absent'),
          Checkbox(
              value: crew.isPresent,
              onChanged: (bool? val) {
                if (!val!) {
                  timesheetData.setAbsentCrew = crew;
                } else {
                  timesheetData.removeAbsentCrew(crew);
                }
              })
        ],
      ),
    );
  }
}

class WorkHourField extends StatelessWidget {
  final WorkHours whr;
  const WorkHourField(this.whr);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);
    var workhourInteract = Provider.of<UIKeypadRepository>(context, listen: false);
    return GestureDetector(
      child: Container(
        color: (workhourInteract.selectedWorkHourPresent(whr)) ? AppConfig().primaryColor : Colors.white,
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            hintText: whr.workhr.toString(),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.black,
          ),
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
          maxLines: 1,
          onChanged: (String time) {
            whr.setWorkhr = double.parse(time);
            timesheet.refresh();
          },
        ),
      ),
      onTap: () {
        workhourInteract.setselectedFieldName = "workhour";
        workhourInteract.clearAllSelections(field: workhourInteract.selectedFieldName);
        if (workhourInteract.selectedWorkHourPresent(whr)) {
          workhourInteract.removeWorkHours(whr);
        } else {
          workhourInteract.setSelectedWorkHours = whr;
        }
        Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
        timesheet.refresh();
      },
    );
  }
}

class AddProjectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: AppConfig().primaryColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CostCodeSelectorPage()),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Icon(
            Icons.add_circle,
            size: 46,
          ),
          Text("Add Cost Code")
        ],
      ),
      hoverElevation: 2.0,
    );
  }
}

class AddCrewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<MultiUserRepository>(context);
    return MaterialButton(
      minWidth: 152,
      height: double.maxFinite,
      padding: const EdgeInsets.all(4),
      color: AppConfig().primaryColor,
      elevation: 3.0,
      onPressed: () async {
        if (await CheckInternet().isInternetConnected()) {
          await userRepo.getAllUser(resync: true);
        }
        if (userRepo.getState == FutureState.Loaded) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CrewSelectorPage()),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: (userRepo.getState == FutureState.Loading)
            ? <Widget>[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(
                  width: 8,
                ),
                const Text("loading...")
              ]
            : <Widget>[
                const Icon(
                  Icons.add_circle,
                  size: 32,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("Add Crew")
              ],
      ),
      hoverElevation: 2.0,
    );
  }
}

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TimeSheet>(context);
    return SizedBox(
        width: 46,
        child: MaterialButton(
          height: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 4),
          elevation: 3.0,
          color: Colors.orange,
          textColor: Colors.white,
          child: const Icon(Icons.refresh),
          onLongPress: () {},
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    elevation: 1.25,
                    content: Text(AppLocalizations.of(context).translate("crewhourswillbereloaded")),
                    actions: <Widget>[
                      TextButton(
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.redAccent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            provider.clearWorkHourData();
                            provider.setTemplateStatus = FutureState.Uninitialized;
                          },
                          child: Text(AppLocalizations.of(context).translate("reset"))),
                      const SizedBox(
                        width: 16,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No")),
                    ],
                  );
                });
          },
        ));
  }
}

class ResetThisButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timeSheet = Provider.of<TimeSheet>(context);
    return MaterialButton(
      color: Colors.orange,
      textColor: Colors.white,
      onPressed: () {
        timeSheet.clearWorkHourData();
      },
      child: Text(AppLocalizations.of(context).translate("reset")),
    );
  }
}

class TableSimple extends StatelessWidget {
  const TableSimple({required this.data, required this.crewColumn, required this.projectRow});

  final List<List<Widget>> data;
  final List<Widget> crewColumn;
  final List<Widget> projectRow;

  @override
  Widget build(BuildContext context) {
    return CustomStickyHeadersTable(
      columnsLength: crewColumn.length,
      rowsLength: projectRow.length,
      columnsTitleBuilder: (i) => crewColumn[i],
      rowsTitleBuilder: (i) => projectRow[i],
      contentCellBuilder: (i, j) => Container(
        child: data[i][j],
      ),
      legendCell: timeSheetEntryDateContainer(DateSelector()),
      cellDimensions: const CellDimensions.fixed(
        contentCellHeight: 70,
        contentCellWidth: 152,
        stickyLegendHeight: 160,
        stickyLegendWidth: 152,
      ),
    );
  }
}
