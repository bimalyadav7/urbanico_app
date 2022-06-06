import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class EquipmentApi extends UrbanicoHttpConfig {
  Future fetchAllEquipment() async {
    return await http.post(Uri.parse(serviceurl + "equipmentindex.php?method=get_equipments"), headers: headerType);
  }

  Future fetchTemplateEquipment(String userid) async {
    return await http.post(Uri.parse(serviceurl + "v2/equipments/template/assigned/foreman"),
        body: {"foremanid": userid}, headers: headerType);
  }
}
