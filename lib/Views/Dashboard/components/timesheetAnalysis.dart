import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Request/Analysis/timesheet_analysis_api.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/authStatus.dart';
import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/userModel.dart';

final serviceurl = AppConfig().baseUrl;
Map<String, String> headerType = {
  "Content-Type": "application/x-www-form-urlencoded",
  "Authorization": "Bearer " + AppConfig().token.toString(),
  "APICaller": AppConfig().platform.toString(),
};
const Color headingColor1 = Color(0xffffd27f);
const Color headingColor2 = Color(0xffffb732);

class ForemanProject {
  late String projectID;
  late String projectCode;
  late String projectName;
  late String enteredBy;
  late String projectStatus;

  ForemanProject() {
    projectID = '';
    projectCode = '';
    projectName = '';
    enteredBy = '';
    projectStatus = '';
  }

  ForemanProject.fromJson(Map<String, dynamic> json) {
    projectID = json['projectID'];
    projectCode = json['projectCode'];
    projectName = json['projectName'];
    projectStatus = json['projectStatus'];
    enteredBy = json['entered_by'];
  }
}

class JobAnalysis {
  late String projectsetupID;
  late String date;
  late String abbreviation;
  late String projectCode;
  late String projectName;
  late String costcodeName;
  late String costcodeDesc;
  late String budgetedManHour;
  late String budgetedQty;
  late String qtyComplete;
  late String workhour;

  // JobAnalysis(
  //     {this.projectsetupID,
  //     this.date,
  //     this.abbreviation,
  //     this.projectCode,
  //     this.projectName,
  //     this.costcodeName,
  //     this.costcodeDesc,
  //     this.budgetedManHour,
  //     this.budgetedQty,
  //     this.qtyComplete,
  //     this.workhour});

  JobAnalysis.fromJson(Map<String, dynamic> json) {
    projectsetupID = json['projectsetupID'];
    date = json['date'];
    abbreviation = json['abbreviation'];
    projectCode = json['projectCode'];
    projectName = json['projectName'];
    costcodeName = json['costcodeName'];
    costcodeDesc = json['costcodeDesc'];
    budgetedManHour = json['budgeted_man_hour'];
    budgetedQty = json['budgeted_qty'];
    qtyComplete = json['qty_complete'];
    workhour = json['workhour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['projectsetupID'] = projectsetupID;
    data['date'] = date;
    data['abbreviation'] = abbreviation;
    data['projectCode'] = projectCode;
    data['projectName'] = projectName;
    data['costcodeName'] = costcodeName;
    data['costcodeDesc'] = costcodeDesc;
    data['budgeted_man_hour'] = budgetedManHour;
    data['budgeted_qty'] = budgetedQty;
    data['qty_complete'] = qtyComplete;
    data['workhour'] = workhour;
    return data;
  }
}

class ForemanProjectProvider extends ChangeNotifier {
  FutureState _state = FutureState.Uninitialized;
  List<ForemanProject> _projects = [];
  late String _selectedProjectID;
  String _message = "";
  late User _authUser;
  TextEditingController _selectedDate = TextEditingController();
  late UserRepository userRepo;
  FutureState get state => _state;
  List<ForemanProject> get foremanProjects => _projects;
  String get selectedProjectID => _selectedProjectID;
  TextEditingController get selectedDate => _selectedDate;
  String get message => _message;
  User get authUser => _authUser;

  ForemanProjectProvider(this.userRepo, previousID, previousDate) {
    _state = FutureState.Uninitialized;
    _selectedProjectID = previousID ?? "";
    _selectedDate = previousDate;
    _authUser = userRepo.authUser;
    getForemanProjects(_authUser.userID);
  }

  set futureState(FutureState state) {
    _state = state;
    notifyListeners();
  }

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  set setProjects(ForemanProject project) {
    _projects.add(project);
    notifyListeners();
  }

  set setSelectedProjectID(String projectid) {
    _selectedProjectID = projectid;
    notifyListeners();
  }

  set setSelectedDate(String date) {
    _selectedDate.text = date;
    notifyListeners();
  }

  Future<void> getForemanProjects(String userID) async {
    _projects = [];
    futureState = FutureState.Loading;
    try {
      Response response = await TimesheetAnalysisApi().fetchProjectsByForeman(userID);
      if (response.statusCode == 401 || response.statusCode == 403) {
        futureState = FutureState.Unauthenticated;
        userRepo.setStatus = Status.Unauthenticated;
      } else if (response.statusCode == 200) {
        var responseBody = jsonDecode(const Utf8Decoder().convert(response.body.codeUnits));
        for (int i = 0; i < responseBody["response"].length; i++) {
          ForemanProject temp = ForemanProject.fromJson(responseBody["response"][i]);
          _projects.add(temp);
        }
        futureState = FutureState.Loaded;
      }
    } catch (err) {
      futureState = FutureState.Uninitialized;
      rethrow;
    }
  }
}

class TimesheetAnalysisProvider extends BaseNotifierRepo {
  List<JobAnalysis> _jobList = [];
  String _message = "";

  TimesheetAnalysisProvider(userRepo) : super(userRepo) {
    _jobList = [];
    _message = "";
  }

  List<JobAnalysis> get foremanJobs => _jobList;
  get message => _message;

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  set setJobs(JobAnalysis jobs) {
    _jobList.add(jobs);
    notifyListeners();
  }

  Future<void> getTillDate(String projectID) async {
    _jobList = [];
    try {
      Response response = await TimesheetAnalysisApi().fetchJobsByProjectID(projectID);
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        setState = FutureState.Loading;
        var responseBody = jsonDecode(const Utf8Decoder().convert(response.body.codeUnits));
        for (int i = 0; i < responseBody["response"].length; i++) {
          JobAnalysis temp = JobAnalysis.fromJson(responseBody["response"][i]);
          _jobList.add(temp);
        }
        setState = FutureState.Loaded;
      }
    } catch (err) {
      setState = FutureState.Loaded;
      rethrow;
    }
  }

  Future<void> getByDate(String projectID, String date, enteredby) async {
    _jobList = [];

    try {
      Response response = await TimesheetAnalysisApi().fetchJobsByProjectIDAndDate(date, projectID, enteredby);
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        setState = FutureState.Loading;
        var responseBody = jsonDecode(const Utf8Decoder().convert(response.body.codeUnits));
        for (int i = 0; i < responseBody["response"].length; i++) {
          JobAnalysis temp = JobAnalysis.fromJson(responseBody["response"][i]);
          _jobList.add(temp);
        }
        setState = FutureState.Loaded;
      }
    } catch (err) {
      setState = FutureState.Loaded;
      rethrow;
    }
  }
}

class TimesheetAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<UserRepository, ForemanProjectProvider>(
            create: (context) => ForemanProjectProvider(Provider.of<UserRepository>(context, listen: false), null, TextEditingController()),
            update: (context, authUser, previous) => ForemanProjectProvider(authUser, previous!.selectedProjectID, previous.selectedDate),
          ),
          ChangeNotifierProxyProvider<UserRepository, TimesheetAnalysisProvider>(
            create: (context) => TimesheetAnalysisProvider(Provider.of<UserRepository>(context, listen: false)),
            update: (context, authUser, previous) => TimesheetAnalysisProvider(authUser),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => TimesheetAnalysisProvider(),
          // )
        ],
        child: Container(
          margin: const EdgeInsets.all(8),
          child: TimesheetAnalysis(),
        ));
  }
}

class UrbanTableCell extends StatelessWidget {
  final String label;
  final double leftPadding;

  const UrbanTableCell({required this.label, this.leftPadding = 2});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(right: 1, left: 0, top: 0, bottom: 1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: leftPadding, top: 8, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ));
  }
}

class UrbanTableHeading extends StatelessWidget {
  final String label;

  const UrbanTableHeading(this.label);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        color: AppConfig().primaryColor,
        child: Container(
          alignment: Alignment.center,
          height: 48,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ));
  }
}

class TimesheetAnalysis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var analysis = Provider.of<TimesheetAnalysisProvider>(context, listen: false);
    var foremanproject = Provider.of<ForemanProjectProvider>(context);
    if (foremanproject.state != FutureState.Loaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton(
                      hint: (foremanproject.message == "noproject")
                          ? const Text(
                              "Select a project first.",
                              style: TextStyle(color: Colors.redAccent),
                            )
                          : const Text("Click here to select project"),
                      value: foremanproject.selectedProjectID,
                      items: foremanproject.foremanProjects
                          .map((project) => DropdownMenuItem(
                                child: Text(
                                  "${project.projectCode} - ${project.projectName}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                value: (project.projectID == null) ? "" : project.projectID,
                              ))
                          .toList(),
                      onChanged: (value) async {
                        foremanproject._message = "";
                        foremanproject.setSelectedProjectID = value.toString();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              MaterialButton(
                  onPressed: () async {
                    if (foremanproject.selectedProjectID == "") {
                      // _datecontroller.v
                      foremanproject.setMessage = "noproject";
                      return;
                    }
                    await analysis.getTillDate(foremanproject.selectedProjectID);
                    foremanproject.setMessage = "";
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  color: AppConfig().primaryColor,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Text(
                      "Get till Date",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )),
              const VerticalDivider(
                color: Colors.black,
                width: 50,
                thickness: 2,
              ),
              Flexible(
                child: TextFormField(
                  readOnly: true,
                  enableInteractiveSelection: true,
                  controller: foremanproject.selectedDate,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      labelText: "Click to Select a Date",
                      prefixIcon: const Icon(Icons.date_range),
                      errorStyle: const TextStyle(color: Colors.redAccent),
                      errorText: (foremanproject.message == "noprojectfordate")
                          ? "Select project first."
                          : (foremanproject.message == "nodateforproject")
                              ? "Select a date first."
                              : null,
                      errorBorder:
                          OutlineInputBorder(borderSide: const BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.circular(4)),
                      border:
                          OutlineInputBorder(borderSide: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(4))),
                  onTap: () async {
                    if (foremanproject.selectedProjectID == "") {
                      // _datecontroller.v
                      foremanproject.setMessage = "noprojectfordate";
                      return;
                    }
                    // DateTime currentDate = DateTime.now();
                    DateTime? pickedDate = await showDatePicker(
                        context: context, firstDate: DateTime(1900), initialDate: DateTime.now(), lastDate: DateTime(2100));

                    foremanproject._message = "";
                    if (pickedDate != null) {
                      foremanproject.setSelectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              MaterialButton(
                  onPressed: () async {
                    if (foremanproject.selectedProjectID == "") {
                      // _datecontroller.v
                      foremanproject.setMessage = "noprojectfordate";
                      return;
                    }
                    if (foremanproject.selectedDate.text == "") {
                      foremanproject.setMessage = "nodateforproject";
                      return;
                    }
                    await analysis.getByDate(
                        foremanproject.selectedProjectID, foremanproject.selectedDate.text, foremanproject.authUser.userID);
                    foremanproject.setMessage = "";
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  color: AppConfig().primaryColor,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Text(
                      "Get by Date",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
          const Divider(
            height: 12,
            thickness: 1,
            color: Colors.black54,
          ),
          AnalysisTableHeadingMain(),
          Flexible(child: AnalysisTableBody()),
        ],
      ),
    );
  }
}

// class DateSelector extends StatelessWidget {
//   final formatter = DateFormat("yyyy MMMM d EEEE");
//   final bool disabled;
//   DateSelector({this.disabled = false});

//   @override
//   Widget build(BuildContext context) {
//     var timesheetData = Provider.of<TimeSheet>(context);
//     var currentDate = timesheetData.date ?? null;
//     var formattedDate = [];
//     if (currentDate != null)
//       formattedDate = formatter.format(currentDate).split(" ");
//     return TextButton(
//       child: (currentDate != null)
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Container(
//                     alignment: Alignment.topCenter,
//                     padding: EdgeInsets.symmetric(vertical: 2),
//                     child: Icon(Icons.calendar_today)),
//                 Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                   child: Text(
//                     formattedDate[0],
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.center,
//                   child: Text(
//                     "${formattedDate[1]}, ${formattedDate[2]}",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.bottomCenter,
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                   child: Text(
//                     formattedDate[3],
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             )
//           : Container(
//               child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Icon(
//                   Icons.calendar_today,
//                   size: 36,
//                 ),
//                 Text(
//                   "Enter Timesheet Date Here",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             )),
//       onPressed: () async {

//       },
//     );
//   }
// }

class AnalysisTableHeadingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).d
    return Column(
      children: [
        Row(
          children: const [
            Expanded(flex: 3, child: UrbanTableHeading("")),
            Expanded(flex: 1, child: UrbanTableHeading("")),
            Expanded(flex: 3, child: UrbanTableHeading("Budgeted")),
            Expanded(flex: 3, child: UrbanTableHeading("Actual")),
            Expanded(flex: 1, child: UrbanTableHeading("")),
            Expanded(flex: 1, child: UrbanTableHeading("")),
            Expanded(flex: 1, child: UrbanTableHeading("")),
          ],
        ),
        Row(
          children: const [
            Expanded(flex: 3, child: UrbanTableHeading("CostCode")),
            Expanded(flex: 1, child: UrbanTableHeading("Unit")),
            Expanded(flex: 1, child: UrbanTableHeading("QTY")),
            Expanded(flex: 1, child: UrbanTableHeading("ManHour")),
            Expanded(flex: 1, child: UrbanTableHeading("MH/QTY")),
            Expanded(flex: 1, child: UrbanTableHeading("QTY")),
            Expanded(flex: 1, child: UrbanTableHeading("ManHour")),
            Expanded(flex: 1, child: UrbanTableHeading("MH/QTY")),
            Expanded(flex: 1, child: UrbanTableHeading("ManHour Expected")),
            Expanded(flex: 1, child: UrbanTableHeading("Variance")),
            Expanded(flex: 1, child: UrbanTableHeading("% Comp")),
          ],
        ),
      ],
    );
  }
}

class AnalysisTableBody extends StatelessWidget {
  List<IntrinsicHeight> makeRow(analysis) {
    List<IntrinsicHeight> jobs = [];
    for (int i = 0; i < analysis.foremanJobs.length; i++) {
      double budgetedManHour = double.parse(analysis.foremanJobs[i].budgetedManHour);
      double budgetedQty = double.parse(analysis.foremanJobs[i].budgetedQty);
      double qtyComplete = double.parse(analysis.foremanJobs[i].qtyComplete);
      double workhour = double.parse(analysis.foremanJobs[i].workhour);
      double expectedManHour = (qtyComplete * (budgetedManHour / budgetedQty));
      double variance = expectedManHour - workhour;
      double percentageComplete = (qtyComplete * 100.0) / budgetedQty;
      jobs.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 3,
                  child: UrbanTableCell(
                    label: "${analysis.foremanJobs[i].costcodeName} / ${analysis.foremanJobs[i].costcodeDesc}",
                    leftPadding: 6,
                  )),
              Expanded(flex: 1, child: UrbanTableCell(label: "${analysis.foremanJobs[i].abbreviation}")),
              Expanded(flex: 1, child: UrbanTableCell(label: "${analysis.foremanJobs[i].budgetedQty}")),
              Expanded(flex: 1, child: UrbanTableCell(label: "${analysis.foremanJobs[i].budgetedManHour}")),
              Expanded(flex: 1, child: UrbanTableCell(label: (budgetedManHour / budgetedQty).toStringAsFixed(3))),
              Expanded(flex: 1, child: UrbanTableCell(label: "${analysis.foremanJobs[i].qtyComplete}")),
              Expanded(flex: 1, child: UrbanTableCell(label: "${analysis.foremanJobs[i].workhour}")),
              Expanded(flex: 1, child: UrbanTableCell(label: (workhour / qtyComplete).toStringAsFixed(3))),
              Expanded(flex: 1, child: UrbanTableCell(label: expectedManHour.toStringAsFixed(3))),
              Expanded(flex: 1, child: UrbanTableCell(label: variance.toStringAsFixed(3))),
              Expanded(flex: 1, child: UrbanTableCell(label: percentageComplete.toStringAsFixed(3))),
            ],
          ),
        ),
      );
    }
    return jobs;
  }

  @override
  Widget build(BuildContext context) {
    var analysis = Provider.of<TimesheetAnalysisProvider>(context);

    if (analysis.getState == FutureState.Loaded) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: makeRow(analysis)));
    } else if (analysis.getState == FutureState.Uninitialized) {
      return Container();
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
