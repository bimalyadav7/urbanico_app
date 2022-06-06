import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class UserApi extends UrbanicoHttpConfig {
  Future fetchAllUser() {
    return http.get(Uri.parse(serviceurl + "index.php?method=employee_all_select"), headers: headerType);
  }

  Future fetchUserForLogin(String projectid) {
    return http.get(Uri.parse(serviceurl + "index.php?method=project_cost_code&proID=$projectid"), headers: headerType);
  }
}
