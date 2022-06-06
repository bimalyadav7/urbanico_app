import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Request/auth_api.dart';
import 'package:urbanico_app/appConfig.dart';

final serviceurl = AppConfig().baseUrl;
final headerType = {"Content-Type": "application/x-www-form-urlencoded"};
const Color headingColor1 = Color(0xffffd27f);
const Color headingColor2 = Color(0xffffb732);

Container tableCellContainer({child, align = Alignment.centerLeft}) => Container(
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.all(2.0),
      alignment: align,
      child: child,
    );

class PlanView extends StatefulWidget {
  @override
  _PlanViewState createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  late List<dynamic> jsonresp;
  late List<TableRow> tableRow;
  late TextEditingController controller = TextEditingController();
  late bool isloading;
  late DateTime todayDate;
  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  late String enddate;
  late String startdate;

  @override
  void initState() {
    jsonresp = [];
    todayDate = DateTime.now();
    DateTime currentWeekFirstDay = todayDate.subtract(Duration(days: todayDate.weekday));
    initTableHeader(currentWeekFirstDay);
    loadWeekPlan(todayDate);
    isloading = true;
    super.initState();
  }

  initTableHeader(DateTime currentWeekFirstDay) {
    List<TableCell> cells = [];
    tableRow = [];
    cells.add(TableCell(child: tableCellContainer(child: const Text(""))));
    for (int i = 0; i < days.length; i++) {
      cells.add(TableCell(
          child: tableCellContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              days[i],
              style: TextStyle(color: AppConfig().primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(DateFormat('MM/dd/yyyy').format(currentWeekFirstDay.add(Duration(days: i))).toString(),
                style: TextStyle(color: AppConfig().primaryColor))
          ],
        ),
      )));
    }
    tableRow.add(TableRow(decoration: const BoxDecoration(color: Color(0xFF0a0d1b)), children: cells.toList()));
  }

  loadWeekPlan(pickedDate) async {
    DateTime currentWeekFirstDay = pickedDate.subtract(Duration(days: pickedDate.weekday));
    DateTime currentWeekLastDate = currentWeekFirstDay.add(const Duration(days: 6));

    enddate = DateFormat('yyyy-MM-dd').format(currentWeekLastDate).toString();
    startdate = DateFormat('yyyy-MM-dd').format(currentWeekFirstDay).toString();
    String userid = Provider.of<UserRepository>(context, listen: false).authUser.userID;

    try {
      setState(() {
        isloading = true;
      });
      var response = await AuthApi().fetchAllPlans(startdate, enddate, userid);

      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        if (responsebody["response"] == "success") {
          jsonresp = responsebody["data"];

          initTableHeader(currentWeekFirstDay);

          for (int i = 0; i < jsonresp.length; i++) {
            List<TableCell> cellProject = [];
            List<TableCell> weekCellList = [];
            List<TableCell> planCellList = [];
            List<TableCell> actualCellList = [];

            cellProject.add(TableCell(
                child: tableCellContainer(
              child: const Text(
                "Project",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )));
            weekCellList.add(TableCell(
                child: tableCellContainer(
              child: const Text(
                "Weekly",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )));
            planCellList.add(TableCell(
                child: tableCellContainer(
              child: const Text(
                "Plan",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )));
            actualCellList.add(TableCell(
                child: tableCellContainer(
              child: const Text(
                "Actual",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )));

            for (int j = 0; j < days.length; j++) {
              cellProject.add(TableCell(child: tableCellContainer(child: Text(jsonresp[i][days[j]]))));
              weekCellList.add(TableCell(child: tableCellContainer(child: Text(jsonresp[i][days[j] + "Weekly"]))));
              planCellList.add(TableCell(child: tableCellContainer(child: Text(jsonresp[i][days[j] + "Plan"]))));
              actualCellList.add(TableCell(child: tableCellContainer(child: Text(jsonresp[i][days[j] + "Actual"]))));
            }
            tableRow
                .add(TableRow(decoration: BoxDecoration(color: (i.isOdd) ? headingColor1 : headingColor2), children: cellProject.toList()));
            tableRow.add(TableRow(children: weekCellList.toList()));
            tableRow.add(TableRow(children: planCellList.toList()));
            tableRow.add(TableRow(children: actualCellList.toList()));
          }

          setState(() {
            isloading = false;
          });
        }
      }
    } catch (err) {
      setState(() {
        jsonresp = [
          {"err": err.toString()}
        ];
        isloading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: TextFormField(
                readOnly: true,
                enableInteractiveSelection: true,
                controller: controller,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    labelText: "Click to Select a Date",
                    labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
                onTap: () async {
                  // DateTime currentDate = DateTime.now();
                  DateTime? pickedDate = await showDatePicker(
                      context: context, firstDate: DateTime(1900), initialDate: DateTime.now(), lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    loadWeekPlan(pickedDate);
                    controller.text = "$startdate to $enddate";
                  }
                },
              ),
            ),
            // Text(this.jsonresp)
            const SizedBox(
              height: 8,
            ),
            Card(
              elevation: 2,
              child: Table(
                  columnWidths: const {0: FixedColumnWidth(80)},
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: Colors.black),
                  children: tableRow.toList()),
            ),
            (isloading)
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 8.0),
                    child: const CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
