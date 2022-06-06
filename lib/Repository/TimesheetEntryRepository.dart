import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/model/timesheetEntryModel.dart';
import 'package:urbanico_app/Request/timesheet_api.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/Views/timesheetViewPage.dart';

class TimesheetEntryDataSource extends DataTableSource {
  String foremanid = "";

  final List<TimesheetEntry> _tsEntryList = [];
  BuildContext context;
  TimesheetEntryDataSource(this.foremanid, this.context) {
    getTimesheetEntry();
  }

  void getTimesheetEntry() async {
    try {
      if (_tsEntryList.isEmpty) {
        var response = await TimeSheetApi().getForemanTimesheetEntry(foremanid);
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);

          if (responseBody.length > 0) {
            for (int i = 0; i < responseBody.length; i++) {
              TimesheetEntry tsentry = TimesheetEntry.fromJson(responseBody[i]);
              _tsEntryList.add(tsentry);
            }
          }
        }
      }
    } catch (err) {
      _tsEntryList.clear();
    }
    notifyListeners();
  }

  void dosort<T>(Comparable<T> Function(TimesheetEntry d) getField, bool ascending) {
    _tsEntryList.sort((TimesheetEntry a, TimesheetEntry b) {
      if (!ascending) {
        final TimesheetEntry c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _tsEntryList.length) const DataRow(cells: []);
    final TimesheetEntry tsEntry = _tsEntryList[index];

    return DataRow.byIndex(index: index, selected: false, cells: <DataCell>[
      DataCell(Text((index + 1).toString())),
      DataCell(Text(tsEntry.date)),
      DataCell(Text(tsEntry.day)),
      DataCell(Text(tsEntry.name)),
      DataCell(Text(tsEntry.status)),
      DataCell(Text(tsEntry.nowork)),
      DataCell(Container(
          child: IconButton(
        color: AppConfig().primaryColor,
        icon: const Icon(
          Icons.remove_red_eye,
        ),
        onPressed: () async {
          Provider.of<TimeSheetViewRepo>(context, listen: false).setForUserList =
              Provider.of<MultiUserRepository>(context, listen: false).listUsers;
          Provider.of<TimeSheetViewRepo>(context, listen: false).setForDate = tsEntry.date;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TimesheetView()));
        },
      ))),
    ]);
  }

  @override
  int get rowCount => _tsEntryList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool checked) {
    for (TimesheetEntry tsEntry in _tsEntryList) {
      tsEntry.selected = checked;
    }
    _selectedCount = checked ? _tsEntryList.length : 0;
    notifyListeners();
  }
}
