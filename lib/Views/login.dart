import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanico_app/Providers/SettingsProvider/LangSettingsProvider.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/appEnvironment.dart';
import 'package:urbanico_app/enum/authStatus.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class LoginPage extends StatefulWidget {
  final bool isLoadingPage;

  const LoginPage({this.isLoadingPage = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String previousEmail = "";
  bool isPageLoading = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initLoad();
  }

  initLoad() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    previousEmail = preferences.getString("previous_logger") ?? "";
    if (previousEmail.isNotEmpty) {
      usernameController.text = previousEmail;
    }
    setState(() {
      isPageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPageLoading) {
      return Container(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[CircularProgressIndicator()],
        ),
      ));
    }
    var langProvider = Provider.of<LangSettingsProvider>(context, listen: false);
    // var auth = Provider.of<UserRepository>(context, listen: false);
    var screenWidth = MediaQuery.of(context).size.width / 100;
    var appBuild = AppConfig().appName.toString();
    var appBuildDate = AppConfig().buildDate.toString();
    var appBuildColor = Colors.white;
    if (AppConfig().appEnvironment == AppEnvironment.DEMO ||
        AppConfig().appEnvironment == AppEnvironment.DEV ||
        AppConfig().appEnvironment == AppEnvironment.TEST) {
      appBuildColor = Colors.greenAccent;
    }
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (AppConfig().appEnvironment != AppEnvironment.PROD)
                        ? Container(
                            child: const Text(
                            "TEST",
                            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                          ))
                        : Container(
                            child: const Text(
                            "Application",
                            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                          )),
                    Container(child: Image.asset('assets/icon/URBAN_512.png')),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  "Build : ",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  appBuild,
                                  style: TextStyle(color: appBuildColor, fontSize: 22, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                "Build Date :",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                appBuildDate,
                                style: TextStyle(color: appBuildColor, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        const VerticalDivider(),
        Expanded(
          flex: 2,
          child: (!widget.isLoadingPage)
              ? Consumer<UserRepository>(builder: (context, auth, _) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 2 * 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        MaterialButton(
                          elevation: 3,
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language),
                              const SizedBox(
                                width: 8,
                              ),
                              (langProvider.appLocal == const Locale('en'))
                                  ? Text(AppLocalizations.of(context).translate("switchtospanish"))
                                  : Text(AppLocalizations.of(context).translate("switchtoenglish"))
                            ],
                          ),
                          onPressed: () {
                            if (langProvider.appLocal == const Locale('en')) {
                              langProvider.changeLanguage(const Locale('es'));
                            } else {
                              langProvider.changeLanguage(const Locale('en'));
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          keyboardType: TextInputType.emailAddress,
                          controller: usernameController,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          obscureText: true,
                          controller: passwordController,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        (auth.status == Status.Authenticating)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppConfig().primaryColor)),
                                child: Text(AppLocalizations.of(context).translate('login')),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  await auth.loginv2(usernameController.text, passwordController.text);
                                }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        (auth.isIncorrectCreds)
                            ? Text(
                                auth.authMessage,
                                style: const TextStyle(color: Colors.redAccent),
                              )
                            : const Text(""),
                      ],
                    ),
                  );
                })
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}
