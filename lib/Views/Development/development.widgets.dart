import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Providers/SettingsProvider/LangSettingsProvider.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class DevelopmentWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
          child: const Text("Settings page"),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiProvider(providers: [
                          ChangeNotifierProvider.value(
                              value: LangSettingsProvider())
                        ], child: DevelopmentSettingsPage())),
              )),
    );
  }
}

class DevelopmentSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<LangSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig().primaryColor,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            AppLocalizations.of(context).translate("settings"),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black),
          ),
        ),
      ),
      body: Card(
        margin: const EdgeInsets.fromLTRB(42, 8, 42, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(FontAwesomeIcons.language),
                title: Text(
                    AppLocalizations.of(context).translate("changelanguage")),
                subtitle: (appLang.appLocal == const Locale("en"))
                    ? const Text("English")
                    : const Text("Español"),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LanguageListDialog();
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLang = Provider.of<LangSettingsProvider>(context, listen: false);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  AppLocalizations.of(context).translate("selectalanguage"),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
              Container(
                  height: 460,
                  width: 420,
                  margin: const EdgeInsets.all(12),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView(
                      children: [
                        Card(
                          child: ListTile(
                            title: const Text("English"),
                            onTap: () {
                              appLang.changeLanguage(const Locale("en"));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: const Text("Spanish (Español)"),
                            onTap: () {
                              appLang.changeLanguage(const Locale("es"));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
