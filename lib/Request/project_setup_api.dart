import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class ProjectSetupApi extends UrbanicoHttpConfig {
  Future fetchCostCodeResource(String projectid, String costcodeid) async {
    return await http.get(
        Uri.parse(serviceurl + "index.php?method=projectsetup_for_material_entry&projectid=$projectid&costcodeid=$costcodeid"),
        headers: headerType);
  }
}
