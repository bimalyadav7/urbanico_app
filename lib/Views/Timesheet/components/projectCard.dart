import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';

class ProjectCard extends StatelessWidget {
  final TimeSheetProject tsproject;
  const ProjectCard(this.tsproject);

  @override
  Widget build(BuildContext context) {
    var timesheet = Provider.of<TimeSheet>(context);
    return SizedBox(
      width: 158,
      child: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: Container(
              child: GestureDetector(
            child: const Icon(Icons.cancel, color: Colors.redAccent, size: 23),
            onTap: () {
              timesheet.listWorkHours.removeWhere(
                  (workhour) => workhour.tsproject.id == tsproject.id);

              timesheet.removeProjects = tsproject;
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
                tsproject.project.projectCode,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
              Text(tsproject.project.projectName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
              Text('${tsproject.phase.phasecode}-${tsproject.phase.phasedesc}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        )),
      ]),
    );
  }
}
