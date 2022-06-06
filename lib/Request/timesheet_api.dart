import 'dart:convert';

import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class TimeSheetApi extends UrbanicoHttpConfig {
  Future checkDateFilled(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "index.php?method=check_timesheet_entry&userID=$userid&entrydate=$date"), headers: headerType);
  }

  Future getRowColumnCount(String userid) {
    return http.get(Uri.parse(serviceurl + "index.php?method=row_column_count&userID=$userid"), headers: headerType);
  }

  Future getRowColumnCountForDate(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "index.php?method=row_column_count_fordate&userID=$userid&date=$date"), headers: headerType);
  }

  Future getWorkersByDate(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "index.php?method=get_workers_for&date=$date&entered_by=$userid"), headers: headerType);
  }

  Future getWorkHoursByDate(String userid, String date) {
    return http.post(Uri.parse(serviceurl + "index.php?method=get_workhourby_dateanduser&date=$date&entered_by=$userid"),
        headers: headerType);
  }

  Future getResourceByDate(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "timesheetindex.php?method=get_all_resources_bydate&entered_by=$userid&fordate=$date"),
        headers: headerType);
  }

  Future getEquipmentByDate(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "timesheetindex.php?method=get_all_equipments_bydate&entered_by=$userid&fordate=$date"),
        headers: headerType);
  }

  Future getAbsentByDate(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "timesheetindex.php?method=get_all_absent_bydate&entered_by=$userid&fordate=$date"),
        headers: headerType);
  }

  Future getTruckByDate(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "timesheetindex.php?method=get_all_trucks_bydate&entered_by=$userid&fordate=$date"),
        headers: headerType);
  }

  Future getPictureByDate(String userid, String date) {
    return http.post(Uri.parse(serviceurl + "index.php?method=get_pictures"), body: {"userID": userid, "date": date}, headers: headerType);
  }

  Future getForemanCrewList(String userid) {
    return http.get(Uri.parse(serviceurl + "index.php?method=template_crew&foremanid=$userid"), headers: headerType);
  }

  Future postDailyEntry(
      dataArrayTimesheet, dataArrayResource, dataArrayEquipment, dataArrayDailyReport, dataArrayAbsentEmployee, dataArrayPicture) {
    var encodedValueRaw = {
      "timesheetData": dataArrayTimesheet,
      "resourceData": dataArrayResource,
      "equipmentData": dataArrayEquipment,
      "dailyreportData": dataArrayDailyReport,
      "absentEmployeeData": dataArrayAbsentEmployee,
      "pictureData": dataArrayPicture,
    };

    var encodedValue = jsonEncode(encodedValueRaw);
    return http.post(Uri.parse(serviceurl + "index.php?method=daily_timesheet_entry"), headers: headerType, body: encodedValue);
  }

  Future getDailyReport(String userid, String date) {
    return http.get(Uri.parse(serviceurl + "index.php?method=fill_daily_report&userID=$userid&datefortimesheetuser=$date"),
        headers: headerType);
  }

  // Future postResourceEntry(dataArray) {
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String encodedValue = jsonEncode(dataArray);
  //   return http.post(
  //       serviceurl + "index.php?method=daily_timesheet_resource_entry",
  //       headers: headers,
  //       body: encodedValue);
  // }

  Future getForemanTimesheetEntry(String userid) {
    return http.get(Uri.parse(serviceurl + "index.php?method=get_entries_foreman&enteredby=$userid&sort=name&order=desc&offset=0&limit=10"),
        headers: headerType);
  }
}
