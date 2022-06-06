import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/PODRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/futureState.dart';

class PODInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var podProvider = Provider.of<PODRepository>(context);
    if (podProvider.getState == FutureState.Uninitialized) {
      podProvider.getPODByDate();
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[CircularProgressIndicator(), Text("Loading Plans")],
        ),
      );
    } else if (podProvider.getState == FutureState.Loaded) {
      return (podProvider.getPod.isNotEmpty)
          ? ListView.builder(
              itemCount: podProvider.getPod.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Project : ",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${podProvider.getPod[index]["projectCode"].toString()} - ${podProvider.getPod[index]["projectName"].toString()}",
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Assigned by : ",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  podProvider.getPod[index]["superintendent"].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                    borderOnForeground: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(2)), side: BorderSide(color: Colors.black12)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(color: AppConfig().primaryColor),
                                          child: const Text(
                                            "Planned Work",
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(podProvider.getPod[index]["plan"].toString()),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 6,
                                ),
                                (podProvider.getPod[index]["actual"].toString().isNotEmpty)
                                    ? Card(
                                        borderOnForeground: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(2)), side: BorderSide(color: Colors.black12)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(color: AppConfig().primaryColor),
                                              child: const Text(
                                                "Actual Work",
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(podProvider.getPod[index]["actual"].toString()),
                                            )
                                          ],
                                        ))
                                    : const SizedBox(
                                        height: 1,
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
            )
          : const Center(
              child: Text("No plans"),
            );
    }
    return Container();
  }
}
