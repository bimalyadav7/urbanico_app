import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/model/timesheetEntryModel.dart';
import 'package:urbanico_app/Repository/TimesheetEntryRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class ProjectSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimesheetEntryTab();
  }
}

class TimesheetEntryTab extends StatefulWidget {
  static const String routeName = '/material/data-table';

  @override
  _TimesheetEntryTabState createState() => _TimesheetEntryTabState();
}

class _TimesheetEntryTabState extends State<TimesheetEntryTab> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 1;
  bool _sortAscending = false;
  late TimesheetEntryDataSource _tsEntryListDataSource;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tsEntryListDataSource = TimesheetEntryDataSource(Provider.of<UserRepository>(context).authUser.userID, context);
  }

  void _sort<T>(Comparable<T> Function(TimesheetEntry d) getField, int columnIndex, bool ascending) {
    _tsEntryListDataSource.dosort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: PaginatedDataTable(
        header: Text(AppLocalizations.of(context).translate("yourtimesheetentries")),
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (int? value) {
          setState(() {
            _rowsPerPage = value ?? 0;
          });
        },
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: <DataColumn>[
          const DataColumn(label: Text('SN'), numeric: true),
          DataColumn(
              label: const Text('Date'),
              onSort: (int columnIndex, bool ascending) => _sort<String>((TimesheetEntry d) => d.date, columnIndex, ascending)),
          DataColumn(
              label: const Text('Day'),
              onSort: (int columnIndex, bool ascending) {
                _sort<String>((TimesheetEntry d) => d.day, columnIndex, ascending);
              }),
          const DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
              label: const Text('Status'),
              onSort: (int columnIndex, bool ascending) => _sort<String>((TimesheetEntry d) => d.status, columnIndex, ascending)),
          DataColumn(
              label: const Text('No Work'),
              onSort: (int columnIndex, bool ascending) => _sort<String>((TimesheetEntry d) => d.nowork, columnIndex, ascending)),
          DataColumn(
              label: const Text('View'),
              onSort: (int columnIndex, bool ascending) => _sort<String>((TimesheetEntry d) => d.date, columnIndex, ascending)),
        ],
        source: _tsEntryListDataSource,
      ),
    );
  }
}
