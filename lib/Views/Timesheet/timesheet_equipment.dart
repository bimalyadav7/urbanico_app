import 'package:flutter/material.dart';
import 'package:flutter_table/table_sticky_headers.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Providers/TimesheetValidationProvider.dart';
import 'package:urbanico_app/Repository/EquipmentRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Views/Timesheet/components/costCodeSelector.dart';
import 'package:urbanico_app/Views/Timesheet/components/dateSelector.dart';
import 'package:urbanico_app/Views/Timesheet/components/equipmentCards.dart';
import 'package:urbanico_app/Views/Timesheet/components/nextButton.dart';
import 'package:urbanico_app/Views/Timesheet/components/equipmentselector.dart';
import 'package:urbanico_app/Views/Timesheet/components/costCodeCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/projectCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/quantityCard.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/tools/appLocalization.dart';
import 'package:urbanico_app/tools/internetChecker.dart';

import 'package:urbanico_app/tools/keypadTool.dart';

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

class TimeSheetEquipmentEntry extends StatelessWidget {
  final TabController tabController;
  final int tabIndex;

  const TimeSheetEquipmentEntry({required this.tabController, this.tabIndex = -1});

  timeSheetCostCodeDataContainer(child) => SizedBox(width: 160, height: 170, child: Card(elevation: 1, child: child));
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
    if (tabController.index == tabIndex) {
      var timesheetData = Provider.of<TimeSheet>(context);

      if (timesheetData.equipmentTemplateStatus == "") {
        timesheetData.getEquipmentTemplate(Provider.of<UserRepository>(context, listen: false).authUser.userID);
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
          _tempTitleColumn.add(timeSheetEquipmentTotalHourContainer(
              Text(
                "Total",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConfig().primaryColor),
              ),
              160.0));
          _tempTitleColumn.add(timeSheetEquipmentTotalHourContainer(
              Text(
                AppLocalizations.of(context).translate("equipmentmeterreading"),
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
            _tempTitleRow.add(timeSheetCrewDataContainer(EquipmentCard(timesheetData.listEquipments[i])));
          }
          return _tempTitleRow;
        }

        List<List<Widget>> _makeData() {
          final List<List<Widget>> output = [];

          for (int i = 0; i < timesheetData.listProjects.length + 2; i++) {
            final List<Widget> row = [];

            if (i < timesheetData.listProjects.length) {
              for (int j = 0; j < timesheetData.listEquipments.length; j++) {
                row.add(timeSheetEquipmentHourDataContainer(EquipmentHourCard(timesheetData.listProjects[i].listEquipments[j])));
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
                if (lastReadingList.isEmpty) lastReadingList.add(ProjectEquipment());
                row.add(timeSheetLastMeterDataContainer(EquipmentLastReadingField(lastReadingList)));
              }
            }
            output.add(row);
          }
          return output;
        }

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
                      crewColumn: _makeTitleColumn(),
                      projectRow: _makeTitleRow(),
                      data: _makeData(),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  AnimatedContainer(
                    width: Provider.of<UIKeypadRepository>(context, listen: false).keypadState ? 224.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastOutSlowIn,
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
                          AddEquipmentButton(),
                          const SizedBox(
                            width: 12,
                          ),
                          AddProjectButton(),
                          const SizedBox(
                            width: 12,
                          ),
                          RefreshButton()
                        ],
                      )),
                      Flexible(
                        child: NextButton(tabController),
                      ),
                    ],
                  ),
                ),
              ),
            ]));
        // }
      }
    }
    return Container();
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
                    content: Text(AppLocalizations.of(context).translate("equipmenthoursandmeterreadingwillberesettozero")),
                    actions: <Widget>[
                      TextButton(
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.redAccent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            provider.setEquipmentTemplateStatus = "";
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

// Can add costcode from equipment page itself
class AddProjectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TimeSheet>(context);
    return MaterialButton(
      minWidth: 152,
      height: double.maxFinite,
      padding: const EdgeInsets.all(4),
      color: AppConfig().primaryColor,
      textColor: Colors.black,
      elevation: 3.0,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CostCodeSelectorPage()),
        );
        provider.setEquipmentTemplateStatus = "";
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Icon(
              Icons.add_circle,
              size: 32,
            ),
            SizedBox(
              width: 8,
            ),
            Text("Add Cost Code")
          ],
        ),
      ),
      hoverElevation: 2.0,
    );
  }
}

class AddEquipmentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timesheetData = Provider.of<TimeSheet>(context, listen: false);
    var equipmentRepo = Provider.of<EquipmentRepository>(context);
    return MaterialButton(
      minWidth: 152,
      height: double.maxFinite,
      padding: const EdgeInsets.all(4),
      color: AppConfig().primaryColor,
      textColor: Colors.black,
      elevation: 3.0,
      onPressed: () async {
        if (timesheetData.listProjects.isEmpty) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(AppLocalizations.of(context).translate("costcodeorquantitynotadded")),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context).translate("understood"))),
                  ],
                );
              });
        } else {
          if (await CheckInternet().isInternetConnected()) {
            await equipmentRepo.getAllEquipments(resync: true);
          }
          if (equipmentRepo.getState == FutureState.Loading) {
            return;
          } else if (equipmentRepo.getState == FutureState.Loaded) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipmentSelectorPage()),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: (equipmentRepo.getState == FutureState.Loading)
              ? <Widget>[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text("Loading...")
                ]
              : <Widget>[
                  const Icon(
                    Icons.add_circle,
                    size: 32,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text("Add Equipment")
                ],
        ),
      ),
      hoverElevation: 2.0,
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
      legendCell: timeSheetEntryDateContainer(DateSelector()),
      cellDimensions: const CellDimensions.fixed(
        contentCellHeight: 80,
        contentCellWidth: 152,
        stickyLegendHeight: 160,
        stickyLegendWidth: 152,
      ),
    );
  }
}
