import 'dart:io';

class Picture {
  late File _picture;
  late String _description;
  Picture() {
    _picture = File("");
    _description = "";
  }
  File get picture => _picture;
  String get description => _description;

  set setPicture(File file) {
    _picture = file;
  }

  set setDescription(String desc) {
    _description = desc;
  }
}
