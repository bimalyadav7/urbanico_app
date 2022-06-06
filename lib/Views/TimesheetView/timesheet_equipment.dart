import 'package:flutter/material.dart';
import 'package:flutter_table/table_sticky_headers.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/model/equipmentModel.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/Views/TimesheetView/components/costCodeCard.dart';
import 'package:urbanico_app/Views/TimesheetView/components/dateSelectorView.dart';
import 'package:urbanico_app/Views/TimesheetView/components/projectCard.dart';
import 'package:urbanico_app/Views/TimesheetView/components/quantityCard.dart';
import 'package:urbanico_app/appConfig.dart';

timeSheetEquipmentHourDataContainer(child) => SizedBox(width: 160, height: 84, child: Card(elevation: 1, child: child));
timeSheetLastMeterDataContainer(child) => SizedBox(
    width: 160,
    height: 84,
    child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            side: BorderSide(
              color: Colors.black,
            )),
        elevation: 1,
        child: child));

timeSheetEquipmentTotalHourContainer(child, height) => SizedBox(
    width: 160,
    height: height,
    child: Card(
        color: Colors.black,
        borderOnForeground: true,
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          alignment: Alignment.center,
          child: child,
        )));

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

class TimeSheetEquipmentEntry extends StatelessWidget {
  final TabController tabController;
  const TimeSheetEquipmentEntry({required this.tabController});

  timeSheetCostCodeDataContainer(child) => SizedBox(width: 160, height: 160, child: Card(elevation: 1, child: child));
  timeSheetCrewDataContainer(child) => SizedBox(width: 160, height: 84, child: Card(elevation: 1, child: child));
  timeSheetWorkHourDataContainer(child) => SizedBox(width: 160, height: 84, child: Card(elevation: 1, child: child));
  timeSheetManHourCalculationContainer(child, height) => SizedBox(
      width: 160,
      height: height,
      child: Card(
          elevation: 1,
          child: Center(
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
      _tempTitleColumn.add(timeSheetEquipmentTotalHourContainer(
          Text(
            "Total",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConfig().primaryColor),
          ),
          160.0));
      _tempTitleColumn.add(timeSheetEquipmentTotalHourContainer(
          Text(
            "Enter Last Meter Reading Here",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConfig().primaryColor),
          ),
          160.0));
      return _tempTitleColumn;
    }

    /// Simple generator for row titles
    List<Widget> _makeTitleRow() {
      List<Widget> _tempTitleRow = [];
      for (var i = 0; i < timesheetData.listEquipments.length; i++) {
        _tempTitleRow.add(timeSheetCrewDataContainer(EquipmentSelector(timesheetData.listEquipments[i])));
      }
      return _tempTitleRow;
    }

    List<List<Widget>> _makeData() {
      final List<List<Widget>> output = [];

      for (int i = 0; i < timesheetData.listProjects.length + 2; i++) {
        final List<Widget> row = [];

        if (i < timesheetData.listProjects.length) {
          for (int j = 0; j < timesheetData.listEquipments.length; j++) {
            row.add(timeSheetEquipmentHourDataContainer(EquipmentHourField(timesheetData.listProjects[i].listEquipments[j])));
          }
        } else if ((i == timesheetData.listProjects.length)) {
          for (int j = 0; j < timesheetData.listEquipments.length; j++) {
            double equipmentSum = 0.0;
            for (int k = 0; k < timesheetData.listProjects.length; k++) {
              equipmentSum += timesheetData.listProjects[k].listEquipments[j].equipmentHours;
            }
            row.add(timeSheetEquipmentTotalHourContainer(
                Center(
                  child: Text(
                    equipmentSum.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppConfig().primaryColor),
                  ),
                ),
                84.0));
          }
        } else {
          for (int j = 0; j < timesheetData.listEquipments.length; j++) {
            List<ProjectEquipment> lastReadingList = [];

            for (int i = 0; i < timesheetData.listProjects.length; i++) {
              lastReadingList.add(timesheetData.listProjects[i].listEquipments[j]);
            }

            row.add(timeSheetLastMeterDataContainer(EquipmentLastReadingField(lastReadingList)));
          }
        }
        output.add(row);
      }
      return output;
    }

    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TableSimple(
        crewColumn: _makeTitleColumn(),
        projectRow: _makeTitleRow(),
        data: _makeData(),
      ),
    );
    // }
  }
}

class EquipmentLastReadingField extends StatelessWidget {
  final List<ProjectEquipment> pequipmentList;

  const EquipmentLastReadingField(this.pequipmentList);
  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheetViewRepo>(context);
    var lastReadingInteract = Provider.of<UIKeypadRepository>(context, listen: false);
    return GestureDetector(
      child: Container(
        color: (lastReadingInteract.selectedLastReadingPresent(pequipmentList[0])) ? AppConfig().primaryColor : Colors.white,
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            hintText: pequipmentList[0].lastreading.toString(),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.black,
          ),
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
          maxLines: 1,
          onChanged: (String time) {
            pequipmentList[0].setLastReading = double.parse(time);
            timesheet.refresh();
          },
        ),
      ),
      onTap: () {
        lastReadingInteract.setselectedFieldName = "lastreading";
        lastReadingInteract.clearAllSelections(field: lastReadingInteract.selectedFieldName);
        if (lastReadingInteract.selectedLastReadingPresent(pequipmentList[0])) {
          lastReadingInteract.removeLastReading(pequipmentList);
        } else {
          lastReadingInteract.setSelectedLastReading = pequipmentList;
        }
        Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
        timesheet.refresh();
      },
    );
  }
}

class EquipmentHourField extends StatelessWidget {
  final ProjectEquipment pequipment;
  const EquipmentHourField(this.pequipment);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheetViewRepo>(context);
    var equipmentHourInteract = Provider.of<UIKeypadRepository>(context, listen: false);
    return GestureDetector(
      child: Container(
        color: (equipmentHourInteract.selectedEquipmentHourPresent(pequipment)) ? AppConfig().primaryColor : Colors.white,
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            hintText: pequipment.equipmentHours.toString(),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.black,
          ),
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
          maxLines: 1,
          onChanged: (String time) {
            pequipment.setEquipmentHours = double.parse(time);
            timesheet.refresh();
          },
        ),
      ),
      onTap: () {
        equipmentHourInteract.setselectedFieldName = "equipment";
        equipmentHourInteract.clearAllSelections(field: equipmentHourInteract.selectedFieldName);
        if (equipmentHourInteract.selectedEquipmentHourPresent(pequipment)) {
          equipmentHourInteract.removeEquipmentHours(pequipment);
        } else {
          equipmentHourInteract.setSelectedEquipment = pequipment;
        }
        Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
        timesheet.refresh();
      },
    );
  }
}

class EquipmentSelector extends StatelessWidget {
  final Equipment equipment;
  const EquipmentSelector(this.equipment);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheetViewRepo>(context);
    return Stack(children: [
      Positioned(
        top: 1,
        right: 3,
        child: Container(
            child: GestureDetector(
          child: const Icon(
            Icons.cancel,
            color: Colors.redAccent,
            size: 22,
          ),
          onTap: () {
            for (var tsproject in timesheet.listProjects) {
              tsproject.removeEquipmentByEquipmentid(equipment);
            }
            timesheet.removeEquipment = equipment;
          },
        )),
      ),
      Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              equipment.equipmentname,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Divider(
              height: 3.8,
              endIndent: 28,
              color: Colors.deepPurple,
            ),
            Text(
              equipment.equipmentdesc,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )),
    ]);
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
        contentCellHeight: 80,
        contentCellWidth: 152,
        stickyLegendHeight: 152,
        stickyLegendWidth: 152,
      ),
    );
  }
}
