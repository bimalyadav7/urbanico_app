import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/ForemanEntryRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/appEnvironment.dart';
import 'package:urbanico_app/Views/timesheetViewPage.dart';
import 'package:urbanico_app/enum/futureState.dart';

class TimesheetInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tsEntryProvider = Provider.of<ForemanEntryRepository>(context);
    if (tsEntryProvider.getState == FutureState.Uninitialized) {
      tsEntryProvider.getAllEntriesByForeman(resync: true);
    } else if (tsEntryProvider.getState == FutureState.Loaded) {
      return (tsEntryProvider.listCurrentEntry.date.isNotEmpty)
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Text("Date : ${tsEntryProvider.listCurrentEntry.date}"),
                  ),
                  Container(
                    child: Text("Status : ${tsEntryProvider.listCurrentEntry.status}"),
                  ),
                  SizedBox(
                      height: 50,
                      child: MaterialButton(
                        color: AppConfig().primaryColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Icon(
                              Icons.remove_red_eye,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "View Timesheet",
                            )
                          ],
                        ),
                        onPressed: () async {
                          // tsViewProvider.getLatestEntryByDate();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TimesheetView()));
                        },
                      ))
                ],
              ),
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Text("Date : ${tsEntryProvider.currentTimesheetDate}"),
                  ),
                  Container(
                    child: const Text("Status : No Timesheet Available"),
                  ),
                  (AppConfig().appEnvironment != AppEnvironment.PROD && AppConfig().appEnvironment != AppEnvironment.DEV)
                      ? SizedBox(
                          height: 50,
                          child: MaterialButton(
                            color: Colors.blueAccent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Create Timesheet",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            onPressed: () {
                              print("Viola");
                            },
                          ))
                      : const Text("")
                ],
              ),
            );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[CircularProgressIndicator(), Text("Loading entry list")],
      ),
    );
  }
}
