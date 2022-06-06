import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';

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

class DateSelector extends StatelessWidget {
  final formatter = DateFormat("yyyy MMMM d EEEE");
  final bool disabled;
  DateSelector({this.disabled = false});

  @override
  Widget build(BuildContext context) {
    var timesheetData = Provider.of<TimeSheetViewRepo>(context);
    var currentDate = timesheetData.date;
    var formattedDate = [];
 formattedDate = formatter.format(currentDate).split(" ");
    return TextButton(
      child: (currentDate != null)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(alignment: Alignment.topCenter, padding: const EdgeInsets.symmetric(vertical: 2), child: const Icon(Icons.calendar_today)),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    formattedDate[0],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${formattedDate[1]}, ${formattedDate[2]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    formattedDate[3],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            )
          : Container(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const <Widget>[
                Icon(
                  Icons.calendar_today,
                  size: 36,
                ),
                Text(
                  "Enter Timesheet Date Here",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )),
      onPressed: () async {
        if (!disabled) {
          String entrypersonid = Provider.of<UserRepository>(context, listen: false).authUser.userID;

          DateTime? pickedDate =
              await showDatePicker(context: context, firstDate: DateTime(1900), initialDate: DateTime.now(), lastDate: DateTime(2100));

          if (pickedDate != null && pickedDate != currentDate) {
            timeSheetDataLoadingDialog(context);
            if (await timesheetData.isTimesheetDateFilled(pickedDate, entrypersonid)) {
              Navigator.of(context).pop();
              await timeSheetAlertDialog(context, "Selected Date Already has a Timesheet entry. Please Select Another Date.");
            } else {
              Navigator.of(context).pop();
              timesheetData.setDate = pickedDate;
            }
          }
        }
      },
    );
  }
}
