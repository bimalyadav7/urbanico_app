import 'package:flutter/material.dart';
import 'package:flutter_table/table_sticky_headers.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/model/resourceModel.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/Views/Timesheet/components/costCodeCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/dateSelector.dart';
import 'package:urbanico_app/Views/Timesheet/components/nextButton.dart';
import 'package:urbanico_app/Views/Timesheet/components/projectCard.dart';
import 'package:urbanico_app/Views/Timesheet/components/quantityCard.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';
import 'package:urbanico_app/tools/keypadTool.dart';

materialEntryDateContainer(child) => SizedBox(width: 152, height: 160, child: Card(child: child));

materialEntryResourceContainer(header) => Container(
    width: 152,
    height: 138,
    padding: const EdgeInsets.only(top: 6),
    child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 32,
        color: AppConfig().primaryColor,
        child: Align(
          alignment: Alignment.center,
          child: Text(header),
        ),
      ),
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("MATH"),
          const Divider(),
          Container(
            padding: const EdgeInsets.only(bottom: 0, top: 0),
            height: 26,
            child: const Text("Actual"),
          ),
          const Divider(),
          const Text("Yield"),
        ],
      ))
    ])));

timeSheetDataErrorDialog(context, message) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(content: Text(message));
    });

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

class MaterialEntryTruckLoadContainer extends StatelessWidget {
  final List<Truck> trucks;
  final bool disabled;
  const MaterialEntryTruckLoadContainer(this.trucks, {this.disabled = false});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 152,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            foregroundDecoration: (disabled) ? const BoxDecoration(color: Colors.white70) : null,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showLoadData(context))));
  }

  List<Widget> showLoadData(context) {
    var truckLoadInteract = Provider.of<UIKeypadRepository>(context);

    List<Widget> temp = [];
    temp.add(Container(
      color: AppConfig().primaryColor,
      height: 32,
    ));

    for (var truck in trucks) {
      temp.add(SizedBox(
          height: 32,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  if (!disabled) {
                    truckLoadInteract.setselectedFieldName = "truckload";
                    truckLoadInteract.clearAllSelections(field: truckLoadInteract.selectedFieldName);
                    if (truckLoadInteract.selectedTruckLoadPresent(truck)) {
                      truckLoadInteract.removeTruckLoad(truck);
                    } else {
                      truckLoadInteract.setSelectedTruckLoad = truck;
                    }
                    Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
                    Provider.of<TimeSheet>(context, listen: false).refresh();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 1),
                    color: (truckLoadInteract.selectedTruckLoadPresent(truck)) ? Colors.tealAccent : Colors.white,
                  ),
                  child: Text(truck.load.toString()),
                ),
              ),
            ),
          )));
      temp.add(const Divider());
    }
    return temp;
  }
}

class MaterialEntryTruckLoadHeader extends StatelessWidget {
  final List<String> trucks;
  const MaterialEntryTruckLoadHeader(this.trucks);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 152,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showLoadData(context))));
  }

  List<Widget> showLoadData(context) {
    List<Widget> temp = [];
    temp.add(Container(alignment: Alignment.center, color: AppConfig().primaryColor, height: 32, child: const Text("Truck Load")));

    for (var truck in trucks) {
      temp.add(Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    truck,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("#${Provider.of<TimeSheet>(context).getTicketForTruck(truck)}"),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Provider.of<TimeSheet>(context, listen: false).removeTruckName = truck;
                  },
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.redAccent,
                  ))
            ],
          ),
        ),
      ));
      temp.add(const Divider());
    }
    return temp;
  }
}

class MaterialEntryTruckHourContainer extends StatelessWidget {
  final List<Truck> trucks;
  final bool disabled;
  const MaterialEntryTruckHourContainer(this.trucks, {this.disabled = false});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 152,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            foregroundDecoration: (disabled) ? const BoxDecoration(color: Colors.white70) : null,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showLoadData(context))));
  }

  List<Widget> showLoadData(context) {
    var truckHourInteract = Provider.of<UIKeypadRepository>(context);

    List<Widget> temp = [];
    temp.add(Container(
      color: AppConfig().primaryColor,
      height: 32,
    ));

    for (var truck in trucks) {
      temp.add(SizedBox(
          height: 32,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  if (!disabled) {
                    truckHourInteract.setselectedFieldName = "truckhour";
                    truckHourInteract.clearAllSelections(field: truckHourInteract.selectedFieldName);
                    if (truckHourInteract.selectedTruckHourPresent(truck)) {
                      truckHourInteract.removeTruckHour(truck);
                    } else {
                      truckHourInteract.setSelectedTruckHour = truck;
                    }
                    Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
                    Provider.of<TimeSheet>(context, listen: false).refresh();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    color: (truckHourInteract.selectedTruckHourPresent(truck)) ? AppConfig().primaryColor : Colors.white,
                  ),
                  child: Text(truck.hour.toString()),
                ),
              ),
            ),
          )));
      temp.add(const Divider());
    }
    return temp;
  }
}

class MaterialEntryTruckHourHeader extends StatelessWidget {
  final List<String> trucks;
  const MaterialEntryTruckHourHeader(this.trucks);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 152,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showLoadData(context))));
  }

  List<Widget> showLoadData(context) {
    List<Widget> temp = [];
    temp.add(Container(alignment: Alignment.center, color: AppConfig().primaryColor, height: 32, child: const Text("Truck Hour")));

    for (var truck in trucks) {
      temp.add(Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      truck,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("#${Provider.of<TimeSheet>(context).getTicketForTruck(truck)}"),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Provider.of<TimeSheet>(context, listen: false).removeTruckName = truck;
                    },
                    child: const Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                    ))
              ],
            )),
      ));
      temp.add(const Divider());
    }
    return temp;
  }
}

class MaterialEntryTruckLoadCalculator extends StatelessWidget {
  final List<TimeSheetProject> projects;
  const MaterialEntryTruckLoadCalculator(this.projects);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 152,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showLoadData(context))));
  }

  List<Widget> showLoadData(context) {
    var storedTruck = Provider.of<TimeSheet>(context);

    List<Widget> temp = [];
    temp.add(Container(
      color: AppConfig().primaryColor,
      alignment: Alignment.center,
      height: 32,
      child: const Text("Total"),
    ));

    for (int i = 0; i < storedTruck.listTruckName.length; i++) {
      double sum = 0;
      for (var project in projects) {
        sum += project.listTruck[i].load;
      }
      temp.add(Container(
        alignment: Alignment.center,
        height: 32,
        child: Text(sum.toStringAsFixed(2)),
      ));
      temp.add(const Divider());
    }
    return temp;
  }
}

class MaterialEntryTruckHourCalculator extends StatelessWidget {
  final List<TimeSheetProject> projects;
  const MaterialEntryTruckHourCalculator(this.projects);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 152,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showLoadData(context))));
  }

  List<Widget> showLoadData(context) {
    var storedTruck = Provider.of<TimeSheet>(context);

    List<Widget> temp = [];
    temp.add(Container(
      color: AppConfig().primaryColor,
      alignment: Alignment.center,
      height: 32,
      child: const Text("Total"),
    ));

    for (int i = 0; i < storedTruck.listTruckName.length; i++) {
      double sum = 0;
      for (var project in projects) {
        sum += project.listTruck[i].hour;
      }
      temp.add(Container(
        alignment: Alignment.center,
        height: 32,
        child: Text("$sum"),
      ));
      temp.add(const Divider());
    }
    return temp;
  }
}

class MaterialEntryResourceDataContainer extends StatelessWidget {
  final Resources resource;
  final double quantityToClaim;
  final bool disabled;
  const MaterialEntryResourceDataContainer(this.resource, {this.quantityToClaim = -1, this.disabled = false});
  @override
  Widget build(BuildContext context) {
    var resourceInteract = Provider.of<UIKeypadRepository>(context);
    return Container(
        width: 152,
        height: 138,
        padding: const EdgeInsets.only(top: 6),
        child: Container(
            foregroundDecoration: (disabled)
                ? const BoxDecoration(
                    color: Colors.white70,
                  )
                : null,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 32,
                color: AppConfig().primaryColor,
                child: Align(
                  alignment: Alignment.center,
                  child: Text((quantityToClaim == -1) ? resource.title + '/Unit' : ''),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (quantityToClaim != -1)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 6,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Text((resource.valueMath * quantityToClaim).toStringAsFixed(2)),
                                )),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(color: Colors.black)),
                                    child:
                                        Text((quantityToClaim != -1) ? resource.title + '/Unit' : '', style: const TextStyle(fontSize: 10)),
                                  ),
                                ))
                          ],
                        )
                      : Text((resource.valueMath * quantityToClaim.abs()).toStringAsFixed(2)),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (quantityToClaim != -1 && resource.title != "Truck" && !disabled) {
                          resourceInteract.setselectedFieldName = "resource";
                          resourceInteract.clearAllSelections(field: resourceInteract.selectedFieldName);
                          if (resourceInteract.selectedResourcePresent(resource)) {
                            resourceInteract.removeProjectResource(resource);
                          } else {
                            resourceInteract.setSelectedProjectResource = resource;
                          }
                          Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
                          Provider.of<TimeSheet>(context, listen: false).refresh();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 28,
                        decoration: BoxDecoration(
                          border: (quantityToClaim != -1)
                              ? (resource.title != "Truck")
                                  ? Border.all(color: Colors.redAccent, width: 1)
                                  : Border.all(color: Colors.black, width: 1)
                              : Border.all(color: Colors.greenAccent, width: 1),
                          color: (resourceInteract.selectedResourcePresent(resource) && quantityToClaim != -1)
                              ? Colors.tealAccent
                              : (resource.title != "Truck")
                                  ? Colors.white
                                  : AppConfig().primaryColor,
                        ),
                        child: (quantityToClaim != -1)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text((resource.valueActual).toStringAsFixed(2)),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 6.0),
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          child: Text((quantityToClaim != -1) ? resource.title + '/Unit' : '',
                                              style: const TextStyle(fontSize: 10)),
                                        ),
                                      ))
                                ],
                              )
                            : Text((resource.valueActual * quantityToClaim.abs()).toStringAsFixed(2)),
                      ),
                    ),
                  ),
                  const Divider(),
                  Text("${resource.getValueField(quantityToClaim.abs()).toStringAsFixed(2)} %"),
                ],
              ))
            ])));
  }
}

class TimesheetMaterialEntry extends StatelessWidget {
  final TabController tabController;
  final int tabIndex;
  final ifDisabled = true;
  const TimesheetMaterialEntry({required this.tabController, this.tabIndex = -1});

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
  @override
  Widget build(BuildContext context) {
    if (tabController.index == tabIndex) {
      var timesheetData = Provider.of<TimeSheet>(context);

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
        _tempTitleColumn.add(timeSheetTotalHeaderContainer(AddProjectButtonDisabled()));
        return _tempTitleColumn;
      }

      /// Simple generator for row titles
      List<Widget> _makeTitleRow() {
        List<Widget> _tempTitleRow = [];

        _tempTitleRow.add(materialEntryResourceContainer("Resource 1 - Concrete"));
        _tempTitleRow.add(materialEntryResourceContainer("Resource 2 - Base"));
        if (timesheetData.listTruckName.isNotEmpty) {
          _tempTitleRow.add(MaterialEntryTruckLoadHeader(timesheetData.listTruckName));
          _tempTitleRow.add(MaterialEntryTruckHourHeader(timesheetData.listTruckName));
        }
        _tempTitleRow.add(materialEntryResourceContainer("Resource 3 - Truck"));

        return _tempTitleRow;
      }

      List<List<Widget>> _makeData() {
        final List<List<Widget>> output = [];

        for (int i = 0; i < timesheetData.listProjects.length + 1; i++) {
          List<Widget> rows = [];

          if (i < timesheetData.listProjects.length) {
            rows.add(MaterialEntryResourceDataContainer(
              timesheetData.listProjects[i].concrete,
              quantityToClaim: timesheetData.listProjects[i].quantity,
              disabled: (timesheetData.listProjects[i].concrete.valueMath == 0) ? false : false,
            ));
            rows.add(MaterialEntryResourceDataContainer(
              timesheetData.listProjects[i].base,
              quantityToClaim: timesheetData.listProjects[i].quantity,
              disabled: (timesheetData.listProjects[i].base.valueMath == 0) ? false : false,
            ));
            if (timesheetData.listTruckName.isNotEmpty) {
              rows.add(MaterialEntryTruckLoadContainer(
                timesheetData.listProjects[i].listTruck,
                disabled: (timesheetData.listProjects[i].truck.valueMath == 0) ? false : false,
              ));
              rows.add(MaterialEntryTruckHourContainer(
                timesheetData.listProjects[i].listTruck,
                disabled: (timesheetData.listProjects[i].truck.valueMath == 0) ? false : false,
              ));
            }
            double calculatedActualValue = 0;

            for (var trucks in timesheetData.listProjects[i].listTruck) {
              calculatedActualValue += trucks.hour;
            }

            timesheetData.listProjects[i].truck.setValueActual = calculatedActualValue;

            rows.add(MaterialEntryResourceDataContainer(
              timesheetData.listProjects[i].truck,
              quantityToClaim: timesheetData.listProjects[i].quantity,
              disabled: (timesheetData.listProjects[i].truck.valueMath == 0) ? false : false,
            ));
          } else {
            Resources res = Resources();
            double sumMath = 0;
            double sumActual = 0;
            for (var project in timesheetData.listProjects) {
              sumMath += project.concrete.valueMath * project.quantity.abs();
              sumActual += project.concrete.valueActual;
            }
            res.setValueActual = sumActual;
            res.setValueMath = sumMath;
            res.setTitle = "Concrete";

            rows.add(MaterialEntryResourceDataContainer(res));

            res = Resources();
            sumMath = 0;
            sumActual = 0;
            for (var project in timesheetData.listProjects) {
              sumMath += project.base.valueMath * project.quantity.abs();
              sumActual += project.base.valueActual;
            }
            res.setValueActual = sumActual;
            res.setValueMath = sumMath;
            res.setTitle = "Base";

            rows.add(MaterialEntryResourceDataContainer(res));
            if (timesheetData.listTruckName.isNotEmpty) {
              rows.add(MaterialEntryTruckLoadCalculator(timesheetData.listProjects));
              rows.add(MaterialEntryTruckHourCalculator(timesheetData.listProjects));
            }
            res = Resources();
            sumMath = 0;
            sumActual = 0;
            for (var project in timesheetData.listProjects) {
              sumMath += project.truck.valueMath * project.quantity.abs();
              sumActual += project.truck.valueActual;
            }
            res.setValueActual = sumActual;
            res.setValueMath = sumMath;
            res.setTitle = "Truck";

            rows.add(MaterialEntryResourceDataContainer(res));
          }
          output.add(rows);
        }
        return output;
      }

      return Container(
          padding: const EdgeInsets.only(top: 4),
          child: Column(children: <Widget>[
            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Expanded(
                  child: Container(
                    child: TableSimple(
                      crewColumn: _makeTitleColumn(),
                      projectRow: _makeTitleRow(),
                      data: _makeData(),
                    ),
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
                        AddTruckButton(),
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
    }
    return Container();
  }
}

class AddProjectButtonDisabled extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.all(4),
      color: Colors.black12,
      child: Center(child: Text("Total", style: TextStyle(fontSize: 22, color: AppConfig().primaryColor, fontWeight: FontWeight.bold))),
    );
  }
}

class AddTruckButton extends StatelessWidget {
  final GlobalKey<FormState> _truckIDKey = GlobalKey();
  final GlobalKey<FormState> _ticketKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var timesheetData = Provider.of<TimeSheet>(context);
    return MaterialButton(
      minWidth: 152,
      height: double.maxFinite,
      padding: const EdgeInsets.all(4),
      color: AppConfig().primaryColor,
      textColor: Colors.white,
      elevation: 3.0,
      enableFeedback: true,
      onPressed: () async {
        if (timesheetData.listProjects.isEmpty) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(actions: <Widget>[
                  TextButton(
                    child: Text(AppLocalizations.of(context).translate("understood")),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], content: Text(AppLocalizations.of(context).translate("truckhasnotbeenassigned")));
              });
        } else {
          int count = 0;
          for (var tsproject in timesheetData.listProjects) {
            if (tsproject.truck.valueMath == 0.0) {
              count++;
            }
          }
          if (timesheetData.listProjects.length == count && false) {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(actions: <Widget>[
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate("understood")),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ], content: Text(AppLocalizations.of(context).translate("truckhasnotbeenassigned")));
                });
          } else {
            TextEditingController truckcontroller1 = TextEditingController();
            TextEditingController truckcontroller2 = TextEditingController();
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).translate("entertruck")),
                    content: Container(
                      child: Row(
                        children: [
                          Container(
                            child: const Icon(
                              Icons.local_shipping_outlined,
                              size: 80,
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                width: 260,
                                child: Form(
                                  key: _truckIDKey,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    autofocus: true,
                                    decoration: InputDecoration(hintText: AppLocalizations.of(context).translate("truckdetailorid")),
                                    controller: truckcontroller1,
                                    validator: (text) {
                                      if (timesheetData.listTruckName.contains(text)) {
                                        return AppLocalizations.of(context).translate("truckidalreadypresent");
                                      }
                                      if (text!.isEmpty) return AppLocalizations.of(context).translate("entertruckdetail");
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 260,
                                child: Form(
                                  key: _ticketKey,
                                  child: TextFormField(
                                    keyboardAppearance: Brightness.dark,
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    decoration: InputDecoration(hintText: AppLocalizations.of(context).translate("truckticketnumber")),
                                    controller: truckcontroller2,
                                    validator: (text) {
                                      if (text!.isEmpty) return AppLocalizations.of(context).translate("enterticketnumber");
                                      return null;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: <Widget>[
                      TextButton(
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("CANCEL")),
                      TextButton(
                          onPressed: () {
                            if (_truckIDKey.currentState!.validate() && _ticketKey.currentState!.validate()) {
                              Truck truck = Truck();

                              for (var project in timesheetData.listProjects) {
                                truck = Truck();
                                truck.setTruckID = truckcontroller1.text.trim();
                                truck.setTicket = truckcontroller2.text.trim();
                                project.setTruckInList = truck;
                              }
                              timesheetData.setTruck = truck.truckID;
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("ADD")),
                    ],
                  );
                });
          }
        }
      },
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
          Text("Add Truck")
        ],
      ),
      hoverElevation: 2.0,
    );
  }
}

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    content: Text(AppLocalizations.of(context).translate("materialswillberesettozeroandtruckswillberemoved")),
                    actions: <Widget>[
                      TextButton(
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.redAccent)),
                          onPressed: () {
                            Provider.of<TimeSheet>(context, listen: false).clearMaterials();
                            Navigator.of(context).pop();
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
        timeSheet.clearMaterials();
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
    return StickyHeadersTable(
      columnsLength: crewColumn.length,
      rowsLength: projectRow.length,
      columnsTitleBuilder: (i) => crewColumn[i],
      rowsTitleBuilder: (i) => projectRow[i],
      contentCellBuilder: (i, j) {
        return data[i][j];
      },
      legendCell: materialEntryDateContainer(DateSelector(
        disabled: true,
      )),
      cellDimensions: const CellDimensions.fixed(
        // contentCellHeight: 140,
        // contentCellWidth: 152,
        // stickyLegendHeight: 152,
        // stickyLegendWidth: 152,
        contentCellHeight: 140,
        contentCellWidth: 152,
        stickyLegendHeight: 160,
        stickyLegendWidth: 152,
      ),
    );
  }
}
