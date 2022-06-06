import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
// import 'package:urbanico_app/Views/timesheetPage.org';

class TimesheetSummary extends StatelessWidget {
  const TimesheetSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Card(
              child: Container(
                // color: Colors.pink,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Scaffold(
                                                  // body: TimesheetEntry(),
                                                  )));
                                    },
                                    child: const Text("Create Timesheet")),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 8,
                        child: Container(
                          // color: Colors.blueAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.greenAccent,
                        )),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Container(),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(Provider.of<UserRepository>(context).authUser.name),
      ),
    );
  }
}
