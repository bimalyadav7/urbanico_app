import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Views/Timesheet/components/headerAndInfo.dart';
import 'package:urbanico_app/model/userModel.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class CrewSelectorPage extends StatefulWidget {
  const CrewSelectorPage();
  @override
  _CrewSelectorPageState createState() => _CrewSelectorPageState();
}

class _CrewSelectorPageState extends State<CrewSelectorPage> {
  final TextEditingController editingController = TextEditingController();

  late String _isEmpty;

  List<User> userList = [];
  List<User> populateList = [];
  List<User> selectedUsers = [];
  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
  }

  void searchAndFilter(String query) {
    populateList.addAll(userList);
    populateList.remove(selectedUsers);
    List<User> dummySearchList = [];
    dummySearchList.addAll(populateList);

    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.name.toLowerCase().contains(query.toLowerCase()) || item.contact.toLowerCase().contains(query.toLowerCase())) {
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
        populateList.addAll(userList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<MultiUserRepository>(context, listen: false);
    var timesheetData = Provider.of<TimeSheet>(context, listen: false);
    if (!_isAdded) {
      setState(() {
        userList.addAll(userRepo.listUsers);
        populateList.addAll(userList);
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
                          headertext: "Crew List",
                          infotext: AppLocalizations.of(context).translate("crewlistinfo"),
                        ),
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
                      "Users",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ListView.builder(
                              itemCount: populateList.length,
                              itemBuilder: (context, index) {
                                var isInSelection = selectedUsers.firstWhere((element) => element.userID == populateList[index].userID,
                                    orElse: () => User());
                                var isPresent = timesheetData.listCrews
                                    .firstWhere((element) => element.crew.userID == populateList[index].userID, orElse: () => Crew());
                                if (isPresent.id == -1 && isInSelection.userID == "") {
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
                                                populateList[index].contact.trim().toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                              ),
                                              Text(
                                                populateList[index].name.trim().toString(),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectedUsers.add(populateList[index]);
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
                            headertext: "Selected Crew List",
                            infotext: AppLocalizations.of(context).translate("crewlistremoveinfo"),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              size: 32,
                            ),
                            onPressed: () {
                              for (var i = 0; i < selectedUsers.length; i++) {
                                Crew selectedCrew = Crew();
                                selectedCrew.setCrew = selectedUsers[i];
                                Provider.of<TimeSheet>(context, listen: false).setCrews = selectedCrew;
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
                            children: selectedUsers.map((user) {
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
                                            user.contact.trim().toString(),
                                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                                          ),
                                          Text(
                                            user.name.trim().toString(),
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
                                          selectedUsers.remove(user);
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
