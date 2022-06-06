import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanico_app/Repository/TimesheetRepository.dart';
import 'package:urbanico_app/Repository/UIKeypadRepository.dart';
import 'package:urbanico_app/appConfig.dart';

typedef ActionCallBack = void Function(Key key);
typedef KeyCallBack = void Function(Key key);

const Color primaryColor = Colors.black;
const Color keypadColor = Colors.black;

class KeyPad extends StatefulWidget {
  @override
  _KeyPadState createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  late Key _actionKey;
  final Key _sevenKey = const Key('seven');
  final Key _eightKey = const Key('eight');
  final Key _nineKey = const Key('nine');
  final Key _fourKey = const Key('four');
  final Key _fiveKey = const Key('five');
  final Key _sixKey = const Key('six');
  final Key _oneKey = const Key('one');
  final Key _twoKey = const Key('two');
  final Key _threeKey = const Key('three');
  final Key _dotKey = const Key('dot');
  final Key _zeroKey = const Key('zero');
  final Key _clearKey = const Key('clear');
  final Key _allClearKey = const Key('allclear');
  final Key _equalsKey = const Key('equals');
  String warning = "";
  late var height;
  late var width;
  List _currentValues = [];
  late double lastValue;
  late TextEditingController _textEditingController;
  bool savedLastValue = false;

  void onActionTapped(Key actionKey) {
    setState(() {
      _actionKey = actionKey;

      if (_currentValues.isNotEmpty) {
        lastValue = double.parse(convertToString(_currentValues));
      }
    });
  }

  void onKeyTapped(Key key) {
    setState(() {
      warning = "";
    });

    if (savedLastValue == false) {
      _currentValues.clear();

      savedLastValue = true;
    }
    setState(() {
      if (identical(_sevenKey, key)) {
        _currentValues.add('7');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_eightKey, key)) {
        _currentValues.add('8');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_nineKey, key)) {
        _currentValues.add('9');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_fourKey, key)) {
        _currentValues.add('4');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_fiveKey, key)) {
        _currentValues.add('5');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_sixKey, key)) {
        _currentValues.add('6');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_oneKey, key)) {
        _currentValues.add('1');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_twoKey, key)) {
        _currentValues.add('2');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_threeKey, key)) {
        _currentValues.add('3');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_dotKey, key)) {
        if (!_currentValues.contains('.')) {
          _currentValues.add('.');
        }
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_zeroKey, key)) {
        _currentValues.add('0');
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_clearKey, key)) {
        if (_currentValues.isEmpty) {
          _currentValues = ["0"];
        } else {
          _currentValues.removeLast();
        }
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_allClearKey, key)) {
        _currentValues = [];
        lastValue = 0;
        savedLastValue = false;
        _textEditingController.text = convertToString(_currentValues);
      } else if (identical(_equalsKey, key)) {
        double value = 0.0;
        try {
          value = double.parse(convertToString(_currentValues));
        } catch (err) {}

        if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "quantity") {
          Provider.of<UIKeypadRepository>(context, listen: false).updateTimesheetProjectQuantity(value);
          Provider.of<UIKeypadRepository>(context, listen: false).selectedTimesheetProjects.clear();
          _currentValues = [];
          lastValue = 0;
          savedLastValue = false;
          _textEditingController.text = convertToString(_currentValues);
          Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
          Provider.of<TimeSheet>(context, listen: false).refresh();
        } else if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "resource") {
          Provider.of<UIKeypadRepository>(context, listen: false).updateProjectResource(value);
          Provider.of<UIKeypadRepository>(context, listen: false).selectedProjectResources.clear();
          _currentValues = [];
          lastValue = 0;
          savedLastValue = false;
          _textEditingController.text = convertToString(_currentValues);
          Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
          Provider.of<TimeSheet>(context, listen: false).refresh();
        } else if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "workhour") {
          if (value > 14) {
            setState(() {
              warning = "Error! Value Exceeds Maximum Hours";
            });
          } else {
            Provider.of<UIKeypadRepository>(context, listen: false).updateWorkHours(value);
            Provider.of<UIKeypadRepository>(context, listen: false).selectedWorkHours.clear();
            _currentValues = [];
            lastValue = 0;
            savedLastValue = false;
            _textEditingController.text = convertToString(_currentValues);
            Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
            Provider.of<TimeSheet>(context, listen: false).refresh();
          }
        } else if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "truckload") {
          Provider.of<UIKeypadRepository>(context, listen: false).updateTruckLoad(value);
          Provider.of<UIKeypadRepository>(context, listen: false).selectedTruckLoad.clear();
          _currentValues = [];
          lastValue = 0;
          savedLastValue = false;
          _textEditingController.text = convertToString(_currentValues);
          Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
          Provider.of<TimeSheet>(context, listen: false).refresh();
        } else if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "truckhour") {
          Provider.of<UIKeypadRepository>(context, listen: false).updateTruckHour(value);
          Provider.of<UIKeypadRepository>(context, listen: false).selectedTruckHour.clear();
          _currentValues = [];
          lastValue = 0;
          savedLastValue = false;
          _textEditingController.text = convertToString(_currentValues);
          Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
          Provider.of<TimeSheet>(context, listen: false).refresh();
        } else if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "equipment") {
          if (value > 20) {
            setState(() {
              warning = "Error! Value Exceeds Maximum Hours";
            });
          } else {
            warning = "";
            Provider.of<UIKeypadRepository>(context, listen: false).updateEquipmentHours(value);
            Provider.of<UIKeypadRepository>(context, listen: false).selectedEquipmentHours.clear();
            _currentValues = [];
            lastValue = 0;
            savedLastValue = false;
            _textEditingController.text = convertToString(_currentValues);
            Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
            Provider.of<TimeSheet>(context, listen: false).refresh();
          }
        } else if (Provider.of<UIKeypadRepository>(context, listen: false).selectedFieldName == "lastreading") {
          Provider.of<UIKeypadRepository>(context, listen: false).updateLastReading(value);

          for (int i = 0; i < Provider.of<UIKeypadRepository>(context, listen: false).selectedLastReading.length; i++) {
            double prevlastreading = Provider.of<UIKeypadRepository>(context, listen: false).selectedLastReading[i].prevlastreading;
            if (value < prevlastreading || value > (prevlastreading + 24) && value > 0) {
              if (prevlastreading < 1) {
                Provider.of<UIKeypadRepository>(context, listen: false).selectedLastReading[i].setValid = true;
              } else {
                Provider.of<UIKeypadRepository>(context, listen: false).selectedLastReading[i].setValid = false;
              }
            } else {
              Provider.of<UIKeypadRepository>(context, listen: false).selectedLastReading[i].setValid = true;
            }
          }
          Provider.of<UIKeypadRepository>(context, listen: false).selectedLastReading.clear();
          _currentValues = [];
          lastValue = 0;
          savedLastValue = false;
          _textEditingController.text = convertToString(_currentValues);
          Provider.of<UIKeypadRepository>(context, listen: false).toggleKeypad();
          Provider.of<TimeSheet>(context, listen: false).refresh();
        }
      }
    });
  }

  String validateDouble(double doubleValue) {
    int value;
    if (doubleValue % 1 == 0) {
      value = doubleValue.toInt();
    } else {
      return doubleValue.toStringAsFixed(1);
    }
    return value.toString();
  }

  String convertToString(List values) {
    String val = '';
    for (int i = 0; i < values.length; i++) {
      val += _currentValues[i];
    }
    return val;
  }

  List convertToList(String value) {
    List list = [];
    for (int i = 0; i < value.length; i++) {
      list.add(String.fromCharCode(value.codeUnitAt(i)));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      borderOnForeground: true,
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.black, width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: (height / 100) * 10,
            decoration: BoxDecoration(
              color: Provider.of<UIKeypadRepository>(context, listen: false).keypadState ? Colors.black : Colors.transparent,
            ),
            child: IgnorePointer(
              child: TextFormField(
                enabled: false,
                autofocus: true,
                controller: _textEditingController,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontStyle: FontStyle.normal,
                  color: AppConfig().primaryColor,
                  fontSize: 42.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: (height / 100) * 52,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildKeyItem('1', _oneKey),
                        buildKeyItem('2', _twoKey),
                        buildKeyItem('3', _threeKey),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildKeyItem('4', _fourKey),
                        buildKeyItem('5', _fiveKey),
                        buildKeyItem('6', _sixKey),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildKeyItem('7', _sevenKey),
                        buildKeyItem('8', _eightKey),
                        buildKeyItem('9', _nineKey),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildKeyItem('.', _dotKey),
                        buildKeyItem('0', _zeroKey),
                        KeyItem(
                          key: _clearKey,
                          child: Icon(
                            Icons.backspace,
                            size: 40,
                            color: Provider.of<UIKeypadRepository>(context, listen: false).keypadState ? keypadColor : Colors.transparent,
                          ),
                          onKeyTap: onKeyTapped,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildKeyItem('ac', _allClearKey),
                        buildKeyItem(' ', const Key('')),
                        KeyItem(
                          key: _equalsKey,
                          onKeyTap: onKeyTapped,
                          child: const CircleAvatar(
                            child: Icon(Icons.done),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 56,
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        warning,
                        style: const TextStyle(color: Colors.redAccent),
                      )),
                  SizedBox(
                      height: 42,
                      child: MaterialButton(
                          color: Colors.redAccent,
                          child: const Center(
                            child: Text("Hide"),
                          ),
                          onPressed: () {
                            Provider.of<UIKeypadRepository>(context, listen: false).disableKeypad();
                            Provider.of<TimeSheet>(context, listen: false).refresh();
                          }))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ActionButton buildActionButton(String name, Key key) {
    return ActionButton(
      key: key,
      actionName: name,
      onTapped: onActionTapped,
      enabled: identical(_actionKey, key) ? true : false,
      padding: height > 600 ? const EdgeInsets.all(10.0) : const EdgeInsets.all(0.0),
    );
  }

  KeyItem buildKeyItem(String val, Key key) {
    return KeyItem(
      key: key,
      child: Text(
        val,
        style: TextStyle(
          color: Provider.of<UIKeypadRepository>(context, listen: false).keypadState ? keypadColor : Colors.transparent,
          fontFamily: 'Avenir',
          fontStyle: FontStyle.normal,
          fontSize: 32.0,
        ),
      ),
      onKeyTap: onKeyTapped,
    );
  }
}

class ActionButton extends StatelessWidget {
  final Color defaultBackground = Colors.transparent;
  final Color defaultForeground = primaryColor;
  final Color changedBackground = primaryColor;
  final Color changedForeground = Colors.white;

  final String actionName;
  final bool enabled;
  final ActionCallBack onTapped;
  @override
  final Key key;
  final EdgeInsets padding;

  const ActionButton({required this.actionName, required this.onTapped, required this.enabled, required this.key, required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        color: const Color(0xffF6F6F6),
        child: GestureDetector(
          onTap: () {
            onTapped(key);
          },
          child: CircleAvatar(
            backgroundColor: enabled ? changedBackground : defaultBackground,
            radius: 30,
            child: Text(
              actionName,
              style: TextStyle(
                  color: enabled ? changedForeground : defaultForeground,
                  fontSize: 40.0,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyItem extends StatelessWidget {
  final Widget child;
  @override
  final Key key;
  final KeyCallBack onKeyTap;

  const KeyItem({required this.child, required this.key, required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Expanded(
      child: Card(
        child: InkResponse(
          splashColor: Provider.of<UIKeypadRepository>(context, listen: false).keypadState ? Colors.blue : Colors.transparent,
          highlightColor: Colors.white,
          onTap: () => onKeyTap(key),
          child: Container(
            //color: Colors.white,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
