import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class TimesheetAnalysisApi extends UrbanicoHttpConfig {
  Future fetchProjectsByForeman(String enteredby) async {
    return await http.get(Uri.parse(serviceurl + "index.php?method=project_per_superin&enteredby=$enteredby"), headers: headerType);
  }

  Future fetchJobsByProjectID(String projectid) async {
    return await http.get(Uri.parse(serviceurl + "index.php?method=daily_entry_all&projectID=$projectid"), headers: headerType);
  }

  Future fetchJobsByProjectIDAndDate(String date, String projectid, String enteredby) async {
    return await http.get(
        Uri.parse(serviceurl + "index.php?method=recent_entry_all&recentDate=$date&projectID=$projectid&enteredby=$enteredby"),
        headers: headerType);
  }
}
