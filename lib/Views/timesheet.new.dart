import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanico_app/Request/timesheet_api.dart';
import 'package:urbanico_app/Views/TimesheetNew/timesheet.view.dart' as TimesheetMainNew;
import 'package:urbanico_app/model/userModel.dart';
import 'package:urbanico_app/models/timesheetentries.model.dart';

final timesheetEntryListColumnsProvider = Provider<List<DataColumn>>((ref) => [
      const DataColumn2(label: Text("S.no"), size: ColumnSize.S),
      const DataColumn2(label: Text("Date"), size: ColumnSize.M),
      const DataColumn2(label: Text("Day"), size: ColumnSize.M),
      const DataColumn2(label: Text("No Work"), size: ColumnSize.M),
      const DataColumn2(label: Text("Status"), size: ColumnSize.M),
      const DataColumn2(label: Text("Timestamp"), size: ColumnSize.L),
    ]);

class TimesheetEntryDraftView extends ConsumerWidget {
  const TimesheetEntryDraftView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: TextFormField(
              initialValue: "Search",
            ),
          ),
          Expanded(
              child: DataTable2(
            border: TableBorder.all(
              width: 1,
              color: Colors.black45,
              borderRadius: BorderRadius.circular(4),
            ),
            empty: Text("No Draft Timesheet"),
            columns: ref.watch(timesheetEntryListColumnsProvider),
            rows: [],
          ))
        ],
      ),
    );
  }
}

class TimesheetEntry extends StatefulWidget {
  const TimesheetEntry({Key? key}) : super(key: key);

  @override
  State<TimesheetEntry> createState() => _TimesheetEntryState();
}

class _TimesheetEntryState extends State<TimesheetEntry> {
  final Map<String, Widget> timesheetListWidgets = {"draft": const TimesheetEntryDraftView(), "submitted": TimesheetEntryListView()};
  String cList = "draft";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Material(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MaterialButton(
                                color: (cList == "draft") ? Colors.orange : Colors.white,
                                child: Text("Draft"),
                                onPressed: () => setState(() {
                                      cList = "draft";
                                    })),
                            MaterialButton(
                                color: (cList == "submitted") ? Colors.orange : Colors.white,
                                child: Text("Submitted"),
                                onPressed: () => setState(() {
                                      cList = "submitted";
                                    })),
                            Spacer(),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TimesheetMainNew.TimesheetEntryViewScaffold(),
                                  ));
                                },
                                child: Row(
                                  children: const [Icon(Icons.add), Text("Create Timesheet")],
                                )),
                          ],
                        ),
                      )),
                  Expanded(flex: 9, child: Container(color: Color.fromARGB(255, 240, 240, 240), child: timesheetListWidgets[cList])),
                ],
              ),
            )),
        const Expanded(flex: 1, child: Text("Stats"))
      ],
    );
  }
}

class TimesheetEntriesProvider extends StateNotifier<AsyncValue<List<TimesheetEntries>>> {
  TimesheetEntriesProvider() : super(const AsyncData([])) {
    getTimesheetEntries();
  }

  Future<void> getTimesheetEntries() async {
    state = const AsyncValue.loading();
    try {
      final pref = await SharedPreferences.getInstance();
      User user = User.fromJson(jsonDecode(pref.getString("userdata").toString()));
      var response = await TimeSheetApi().getForemanTimesheetEntry(user.userID);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody.length > 0) {
          List<TimesheetEntries> lists = [];
          for (int i = 0; i < responseBody.length; i++) {
            TimesheetEntries tsListModel = TimesheetEntries.fromMap(responseBody[i]);
            lists.add(tsListModel);
          }
          state = AsyncValue.data(lists);
        }
      }
    } catch (ex) {
      state = AsyncValue.error(ex);
    }
  }
}

final timesheetEntriesProvider =
    StateNotifierProvider<TimesheetEntriesProvider, AsyncValue<List<TimesheetEntries>>>((ref) => TimesheetEntriesProvider());

class TimesheetEntryListView extends ConsumerWidget {
  const TimesheetEntryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: TextFormField(
              initialValue: "Search",
            ),
          ),
          Expanded(
              child: ref.watch(timesheetEntriesProvider).when(
                  data: (data) {
                    List<DataRow> dataRows = [];
                    for (int i = 0; i < data.length; i++) {
                      List<DataCell> dataCells = [];
                      dataCells.add(DataCell(Text((i + 1).toString())));
                      dataCells.add(DataCell(Text(data[i].date)));
                      dataCells.add(DataCell(Text(data[i].day)));
                      dataCells.add(DataCell(Text(data[i].nowork)));
                      dataCells.add(DataCell(Text(data[i].status)));
                      dataCells.add(DataCell(Text(data[i].timestamp)));
                      dataRows.add(DataRow(cells: dataCells));
                    }
                    return DataTable2(
                      columns: ref.watch(timesheetEntryListColumnsProvider),
                      rows: dataRows,
                    );
                  },
                  error: (err, trace) {
                    return Container();
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )))
        ],
      ),
    );
  }
}

class TimesheetEntryPage extends StatelessWidget {
  const TimesheetEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimesheetMainNew.TimesheetEntryView();
  }
}
