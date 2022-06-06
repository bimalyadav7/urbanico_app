import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Views/Timesheet/components/headerAndInfo.dart';
import 'package:urbanico_app/model/equipmentModel.dart';
import 'package:urbanico_app/Repository/EquipmentRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class EquipmentSelectorPage extends StatefulWidget {
  @override
  _EquipmentSelectorPageState createState() => _EquipmentSelectorPageState();
}

class _EquipmentSelectorPageState extends State<EquipmentSelectorPage> {
  final TextEditingController editingController = TextEditingController();
  late String _isEmpty;

  late List<Equipment> populateList;
  late List<Equipment> selectedEquipments;
  late List<Equipment> equipmentList;

  bool _isAdded = false;

  @override
  void initState() {
    populateList = [];
    selectedEquipments = [];
    equipmentList = [];
    super.initState();
  }

  void searchAndFilter(String query) {
    populateList.addAll(equipmentList);
    populateList.remove(selectedEquipments);
    List<Equipment> dummySearchList = [];
    dummySearchList.addAll(populateList);

    if (query.isNotEmpty) {
      List<Equipment> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.equipmentdesc.toLowerCase().contains(query.toLowerCase()) ||
            item.equipmentname.toLowerCase().contains(query.toLowerCase())) {
          if (!dummyListData.contains(item)) dummyListData.add(item);
        }
      }
      setState(() {
        populateList.clear();
        if (dummyListData.isEmpty) _isEmpty = "No Result";
        populateList.addAll(dummyListData);
      });
    } else {
      setState(() {
        populateList.clear();
        populateList.addAll(equipmentList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var timesheetData = Provider.of<TimeSheet>(context);
    var equipmentRepo = Provider.of<EquipmentRepository>(context);

    if (!_isAdded) {
      setState(() {
        equipmentList.addAll(equipmentRepo.listEquipments);
        populateList.addAll(equipmentList);
        _isAdded = true;
      });
    }
    return Scaffold(
        body: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppConfig().primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        HeaderAndInfo(
                          headertext: "Equipment List",
                          infotext: AppLocalizations.of(context).translate("equipmentlistinfo"),
                        ),
                        GestureDetector(
                          child: const Icon(Icons.refresh),
                          onTap: () async {
                            await Provider.of<EquipmentRepository>(context).getAllEquipments();
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 44,
                    child: TextField(
                      controller: editingController,
                      decoration: InputDecoration(
                          hintText: "Search",
                          errorText: _isEmpty,
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))),
                      onChanged: (String query) {
                        setState(() {
                          _isEmpty = "";
                        });
                        searchAndFilter(query);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: const Text(
                      "Equipments",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ListView.builder(
                              itemCount: populateList.length,
                              itemBuilder: (context, index) {
                                var isInSelection = selectedEquipments.firstWhere(
                                    (element) => element.equipmentid == populateList[index].equipmentid,
                                    orElse: () => Equipment());
                                var isPresent = timesheetData.listEquipments.firstWhere(
                                    (element) => element.equipmentid == populateList[index].equipmentid,
                                    orElse: () => Equipment());
                                if (isPresent.equipmentid == "" && isInSelection.equipmentid == "") {
                                  return Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 38,
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.person_add,
                                            size: 28,
                                            color: Colors.black,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                populateList[index].equipmentname.trim().toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                              ),
                                              Text(
                                                populateList[index].equipmentdesc.trim().toString(),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedEquipments.add(populateList[index]);
                                            });
                                          },
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 0.75,
                                      )
                                    ],
                                  );
                                }
                                return Container();
                              }))),
                ],
              )),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          HeaderAndInfo(
                            headertext: "Selected Equipment List",
                            infotext: AppLocalizations.of(context).translate("equipmentlistremoveinfo"),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              size: 32,
                            ),
                            onPressed: () {
                              var timesheet = Provider.of<TimeSheet>(context, listen: false);
                              for (int i = 0; i < selectedEquipments.length; i++) {
                                timesheet.setEquipment = selectedEquipments[i];
                              }
                              for (int j = 0; j < timesheet.listProjects.length; j++) {
                                for (int i = 0; i < selectedEquipments.length; i++) {
                                  ProjectEquipment projectEquipment = ProjectEquipment();
                                  projectEquipment.setEquipment = selectedEquipments[i];
                                  timesheet.listProjects[j].setEquipment = projectEquipment;
                                }
                              }
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: selectedEquipments.map((equipment) {
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 38,
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        size: 28,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            equipment.equipmentname.trim().toString(),
                                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                          ),
                                          Text(
                                            equipment.equipmentdesc.trim().toString(),
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.highlight_remove,
                                        color: Colors.redAccent,
                                        size: 28.0,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedEquipments.remove(equipment);
                                        });
                                      },
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1.20,
                                  )
                                ],
                              );
                            }).toList(),
                          )),
                    )
                  ],
                ),
              )),
        ],
      ),
    ));
  }
}
