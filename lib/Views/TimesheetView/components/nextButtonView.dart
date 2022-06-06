import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';

class NextButton extends StatelessWidget {
  final TabController tabController;

  const NextButton(this.tabController);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialButton(
      color: Colors.lightBlue,
      textColor: Colors.white,
      child: const Text("Next"),
      onPressed: () {
        if (Provider.of<TimeSheetViewRepo>(context, listen: false)
                .listProjects.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("CostCode or Quantity To Claim Not Added"),
            duration: Duration(seconds: 3),
          ));
        } else if (Provider.of<TimeSheetViewRepo>(context, listen: false)
                .date ==
            null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please Select A Date"),
            duration: Duration(seconds: 3),
          ));
        } else {
          tabController
              .animateTo((tabController.index + 1) % tabController.length);
        }
      },
    ));
  }
}
