import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanico_app/Repository/UserRepository.dart';
import 'package:urbanico_app/ViewModels/SideMenuModel.dart';
import 'package:urbanico_app/appConfig.dart';
import 'package:urbanico_app/Providers/SettingsProvider/LangSettingsProvider.dart';
import 'package:urbanico_app/tools/appLocalization.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  late int _currentTab;
  final List<SideMenuItem> _sideMenuItems = SideMenu.menuitems;
  late SharedPreferences pref;
  late AnimationController _animationController;
  late Animation _animation;
  bool _isCollapsed = false;
  late Stream<String> refreshToken;

  static Color tabListColor = Colors.black;

  tabListText(txt) {
    return Text(
      txt,
      style: TextStyle(color: tabListColor, fontWeight: FontWeight.bold),
    );
  }

  @override
  void initState() {
    _currentTab = 0;
    _animationController = AnimationController(duration: const Duration(milliseconds: 180), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isCollapsed = false;
        });
      }
    });
    _animation = Tween(begin: 16.0, end: 5).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animation.addListener(() => setState(() {}));
    super.initState();
  }

  Container createSideMenuItems(int index) {
    return Container(
        color: (_currentTab == index) ? AppConfig().primaryColor.withOpacity(0.45) : Colors.white,
        child: TextButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
            child: Row(
              children: <Widget>[
                Icon(
                  _sideMenuItems[index].icon,
                  color: tabListColor,
                ),
                (_isCollapsed)
                    ? const SizedBox(
                        width: 0,
                      )
                    : const SizedBox(
                        width: 12,
                      ),
                tabListText((_isCollapsed) ? "" : AppLocalizations.of(context).translate(_sideMenuItems[index].name)),
              ],
            ),
          ),
          onPressed: () {
            setState(() {
              _currentTab = index;
            });
          },
        ));
  }

  SizedBox _sizedBox() {
    if (_isCollapsed) {
      return const SizedBox(
        width: 0,
      );
    }
    return const SizedBox(
      width: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    var langProvider = Provider.of<LangSettingsProvider>(context, listen: false);
    AppConfig().setAppDimensions(appWidth: MediaQuery.of(context).size.width / 100, appHeight: MediaQuery.of(context).size.height / 100);

    return SafeArea(
        child: Container(
            child: SizedBox(
      width: AppConfig().appWidth * 100,
      height: AppConfig().appHeight * 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: AppConfig().appWidth * _animation.value,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6.0, // has the effect of softening the shadow
                    spreadRadius: 2.0, // has the effect of extending the shadow
                    offset: Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  color: AppConfig().primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  child: TextButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          Icons.menu,
                          color: tabListColor,
                        ),
                        _sizedBox(),
                        Flexible(
                          child: tabListText(
                            (_isCollapsed) ? "" : Provider.of<UserRepository>(context, listen: false).authUser.name,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      if (_animationController.value == 0.0) {
                        _isCollapsed = true;
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },
                  ),
                ),
                Column(
                  children: List.generate(_sideMenuItems.length, (index) => createSideMenuItems(index)),
                ),
                Container(
                    color: (_currentTab == 4) ? AppConfig().primaryColor.withOpacity(0.45) : Colors.white,
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: tabListColor,
                            ),
                            _sizedBox(),
                            tabListText((_isCollapsed) ? "" : AppLocalizations.of(context).translate('logout')),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Provider.of<UserRepository>(context, listen: false).logout();
                      },
                    )),
                const Expanded(child: Text("")),
                (!_isCollapsed) ? Text(AppLocalizations.of(context).translate("changelanguage")) : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: MaterialButton(
                    color: AppConfig().primaryColor,
                    child: Row(
                      children: <Widget>[
                        (_isCollapsed)
                            ? const Icon(
                                Icons.language,
                              )
                            : Container(),
                        Text(
                          (_isCollapsed)
                              ? ""
                              : (langProvider.appLocal == const Locale('en'))
                                  ? AppLocalizations.of(context).translate("switchtospanish")
                                  : AppLocalizations.of(context).translate("switchtoenglish"),
                        ),
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
                ),
                const SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
          Container(
            width: 8,
          ),
          SizedBox(
            width: AppConfig().appWidth * (99 - _animation.value),
            child: _sideMenuItems[_currentTab].widget,
          )
        ],
      ),
    )));
  }
}

class LoginExpired extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConfig().appWidth * 100,
      height: AppConfig().appHeight * 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).translate("loginexpired"),
              style: const TextStyle(fontSize: 34),
            ),
            MaterialButton(
                color: AppConfig().primaryColor,
                onPressed: () {
                  Provider.of<UserRepository>(context, listen: false).preservedlogout();
                },
                child: Text(AppLocalizations.of(context).translate("loginagain")))
          ],
        ),
      ),
    );
  }
}
