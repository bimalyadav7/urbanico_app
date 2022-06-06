import 'package:flutter/material.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/appConfig.dart';

class CostCodeCard extends StatelessWidget {
  final TimeSheetProject tsproject;
  const CostCodeCard(this.tsproject);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConfig().primaryColor.withOpacity(.5),
      width: 200,
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      constraints: const BoxConstraints(minHeight: 48),
      child: Container(
        child: (tsproject.costCode.costcodeName != "")
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tsproject.costCode.costcodeName.trim(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    tsproject.costCode.costcodeDesc.trim(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(tsproject.costCode.unit.trim())
                ],
              )
            : const Align(
                alignment: Alignment.center,
                child: Text('Select CostCode'),
              ),
      ),
    );
  }
}
