import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class NextButton extends StatelessWidget {
  final TabController tabController;

  const NextButton(this.tabController);

  Future showNotificationDialog(context, message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).translate("understood")))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialButton(
      color: Colors.lightBlue,
      textColor: Colors.white,
      child: Text(AppLocalizations.of(context).translate("next")),
      onPressed: () {
        if (Provider.of<TimeSheet>(context, listen: false).listProjects.isEmpty) {
          // showNotificationDialog(
          //     context,
          //     AppLocalizations.of(context)
          //         .translate("costcodeorquantitynotadded"));
          // Navigation to equipment tab now possible for no project or date
          tabController.animateTo((tabController.index + 1) % tabController.length);
        } else if (Provider.of<TimeSheet>(context, listen: false).date == null) {
          showNotificationDialog(context, AppLocalizations.of(context).translate("selectadate"));
        } else {
          tabController.animateTo((tabController.index + 1) % tabController.length);
        }
      },
    ));
  }
}
