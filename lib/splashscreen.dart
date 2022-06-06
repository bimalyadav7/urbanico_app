import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/Views/userPage.dart';
import 'package:urbanico_app/Views/login.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/enum/appEnvironment.dart';
import 'package:urbanico_app/enum/authStatus.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class UpgraderCustomMessage extends UpgraderMessages {
  AppLocalizations locale;

  UpgraderCustomMessage(this.locale);

  @override
  String get buttonTitleUpdate => locale.translate("updateapp");
  @override
  String get buttonTitleIgnore => locale.translate("updateapp");
  @override
  String get body => locale.translate('updateappmessage', args: ["{{appName}}"]);
  @override
  String get prompt => locale.translate('updateappprompt');
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget screen = const SplashScreenMobile();
    if (kIsWeb || AppConfig().appEnvironment == AppEnvironment.DEMO) {
      screen = const SplashScreenWeb();
    }
    return Scaffold(body: screen);
  }
}

class SplashScreenWeb extends StatelessWidget {
  const SplashScreenWeb({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(builder: (_, userState, widget) {
      if (userState.status == Status.Authenticating) {
        return const LoginPage(isLoadingPage: true);
      } else if (userState.status == Status.Authenticated) {
        return UserPage();
      }
      return const LoginPage();
    });
  }
}

class SplashScreenMobile extends StatelessWidget {
  const SplashScreenMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      canDismissDialog: false,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: false,
      messages: UpgraderCustomMessage(AppLocalizations.of(context)),
      child: Consumer<UserRepository>(builder: (_, userState, widget) {
        if (userState.status == Status.Authenticating) {
          return const LoginPage(isLoadingPage: true);
        } else if (userState.status == Status.Authenticated) {
          return UserPage();
        }
        return const LoginPage();
      }),
    );
  }
}
