import 'dart:io';

import 'package:flutter/foundation.dart';

class CheckInternet {
  Future<bool> isInternetConnected() async {
    if (kIsWeb) return true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
