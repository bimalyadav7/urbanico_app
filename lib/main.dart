import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:urbanico_app/Providers/TimesheetValidationProvider.dart';
import 'package:urbanico_app/Repository/DailyReportRepository.dart';
import 'package:urbanico_app/Repository/EquipmentRepository.dart';
import 'package:urbanico_app/Repository/ForemanEntryRepository.dart';
import 'package:urbanico_app/Repository/PODRepository.dart';
import 'package:urbanico_app/Repository/ProjectRepository.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/TimesheetViewProvider/TimesheetViewRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/SplashScreen.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/enum/appEnvironment.dart';
import 'package:urbanico_app/Providers/SettingsProvider/LangSettingsProvider.dart';

import 'package:urbanico_app/tools/appLocalization.dart';

void main() async {
  // await SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.landscapeLeft]);
  String platform = (kIsWeb) ? "web" : "mobile";
  AppConfig().setAppConfig(
      appEnvironment: AppEnvironment.PROD,
      appName: 'Urban Infraconstruction App',
      description: '',
      primaryColor: const Color(0xFFf1c40f),
      secondaryColor: const Color(0xFF0a0d1b),
      baseUrl: 'https://timesheet.urbaniconstruct.com/TimesheetService/',
      buildDate: "2021-12-23",
      buildVersion: "10",
      expiryOffset: 1500,
      tokenValidationTime: 1200,
      platform: platform);
  runApp(ChangeNotifierProvider(create: (_) => UserRepository(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<UserRepository, ProjectRepository>(
            update: (context, auth, previousMessage) => ProjectRepository(auth),
            create: (context) => ProjectRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, MultiUserRepository>(
            update: (context, auth, previousMessage) => MultiUserRepository(auth),
            create: (context) => MultiUserRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, CostCodeRepository>(
            update: (context, auth, previousMessage) => CostCodeRepository(auth),
            create: (context) => CostCodeRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, EquipmentRepository>(
            update: (context, auth, previousMessage) => EquipmentRepository(auth),
            create: (context) => EquipmentRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, TimeSheet>(
            update: (context, auth, previousMessage) => TimeSheet(auth),
            create: (context) => TimeSheet(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, DailyReportRepo>(
            update: (context, auth, previousMessage) => DailyReportRepo(auth),
            create: (context) => DailyReportRepo(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, UIKeypadRepository>(
            update: (context, auth, previousMessage) => UIKeypadRepository(auth),
            create: (context) => UIKeypadRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, PODRepository>(
            update: (context, auth, previousMessage) => PODRepository(auth),
            create: (context) => PODRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, ForemanEntryRepository>(
            update: (context, auth, previousMessage) => ForemanEntryRepository(auth),
            create: (context) => ForemanEntryRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, TimeSheetViewRepo>(
            update: (context, auth, previousMessage) => TimeSheetViewRepo(auth),
            create: (context) => TimeSheetViewRepo(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, SelectProjectRepository>(
            update: (context, auth, previousMessage) => SelectProjectRepository(auth),
            create: (context) => SelectProjectRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProxyProvider<UserRepository, SelectPhaseRepository>(
            update: (context, auth, previousMessage) => SelectPhaseRepository(auth),
            create: (context) => SelectPhaseRepository(Provider.of<UserRepository>(context, listen: false)),
          ),
          ChangeNotifierProvider(
            create: (context) => TimesheetValidationProvider(),
          )
        ],
        child: ChangeNotifierProvider<LangSettingsProvider>(
          create: (_) => LangSettingsProvider(),
          child: Consumer<LangSettingsProvider>(
            builder: (context, lang, _) {
              return MaterialApp(
                // List all of the app's supported locales here
                supportedLocales: const [
                  Locale('en'),
                  Locale('es'),
                ],
                // These delegates make sure that the localization data for the proper language is loaded
                localizationsDelegates: const [
                  // A class which loads the translations from JSON files
                  AppLocalizations.delegate,
                  // Built-in localization of basic text for Material widgets
                  GlobalMaterialLocalizations.delegate,
                  // Built-in localization for text direction LTR/RTL
                  GlobalWidgetsLocalizations.delegate,
                ],
                // Returns a locale which will be used by the app
                localeResolutionCallback: (locale, supportedLocales) {
                  // Check if the current device locale is supported
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  // If the locale of the device is not supported, use the first one
                  // from the list (English, in this case).
                  return supportedLocales.first;
                },
                locale: lang.appLocal,
                title: AppConfig().appName,
                theme: ThemeData(
                  textTheme: const TextTheme(
                    bodyText2: TextStyle(fontSize: 14.0),
                    button: TextStyle(fontSize: 18),
                  ),
                  primarySwatch: Colors.blue,
                ),
                home: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: const SplashScreen(),
                ),
              );
            },
          ),
        ));
  }
}
