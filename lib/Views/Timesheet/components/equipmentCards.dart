import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/model/equipmentModel.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  const EquipmentCard(this.equipment);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);
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
          onTap: () async {
            bool template = false;
            for (var tsproject in timesheet.listProjects) {
              if (tsproject.checkEquipmentTemplate(equipment)) {
                template = true;
              } else {
                tsproject.removeEquipmentByEquipmentid(equipment);
              }
            }
            if (!template) {
              timesheet.removeEquipment = equipment;
            } else {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        actions: <Widget>[
                          TextButton(
                            child: Text(AppLocalizations.of(context).translate("understood")),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                        title: Text(AppLocalizations.of(context).translate("notice")),
                        content: Text(AppLocalizations.of(context).translate("equipmenttemplateremovalnotification")));
                  });
            }
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

class EquipmentHourCard extends StatelessWidget {
  final ProjectEquipment pequipment;
  const EquipmentHourCard(this.pequipment);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);
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

class EquipmentLastReadingField extends StatelessWidget {
  final List<ProjectEquipment> pequipmentList;
  const EquipmentLastReadingField(this.pequipmentList);
  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);
    var lastReadingInteract = Provider.of<UIKeypadRepository>(context, listen: false);
    return GestureDetector(
      child: Container(
        color: (lastReadingInteract.selectedLastReadingPresent(pequipmentList[0])) ? AppConfig().primaryColor : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            (pequipmentList[0].isTemplate)
                ? Text(
                    AppLocalizations.of(context).translate("previousreading") + ":" + pequipmentList[0].prevlastreading.toString(),
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0),
                  )
                : Container(),
            TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  hintText: (pequipmentList[0].lastreading == 0) ? "" : pequipmentList[0].lastreading.toString(),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.black,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0)),
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
              maxLines: 1,
              onChanged: (String time) {
                pequipmentList[0].setLastReading = double.parse(time);
                timesheet.refresh();
              },
            ),
            (pequipmentList[0].isValid)
                ? Container()
                : Text(
                    AppLocalizations.of(context).translate("invalidreading"),
                    style: const TextStyle(color: Colors.redAccent),
                  )
          ],
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
