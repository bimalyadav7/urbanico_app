import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class ProjectApi extends UrbanicoHttpConfig {
  Future fetchAllProjects() async {
    return await http.get(Uri.parse(serviceurl + "index.php?method=projectsetup_for_timesheet_entry"), headers: headerType);
  }

  Future fetchProjectPhases(String projectID) async {
    return await http.get(Uri.parse(serviceurl + "index.php?method=get_project_phases&proID=$projectID"), headers: headerType);
  }
}
