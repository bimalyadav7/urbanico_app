import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_table/table_sticky_headers.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/Views/TimesheetView/components/costCodeCard.dart';
import 'package:urbanico_app/Views/TimesheetView/components/dateSelectorView.dart';
import 'package:urbanico_app/Views/TimesheetView/components/projectCard.dart';
import 'package:urbanico_app/Views/TimesheetView/components/quantityCard.dart';
import 'package:urbanico_app/appConfig.dart';

timeSheetEntryDateContainer(child) => SizedBox(width: 152, height: 152, child: Card(child: child));

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

class TimesheetViewMain extends StatelessWidget {
  final TabController tabController;
  const TimesheetViewMain({required this.tabController});

  timeSheetCostCodeDataContainer(child) => SizedBox(
      width: 160,
      height: 160,
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
      height: 72,
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
      height: 72,
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
  timeSheetAttendanceContainer(child) => SizedBox(width: 160, height: 72, child: Card(elevation: 1, child: child));
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

  @override
  Widget build(BuildContext context) {
    var timesheetData = Provider.of<TimeSheetViewRepo>(context);
    if (timesheetData.message == "loading") {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[CircularProgressIndicator(), Text("Loading...")],
        ),
      );
    } else {
      List<Widget> _makeTitleColumn() {
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
        _tempTitleColumn.add(timeSheetWorkHourCalculationContainer(
            const Text(
              "Total Work Hours",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            160.0));

        _tempTitleColumn.add(timeSheetCostCodeDataContainer(const Text("")));

        return _tempTitleColumn;
      }

      /// Simple generator for row titles
      List<Widget> _makeTitleRow() {
        List<Widget> _tempTitleRow = [];
        for (var i = 0; i < timesheetData.listCrews.length; i++) {
          _tempTitleRow.add(timeSheetCrewDataContainer(CrewSelector(timesheetData.listCrews[i])));
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

      List<Widget> _makeWorkHourData() {
        List<Widget> _totalManHoursRow = [];

        for (var i = 0; i < timesheetData.listCrews.length; i++) {
          if (timesheetData.listCrews[i].isPresent) {
            double workHrsTotal = 0;
            List<WorkHours> whrs =
                timesheetData.listWorkHours.where((workhour) => workhour.crew.id == timesheetData.listCrews[i].id).toList();
            for (WorkHours hours in whrs) {
              workHrsTotal += hours.workhr;
            }
            _totalManHoursRow.add(timeSheetWorkHourCalculationContainer(
                Text(workHrsTotal.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig().primaryColor)), 72.0));
          } else {
            _totalManHoursRow.add(timeSheetWorkHourCalculationContainer(
                Container(
                  color: Colors.redAccent,
                ),
                72.0));
          }
        }
        return _totalManHoursRow;
      }

      List<List<Widget>> _makeData() {
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
                  Text(projectCrewsSum.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: AppConfig().primaryColor)), 72.0));
            }
          }

          output.add(row);
        }
        List<Widget> workhourdata = _makeWorkHourData();
        List<Widget> blankData = [];
        workhourdata.add((timeSheetWorkHourCalculationContainer(
            Text(totalWorkHour.toString(), style: const TextStyle(fontWeight: FontWeight.bold)), 72.0)));

        output.add(workhourdata);

        for (var i = 0; i < timesheetData.listCrews.length + 1; i++) {
          if (i < timesheetData.listCrews.length) {
            blankData.add(timeSheetAttendanceContainer(AttendanceSwitcher(timesheetData.listCrews[i])));
          } else {
            blankData.add(timeSheetManHourCalculationContainer(const Text(""), 72.0));
          }
        }
        output.add(blankData);
        return output;
      }

      return Container(
          padding: const EdgeInsets.only(top: 4),
          child: TableSimple(
            crewColumn: _makeTitleColumn(),
            projectRow: _makeTitleRow(),
            data: _makeData(),
          ));
      // }
    }
  }
}

class AttendanceSwitcher extends StatelessWidget {
  final Crew crew;
  const AttendanceSwitcher(this.crew);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (crew.isPresent) ? Colors.greenAccent : Colors.redAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text((crew.isPresent) ? 'Present' : 'Absent'),
          Checkbox(
              value: crew.isPresent,
              onChanged: (bool? val) {
                // if (!val)
                //   timesheetData.setAbsentCrew = crew;
                // else
                //   timesheetData.removeAbsentCrew(crew);
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
    var timesheet = Provider.of<TimeSheetViewRepo>(context);
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

class CrewSelector extends StatelessWidget {
  final Crew crew;
  const CrewSelector(this.crew);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              crew.crew.contact,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Divider(
              height: 3.8,
              endIndent: 28,
              color: Colors.deepPurple,
            ),
            Text(
              crew.crew.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )),
    ]);
  }
}

class ResetThisButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timeSheet = Provider.of<TimeSheetViewRepo>(context);
    return MaterialButton(
      color: Colors.orange,
      textColor: Colors.white,
      onPressed: () {
        timeSheet.clearWorkHourData();
      },
      child: const Text("Reset"),
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
    return StickyHeadersTable(
      columnsLength: crewColumn.length,
      rowsLength: projectRow.length,
      columnsTitleBuilder: (i) => crewColumn[i],
      rowsTitleBuilder: (i) => projectRow[i],
      contentCellBuilder: (i, j) => Container(
        child: data[i][j],
      ),
      legendCell: timeSheetEntryDateContainer(DateSelector(
        disabled: true,
      )),
      cellDimensions: const CellDimensions.fixed(
        contentCellHeight: 70,
        contentCellWidth: 152,
        stickyLegendHeight: 152,
        stickyLegendWidth: 152,
      ),
    );
  }
}
