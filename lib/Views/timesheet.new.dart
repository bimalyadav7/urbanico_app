import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urbanico_app/Providers/authentication.provider.dart';
import 'package:urbanico_app/Providers/timesheet.provider.dart';
import 'package:urbanico_app/Views/TimesheetNew/timesheet.view.dart' as TimesheetMainNew;

class TimesheetEntry extends StatelessWidget {
  const TimesheetEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Flexible(child: Text("hi")),
      Expanded(
          child: Row(
        children: [Expanded(child: Text("Table")), Expanded(child: Text("Stats"))],
      )),
    ]);
  }
}

class TimesheetEntry2 extends ConsumerWidget {
  List<DataColumn> columns = [
    DataColumn(label: Text("S.no")),
    DataColumn(label: Text("Date")),
    DataColumn(label: Text("Status")),
    DataColumn(label: Text("Action")),
  ];
  List<DataRow> rows = [
    DataRow(cells: [
      DataCell(Text("1")),
      DataCell(Text("2022-03-10")),
      DataCell(Text("Both Verified")),
      DataCell(Row(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Row(children: [Icon(Icons.remove_red_eye), Icon(Icons.delete)]),
          )
        ],
      )),
    ]),
    DataRow(cells: [
      DataCell(Text("2")),
      DataCell(Text("2022-03-11")),
      DataCell(Text("Re-Verify")),
      DataCell(Row(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Row(children: [Icon(Icons.remove_red_eye), Icon(Icons.delete)]),
          )
        ],
      )),
    ]),
    DataRow(cells: [
      DataCell(Text("3")),
      DataCell(Text("2022-03-12")),
      DataCell(Text("Not Verified")),
      DataCell(Row(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Row(children: [Icon(Icons.edit), Icon(Icons.delete)]),
          )
        ],
      )),
    ]),
    DataRow(cells: [
      DataCell(Text("4")),
      DataCell(Text("2022-03-13")),
      DataCell(Text("Offline Draft")),
      DataCell(Row(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Row(children: [Icon(Icons.remove_red_eye_sharp), Icon(Icons.delete)]),
          ),
        ],
      )),
    ]),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
            child: Material(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        initialValue: "Search",
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TimesheetEntryPage(),
                          ));
                        },
                        child: Row(
                          children: [Icon(Icons.add), Text("Create Timesheet")],
                        )),
                    TextButton(
                        onPressed: () {
                          ref.read(timesheetNotifier).clearBox();
                        },
                        child: Text("Clear Timesheet")),
                  ],
                ),
                Expanded(child: DataTable(columns: columns, rows: rows))
              ],
            ),
          ),
        )),
        Expanded(
          child: TimesheetOverviewPage(),
        )
      ],
    );
  }
}

//Container(
//             child: MaterialButton(
//                 onPressed: () {
//                   ref.read(authNotifier.notifier).login('adminuser@gmail.com', 'urbanico123');
//                 },
//                 child: ref.watch(authNotifier).when(data: (data) {
//                   return Text("$data");
//                 }, error: (obj, trace) {
//                   return Text("Retry");
//                 }, loading: () {
//                   return CircularProgressIndicator();
//                 })),
//           );

class TimesheetOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [Text("Date"), Text("data")],
    );
  }
}

class TimesheetEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TimesheetMainNew.TimesheetMain();
  }
}
