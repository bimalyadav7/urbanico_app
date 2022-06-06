
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';

class CrewCard extends StatelessWidget {
  final Crew crew;
  const CrewCard(this.crew);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);
    return Stack(children: [
      Positioned(
        top: 1,
        right: 3,
        child: Container(
            child: GestureDetector(
          child: const Icon(
            Icons.cancel,
            color: Colors.redAccent,
            size: 22,
          ),
          onTap: () {
            timesheet.listWorkHours
                .removeWhere((workhour) => workhour.crew.id == crew.id);
            timesheet.removeCrews = crew;
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
              crew.crew.contact,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Divider(
              height: 3.8,
              endIndent: 28,
              color: Colors.deepPurple,
            ),
            Text(
              crew.crew.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )),
    ]);
  }
}