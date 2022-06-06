import 'package:flutter/material.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';

class ProjectCard extends StatelessWidget {
  final TimeSheetProject tsproject;
  const ProjectCard(this.tsproject);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 158,
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
            ],
          ),
        ));
  }
}

class ShowProjectDetail extends StatelessWidget {
  final TimeSheetProject tsproject;
  const ShowProjectDetail(this.tsproject);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Column(
        children: <Widget>[
          Text(tsproject.project.projectName),
          Text(tsproject.project.projectDesc),
          Text(tsproject.costCode.costcodeName),
          Text(tsproject.costCode.costcodeDesc),
          Text(tsproject.quantity.toString()),
        ],
      ),
    );
  }
}
