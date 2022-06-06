
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/appConfig.dart';

class QuantityCard extends StatelessWidget {
  final TimeSheetProject tsproject;
  const QuantityCard(this.tsproject);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);

    var quantityInteract =
        Provider.of<UIKeypadRepository>(context, listen: false);
    return GestureDetector(
      child: Container(
        color: (quantityInteract.selectedQuantityPresent(tsproject))
            ? Colors.greenAccent
            : AppConfig().primaryColor,
        padding: const EdgeInsets.only(top: 4),
        height: 34,
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: tsproject.quantity.toString(),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          keyboardType:
              const TextInputType.numberWithOptions(signed: false, decimal: true),
          onChanged: (String qty) {
            tsproject.setQuantity = double.parse(qty);
          },
        ),
      ),
      onTap: () {
        quantityInteract.setselectedFieldName = "quantity";
        quantityInteract.clearAllSelections(
            field: quantityInteract.selectedFieldName);

        if (quantityInteract.selectedQuantityPresent(tsproject)) {
          quantityInteract.removeTimesheetProject(tsproject);
        } else {
          quantityInteract.setSelectedTimesheetProject = tsproject;
        }
        Provider.of<UIKeypadRepository>(context, listen: false).enableKeypad();
        timesheet.refresh();
      },
    );
  }
}