import 'package:urbanico_app/Request/UrbanicoHttpConfig.dart';
import 'package:http/http.dart' as http;

class PODApi extends UrbanicoHttpConfig {
  Future fetchPODByDate(String foremanid, String date) async {
    var resp = await http.post(Uri.parse(serviceurl + "podindex.php?method=pod_foreman_bydate"),
        headers: headerType, body: {"foremanid": foremanid, "fordate": date});
    return resp;
  }
}
