import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class AuthApi extends UrbanicoHttpConfig {
  Future checkValidToken() {
    final response = http.get(Uri.parse(serviceurl + "v2/validateTokenExpiry"), headers: headerType);
    return response;
  }

  Future refreshToken() {
    final response = http.get(Uri.parse(serviceurl + "v2/refreshToken"), headers: headerType);
    return response;
  }

  Future fetchProjectPhases(String projectID) {
    final response = http.get(Uri.parse(serviceurl + "index.php?method=get_project_phases&proID=$projectID"), headers: headerType);
    return response;
  }

  Future fetchAllPlans(String startdate, String enddate, String userid) {
    final response = http.post(Uri.parse(serviceurl + "v2/plan/bydate"), headers: headerType, body: {
      "startDate": startdate,
      "endDate": enddate,
      "user_id": userid,
      "user_type": "foreman",
    }).timeout(const Duration(seconds: 30));
    return response;
  }
}
