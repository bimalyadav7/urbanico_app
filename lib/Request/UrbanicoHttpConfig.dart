import 'package:http/http.dart';
import 'package:urbanico_app/appConfig.dart';

abstract class UrbanicoHttpConfig {
  final serviceurl = AppConfig().baseUrl;
  final Map<String, String> requestheaderType = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "Bearer " + AppConfig().token.toString(),
    "APICaller": AppConfig().platform.toString(),
    "BuildDate": AppConfig().buildDate.toString(),
    "BuildVersion": AppConfig().buildVersion.toString(),
  };
  Map<String, String> get headerType => requestheaderType;

  Future<Response> mock403() async {
    await Future.delayed(const Duration(seconds: 3));
    return Response("", 403);
  }
}
