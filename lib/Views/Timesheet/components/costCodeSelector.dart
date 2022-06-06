import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Views/Timesheet/components/headerAndInfo.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/costCodeModel.dart';
import 'package:urbanico_app/model/phaseModel.dart';
import 'package:urbanico_app/model/projectModel.dart';
import 'package:urbanico_app/model/resourceModel.dart';
import 'package:urbanico_app/Repository/ProjectRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';
import 'package:urbanico_app/tools/internetChecker.dart';

class CostCodeSelectorPage extends StatefulWidget {
  @override
  _CostCodeSelectorPageState createState() => _CostCodeSelectorPageState();
}

class _CostCodeSelectorPageState extends State<CostCodeSelectorPage> {
  final TextEditingController editingController = TextEditingController();
  String _isEmpty = "";

  List<CostCode> costCodeList = [];
  List<CostCode> populateList = [];
  List<String> selectedCostCodeHashList = [];
  @override
  void initState() {
    super.initState();
  }

  void searchAndFilter(String query) {
    populateList.clear();
    populateList.addAll(costCodeList);
    List<CostCode> dummySearchList = [];
    dummySearchList.addAll(populateList);

    if (query.isNotEmpty) {
      List<CostCode> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.costcodeDesc.toLowerCase().contains(query.toLowerCase()) ||
            item.costcodeName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        populateList.clear();
        populateList.addAll(dummyListData);
      });
    } else {
      setState(() {
        populateList.clear();
        populateList.addAll(costCodeList);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var projectSelectorrepo = Provider.of<SelectProjectRepository>(context);
    var projectSelector = Provider.of<ProjectRepository>(context);
    var timesheetData = Provider.of<TimeSheet>(context);
    var costcodeSelector = Provider.of<SelectPhaseRepository>(context);

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
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        HeaderAndInfo(
                          headertext: "Cost Code List",
                          infotext: AppLocalizations.of(context).translate("costcodelistinfo"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: AppConfig().primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "CostCode for : ${(projectSelectorrepo.getCurrentProject == null) ? 'Please First Select Project From Below' : projectSelectorrepo.getCurrentProject.projectName}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Phase : ${(costcodeSelector.getCurrentPhase == null) ? 'Please First Select Project And Phase From Below' : costcodeSelector.getCurrentPhase.phasedesc}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 40,
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
                    height: 6,
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          child: ListView.builder(
                              itemCount: populateList.length,
                              itemBuilder: (context, index) {
                                var isInSelection = selectedCostCodeHashList.firstWhere(
                                    (element) => element == populateList[index].costcodeName + costcodeSelector.getCurrentPhase.projectID,
                                    orElse: () => "");
                                var isPresent = timesheetData.listProjects.firstWhere(
                                    (element) => (element.costCode.costcodeID == populateList[index].costcodeID &&
                                        element.phase.phaseid == costcodeSelector.getCurrentPhase.phaseid),
                                    orElse: () => TimeSheetProject.emptyProject());

                                if (isPresent.isEmpty && isInSelection == "") {
                                  return Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 50,
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.present_to_all,
                                            size: 26,
                                            color: Colors.black,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                populateList[index].costcodeName.trim().toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                              ),
                                              Text(
                                                populateList[index].costcodeDesc.trim().toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            costcodeSelector.setCostCode(costcodeSelector.getCurrentPhase, populateList[index]);
                                            selectedCostCodeHashList
                                                .add((populateList[index].costcodeName + costcodeSelector.getCurrentPhase.projectID));
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
                  Container(
                      width: double.infinity,
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: MaterialButton(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (await CheckInternet().isInternetConnected()) {
                            await projectSelector.getAllProjects(resync: true);
                          }
                          if (projectSelector.getState == FutureState.Loaded) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(child: SelectProjectDialog()),
                                  );
                                });
                            setState(() {
                              costCodeList.clear();
                              populateList.clear();
                              costCodeList.addAll(Provider.of<CostCodeRepository>(context, listen: false).listProjectCostCode);

                              populateList.addAll(costCodeList.where((test) =>
                                  !selectedCostCodeHashList.contains(test.costcodeName + costcodeSelector.getCurrentPhase.phaseid)));
                            });
                          }
                          if (projectSelector.getState == FutureState.Unauthenticated) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (projectSelector.getState == FutureState.Loading)
                              ? <Widget>[
                                  const Center(child: CircularProgressIndicator()),
                                  const SizedBox(width: 12),
                                  const Text("Loading...")
                                ]
                              : <Widget>[
                                  const Icon(Icons.add),
                                  const SizedBox(width: 12),
                                  Text(AppLocalizations.of(context).translate("selectaproject"))
                                ],
                        ),
                        hoverElevation: 2.0,
                      )),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          HeaderAndInfo(
                            headertext: "Selected Cost Code List",
                            infotext: AppLocalizations.of(context).translate("costcodelistremoveinfo"),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              size: 32,
                            ),
                            onPressed: () async {
                              List<TimeSheetProject> tslist = [];
                              for (var phase in costcodeSelector.getMap.keys) {
                                costcodeSelector.getMap[phase]!.forEach((costcode) async {
                                  TimeSheetProject tsproject = TimeSheetProject();

                                  Project project = projectSelector.listProjects
                                      .firstWhere((element) => element.projectID == phase.projectID || element.projectID == phase.parentID);
                                  tsproject.setProject = project;
                                  tsproject.setPhase = phase;
                                  tsproject.setCostCode = costcode;
                                  for (int i = 0; i < timesheetData.listTruckName.length; i++) {
                                    Truck truck = Truck();
                                    truck.setTruckID = timesheetData.listTruckName[i];
                                    tsproject.setTruckInList = truck;
                                  }
                                  for (int i = 0; i < timesheetData.listEquipments.length; i++) {
                                    ProjectEquipment projectEquipment = ProjectEquipment();
                                    projectEquipment.setEquipment = timesheetData.listEquipments[i];
                                    tsproject.setEquipment = projectEquipment;
                                  }
                                  tslist.add(tsproject);
                                });
                              }
                              Provider.of<TimeSheet>(context, listen: false).setProjectsAll = tslist;
                              Provider.of<TimeSheet>(context, listen: false).setMaterialValues();

                              costcodeSelector.destroyMap();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          child: CustomScrollView(
                            slivers: (projectSelector.listProjects.isNotEmpty)
                                ? costcodeSelector.getMap.keys.map((phase) {
                                    Project project = projectSelector.listProjects.firstWhere(
                                        (element) => element.projectID == phase.projectID || element.projectID == phase.parentID);
                                    return SliverStickyHeader(
                                      header: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                        height: 56,
                                        color: Colors.lightBlue,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "${project.projectName} - ${project.projectCode}",
                                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                "${phase.phaseid} - ${phase.phasedesc}",
                                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, i) => Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 58,
                                                child: ListTile(
                                                  leading: const Icon(
                                                    Icons.present_to_all,
                                                    size: 26,
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Text(
                                                        costcodeSelector.getMap[phase]![i].costcodeName.trim().toString(),
                                                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                                      ),
                                                      Text(
                                                        costcodeSelector.getMap[phase]![i].costcodeDesc.trim().toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.highlight_remove,
                                                    color: Colors.redAccent,
                                                    size: 28.0,
                                                  ),
                                                  onTap: () {
                                                    selectedCostCodeHashList.removeWhere((test) =>
                                                        test == costcodeSelector.getMap[phase]![i].costcodeName + phase.projectID);
                                                    costcodeSelector.removeCostCode(phase, costcodeSelector.getMap[phase]![i]);
                                                  },
                                                ),
                                              ),
                                              const Divider()
                                            ],
                                          ),
                                          childCount: costcodeSelector.getMap[phase]!.length,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [],
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

class SelectProjectDialog extends StatefulWidget {
  @override
  _SelectProjectDialogState createState() => _SelectProjectDialogState();
}

class _SelectProjectDialogState extends State<SelectProjectDialog> {
  final TextEditingController editingController = TextEditingController();
  List<Project> populateList = [];
  List<Project> projectList = [];

  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    _isAdded = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void searchAndFilter(String query) {
    populateList.clear();
    populateList.addAll(projectList);
    List<Project> dummySearchList = [];
    dummySearchList.addAll(populateList);

    if (query.isNotEmpty) {
      List<Project> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.projectName.toLowerCase().contains(query.toLowerCase()) || item.projectCode.toLowerCase().contains(query.toLowerCase())) {
          if (!dummyListData.contains(item)) dummyListData.add(item);
        }
      }
      setState(() {
        populateList.clear();
        populateList.addAll(dummyListData);
      });
    } else {
      setState(() {
        populateList.clear();
        populateList.addAll(projectList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var projectselector = Provider.of<SelectProjectRepository>(context, listen: false);
    var phaseRepo = Provider.of<SelectPhaseRepository>(context, listen: false);
    var costcodeRepo = Provider.of<CostCodeRepository>(context);
    var projectRepo = Provider.of<ProjectRepository>(context);

    if (projectRepo.getState == FutureState.Loading || costcodeRepo.getState == FutureState.Loading) {
      return SizedBox(
        height: 520,
        width: 520,
        child: Center(
            child: Column(
          children: const <Widget>[CircularProgressIndicator(), Text("Loading...", style: TextStyle(color: Colors.white))],
        )),
      );
    }

    if (!_isAdded) {
      setState(() {
        projectList.addAll(projectRepo.listProjects);
        populateList.addAll(projectList);
        _isAdded = true;
      });
    }

    return SizedBox(
      height: 520,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 44,
            child: TextField(
              maxLines: 1,
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              onChanged: (String query) {
                searchAndFilter(query);
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
              child: SizedBox(
            width: 340,
            child: ListView(
              children: populateList.map((project) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 38,
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(project.projectCode.trim().toString(),
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            Text(
                              project.projectName.trim(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        onTap: () async {
                          projectselector.setCurrentProject = project;
                          if (projectRepo.getState != FutureState.Loading || costcodeRepo.getState != FutureState.Loading) {
                            await projectRepo.getPhasesForProject(project.projectID, resync: true);
                            if (projectRepo.getState == FutureState.Unauthenticated) {
                              Navigator.of(context).pop();
                            } else if (projectRepo.getState == FutureState.Loaded) {
                              phaseRepo.setCurrentPhase = Phase();
                            }
                            if (projectRepo.onlyPhase.parentID == "0") {
                              await costcodeRepo.getCostCodesByProjectID(projectRepo.onlyPhase.projectID);
                              if (costcodeRepo.getState == FutureState.Unauthenticated) {
                                Navigator.of(context).pop();
                              }
                              Provider.of<SelectPhaseRepository>(context, listen: false).setCurrentPhase = projectRepo.onlyPhase;
                            } else {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Material(
                                          child: SelectPhaseDialog(),
                                        ),
                                      ),
                                    );
                                  });
                            }
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    const Divider(
                      thickness: .75,
                    )
                  ],
                );
              }).toList(),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Card(
                color: Colors.redAccent,
                elevation: 1.2,
                child: TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}

class SelectPhaseDialog extends StatefulWidget {
  @override
  _SelectPhaseDialogState createState() => _SelectPhaseDialogState();
}

class _SelectPhaseDialogState extends State<SelectPhaseDialog> {
  final TextEditingController editingController = TextEditingController();
  List<Phase> populateList = [];
  List<Phase> phaseList = [];

  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    _isAdded = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void searchAndFilter(String query) {
    populateList.clear();
    populateList.addAll(phaseList);
    List<Phase> dummySearchList = [];
    dummySearchList.addAll(populateList);

    if (query.isNotEmpty) {
      List<Phase> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.phasecode.toLowerCase().contains(query.toLowerCase()) || item.phaseid.toLowerCase().contains(query.toLowerCase())) {
          if (!dummyListData.contains(item)) dummyListData.add(item);
        }
      }
      setState(() {
        populateList.clear();
        populateList.addAll(dummyListData);
      });
    } else {
      setState(() {
        populateList.clear();
        populateList.addAll(phaseList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var costcodeSelector = Provider.of<SelectPhaseRepository>(context, listen: false);
    var phaseRepo = Provider.of<ProjectRepository>(context, listen: false);
    var costCodeList = Provider.of<CostCodeRepository>(context);

    if (costCodeList.getState == FutureState.Loading) {
      return SizedBox(
        height: 520,
        width: 520,
        child: Center(
            child: Column(
          children: const <Widget>[CircularProgressIndicator(), Text("Loading...", style: TextStyle(color: Colors.white))],
        )),
      );
    }

    if (!_isAdded) {
      setState(() {
        phaseList.addAll(phaseRepo.listPhases);
        populateList.addAll(phaseList);
        _isAdded = true;
      });
    }

    return SizedBox(
      height: 520,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 44,
            child: TextField(
              maxLines: 1,
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              onChanged: (String query) {
                searchAndFilter(query);
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
              child: SizedBox(
            width: 340,
            child: ListView(
              children: populateList.map((phase) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 38,
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(phase.phaseid.trim().toString(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                            Text(
                              phase.phasedesc.trim(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        onTap: () async {
                          await costCodeList.getCostCodesByProjectID(phase.projectID);
                          costcodeSelector.setCurrentPhase = phase;

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const Divider(
                      thickness: .75,
                    )
                  ],
                );
              }).toList(),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Card(
                color: Colors.redAccent,
                elevation: 1.2,
                child: TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
