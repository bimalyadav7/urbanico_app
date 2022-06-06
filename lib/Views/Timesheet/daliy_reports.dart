import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/model/subcontractorModel.dart';
import 'package:urbanico_app/Repository/DailyReportRepository.dart';
import 'package:urbanico_app/Views/Timesheet/components/nextButton.dart';

class TimeSheetDailyReport extends StatefulWidget {
  final TabController tabController;
  final int tabIndex;
  TimeSheetDailyReport({required this.tabController, this.tabIndex = -1});

  @override
  State<TimeSheetDailyReport> createState() => _TimeSheetDailyReportState();
}

class _TimeSheetDailyReportState extends State<TimeSheetDailyReport> with SingleTickerProviderStateMixin {
  final TextEditingController _workPerformedController = TextEditingController();

  final TextEditingController _delayController = TextEditingController();

  final TextEditingController _safetyController = TextEditingController();

  final TextEditingController _visitsController = TextEditingController();

  final TextEditingController _reworkController = TextEditingController();

  final TextEditingController _materialController = TextEditingController();

  final TextEditingController _extraWorkController = TextEditingController();

  late TabController dailyreportController;

  @override
  void initState() {
    super.initState();
    dailyreportController = TabController(length: 8, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var dailyReportData = Provider.of<DailyReportRepo>(context);
    if (widget.tabController.index == widget.tabIndex) {
      return Container(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TabBar(
                controller: dailyreportController,
                tabs: const <Tab>[
                  Tab(child: TabHeader('Work Performed / Detail')),
                  Tab(child: TabHeader('Materials Delivered')),
                  Tab(child: TabHeader('SubContractors')),
                  Tab(child: TabHeader('Delays')),
                  Tab(child: TabHeader('Safety Accident')),
                  Tab(child: TabHeader('Visitors')),
                  Tab(child: TabHeader('Rework')),
                  Tab(child: TabHeader('Extra Work')),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: dailyreportController,
              children: <Widget>[
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _workPerformedController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter Work Performed / Detail"),
                    onChanged: (String text) {
                      dailyReportData.setWorkPerformed = text;
                    },
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _materialController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter Materials Delivered"),
                    onChanged: (text) {
                      dailyReportData.setMaterialDelivered = text;
                    },
                  ),
                )),
                Card(child: Padding(padding: const EdgeInsets.all(18.0), child: SubContractorEntry())),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _delayController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter Delays Here"),
                    onChanged: (String text) {
                      dailyReportData.setDelays = text;
                    },
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _safetyController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter About Safety / Accidents"),
                    onChanged: (String text) {
                      dailyReportData.setSafetyAccidents = text;
                    },
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _visitsController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter All Visitors"),
                    onChanged: (String text) {
                      dailyReportData.setVisitors = text;
                    },
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _reworkController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter Rework Done"),
                    onChanged: (String text) {
                      dailyReportData.setRework = text;
                    },
                  ),
                )),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _extraWorkController,
                    maxLines: 32,
                    decoration: const InputDecoration.collapsed(hintText: "Enter Any Extra Work"),
                    onChanged: (String text) {
                      dailyReportData.setExtraWork = text;
                    },
                  ),
                )),
              ],
            ))
          ],
        ),
      );
    }
    return Container();
  }
}

class TabHeader extends StatelessWidget {
  final String data;
  const TabHeader(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Text(
              data,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )));
  }
}

class SubContractorEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dailyReportData = Provider.of<DailyReportRepo>(context);

    List<TableRow> subContractors = [];
    var subcontractor = dailyReportData.subContractorList.map((list) {
      return TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextFormField(
            initialValue: list.subcontractorName.toString(),
            onChanged: (text) {
              list.setContractorName = text;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextFormField(
            initialValue: list.description.toString(),
            onChanged: (text) {
              list.setDescription = text;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextFormField(
            initialValue: list.quantity.toString(),
            onChanged: (text) {
              list.setQuantity = text;
            },
          ),
        ),
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              dailyReportData.removeSubContractor(list);
            })
      ]);
    }).toList();

    subContractors.add(tableHeader(dailyReportData));
    subContractors.addAll(subcontractor);

    return Container(
        child: SingleChildScrollView(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(width: 1.25),
        columnWidths: const {
          0: FlexColumnWidth(1.0),
          1: FlexColumnWidth(1.0),
          2: FlexColumnWidth(1.0),
          3: IntrinsicColumnWidth(),
        },
        children: subContractors,
      ),
    ));
  }

  TableRow tableHeader(dailyReportData) => TableRow(children: [
        const Text(
          "Subcontractor Name",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const Text(
          "Description",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const Text(
          "Quantity",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        Center(
          child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Subcontractor subcontractor = Subcontractor();
                dailyReportData.addSubContractor = subcontractor;
              }),
        ),
      ]);
}
