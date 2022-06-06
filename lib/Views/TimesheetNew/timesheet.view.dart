import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urbanico_app/Providers/timesheet.provider.dart';
import 'package:urbanico_app/Views/Timesheet/components/dateSelector.dart';
import 'package:urbanico_app/Views/TimesheetNew/components/tableStickyHeader.dart';
import 'package:urbanico_app/models/timesheetproject.model.dart';
import 'package:urbanico_app/models/workhour.model.dart';

class TableCard extends StatelessWidget {
  Widget child;
  Color? color;
  TableCard({Key? key, required this.child, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        color: color,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class TimesheetMain extends StatelessWidget {
  final int tabIndex;

  List<Widget> seletedCells = [];

  TimesheetMain({Key? key, this.tabIndex = -1}) : super(key: key);

  List<Widget> makeColumns(WidgetRef ref) {
    final provider = ref.watch(timesheetNotifier);
    final tsprojects = provider.tsprojects;
    List<Widget> list = [];
    for (int i = 0; i < tsprojects.length; i++) {
      TextEditingController quantityController = TextEditingController();
      quantityController.text = tsprojects[i].quantity.toString();

      list.add(Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                  child: GestureDetector(
                child: const Icon(Icons.cancel, color: Colors.redAccent, size: 23),
                onTap: () {
                  provider.removeProject(tsprojects[i]);
                },
              )),
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    tsprojects[i].project.projectCode,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(tsprojects[i].project.projectName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                  Text('${tsprojects[i].phase.phasecode} - ${tsprojects[i].phase.phasedesc}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                ],
              ),
            )),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tsprojects[i].costcode.costcodeName.trim(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                tsprojects[i].costcode.costcodeDesc.trim(),
                overflow: TextOverflow.ellipsis,
              ),
              Text(tsprojects[i].project.projectID)
            ],
          ),
          Flexible(
              child: Container(
                  child: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "Quantity Claim",
              border: InputBorder.none,
            ),
            controller: quantityController,
            onChanged: (String? value) {
              double dvalue = tsprojects[i].quantity;
              if (value != null) {
                dvalue = double.tryParse(value) ?? tsprojects[i].quantity;
              } else {
                dvalue = tsprojects[i].quantity;
              }
              tsprojects[i].quantity = dvalue;
            },
          )))
        ],
      ));
    }
    list.add(Text("Total top"));
    return list;
  }

  List<Widget> makeRows(WidgetRef ref) {
    final provider = ref.watch(timesheetNotifier);
    final users = provider.users;
    final absUsers = provider.absentUsers;
    List<Widget> list = [];
    for (int i = 0; i < users.length; i++) {
      list.add(Row(
        children: [
          Flexible(
            flex: 5,
            child: TableCard(
              child: Stack(children: [
                Positioned(
                  top: 1,
                  right: 3,
                  child: Container(
                      child: GestureDetector(
                    child: const Icon(Icons.cancel, color: Colors.redAccent, size: 23),
                    onTap: () {
                      provider.removeUser(users[i]);
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
                        users[i].contact,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Divider(
                        height: 3.8,
                        endIndent: 28,
                        color: Colors.deepPurple,
                      ),
                      Text(
                        users[i].name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
              ]),
            ),
          ),
          Flexible(
              flex: 2,
              child: TableCard(
                color: absUsers.contains(users[i]) ? Colors.red.shade200 : Colors.green.shade200,
                child: GestureDetector(
                  onTap: () {
                    if (absUsers.contains(users[i])) {
                      provider.makePresent(users[i]);
                    } else {
                      provider.makeAbsent(users[i]);
                    }
                  },
                  child: Text(
                    absUsers.contains(users[i]) ? "Absent" : "Present",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ))
        ],
      ));
    }
    list.add(TableCard(child: Text("Total bottom")));
    return list;
  }

  List<List<Widget>> makeData(WidgetRef ref) {
    final provider = ref.watch(timesheetNotifier);
    final tsprojects = provider.tsprojects;
    final users = provider.users;
    final absUsers = provider.absentUsers;
    List<List<Widget>> list = [];
    for (int i = 0; i < tsprojects.length; i++) {
      List<Widget> rowWidget = [];
      for (int j = 0; j < users.length; j++) {
        WorkhourData wdata =
            provider.workhours.firstWhere((element) => element.tsproject == tsprojects[i] && element.user == users[j], orElse: () {
          WorkhourData data = WorkhourData(tsproject: tsprojects[i], user: users[j], workhour: 0);
          provider.addWorkhour(data);
          WorkhourData d = provider.workhours.last;
          return d;
        });
        if (absUsers.contains(users[j])) {
          rowWidget.add(TableCard(
            color: Colors.red.shade200,
            child: Center(
              child: Icon(Icons.highlight_remove_sharp),
            ),
          ));
        } else {
          TextEditingController controller = TextEditingController();
          controller.text = wdata.workhour.toString();
          rowWidget.add(TableCard(
            color: wdata.selected ? Colors.green : Colors.white,
            child: TextField(
              onTap: () {
                // provider.toggleWorkhourSelection(wdata);
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: controller,
              onChanged: (String? value) {
                double dvalue = wdata.workhour;
                if (value != null) {
                  dvalue = double.tryParse(value) ?? wdata.workhour;
                } else {
                  dvalue = wdata.workhour;
                }
                provider.updateWorkhour(wdata, dvalue);
              },
            ),
          ));
        }
      }
      rowWidget.add(TableCard(
        child: Text(provider.getWorkhourTotalForProject(tsprojects[i]).toString()),
      ));
      list.add(rowWidget);
    }

    List<Widget> listOfTotal = [];
    for (int i = 0; i < users.length; i++) {
      listOfTotal.add(TableCard(
        child: Text(provider.getWorkhourTotalForUser(users[i]).toString()),
      ));
    }
    listOfTotal.add(TableCard(
      child: Text(provider.getAllTotal().toString()),
    ));
    list.add(listOfTotal);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(timesheetNotifier);
      List<Widget> columns = makeColumns(ref);
      List<Widget> rows = makeRows(ref);
      List<List<Widget>> data = makeData(ref);

      return Column(
        children: [
          Expanded(
            flex: 9,
            child: CustomStickyHeadersTable(
              initialScrollOffsetX: 0,
              initialScrollOffsetY: 0,
              columnsLength: columns.length,
              rowsLength: rows.length,
              columnsTitleBuilder: (i) => TableCard(child: columns[i]),
              rowsTitleBuilder: (i) => rows[i],
              contentCellBuilder: (i, j) => data[i][j],
              legendCell: TableCard(child: DateSelector()),
              // contentCellWidth: 160, contentCellHeight: 60, stickyLegendWidth: 220, stickyLegendHeight: 180
              cellDimensions: CellDimensions.variableColumnWidth(
                  columnWidths: [...List.generate(columns.length - 1, (index) => 160.0), 100],
                  contentCellHeight: 60,
                  stickyLegendWidth: 220,
                  stickyLegendHeight: 180),
              cellAlignments: const CellAlignments.fixed(
                  contentCellAlignment: Alignment.center,
                  stickyColumnAlignment: Alignment.centerLeft,
                  stickyRowAlignment: Alignment.topCenter,
                  stickyLegendAlignment: Alignment.topLeft),
            ),
          ),
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      provider.addUser();
                    },
                    child: Text("Add users"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      provider.addProject();
                    },
                    child: Text("Add Project"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("CLOSE"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      ref.read(timesheetNotifier).clearBox();
                    },
                    child: Text("CLEAR"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      List list = [];
                      for (int i = 0; i < provider.workhours.length; i++) {
                        list.add(provider.workhours[i].toJson());
                      }
                      print(list);
                    },
                    child: Text("submit"),
                  )
                ],
              ))
        ],
      );
    });
  }
}
