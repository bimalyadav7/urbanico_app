import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class CostCodeApi extends UrbanicoHttpConfig {
  Future fetchAllCostCodes() async {
    return await http.get(Uri.parse(serviceurl + "index.php?method=project_cost_code"), headers: headerType);
  }

  Future fetchCostCodesByProjectID(String projectid) async {
    return await http.get(Uri.parse(serviceurl + "index.php?method=project_cost_code&proID=$projectid"), headers: headerType);
  }
}
