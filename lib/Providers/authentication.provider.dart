import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urbanico_app/enum/authStatus.dart';
import 'package:http/http.dart' as http;

var authNotifier = StateNotifierProvider<AuthenticationProvider, AsyncValue<Status>>(
    (ref) => AuthenticationProvider(const AsyncData(Status.Unauthenticated)));

class AuthenticationProvider extends StateNotifier<AsyncValue<Status>> {
  AuthenticationProvider(AsyncValue<Status> state) : super(AsyncValue.data(Status.Unauthenticated));
  Future<void> login(String email, String password) async {
    try {
      state = AsyncValue.loading();
      http.Response response = await http.post(Uri.parse("https://testing.urbaniconstruct.com/TimesheetService" + "/v2/login"),
          body: {"email": email, "password": password}).timeout(const Duration(seconds: 30));
      var body = jsonDecode(response.body);
      if (body["response"] == "success") {
        state = AsyncValue.data(Status.Authenticated);
      } else {
        throw Exception();
      }
    } catch (err) {
      state = AsyncValue.error({"error": "error"});
    }
  }
}
