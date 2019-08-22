import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:flutter_todo/widgets/screen_arguments.dart';

Future<Map> login(String email, String password) async {
  final url = "https://laravelreact.com/api/v1/auth/login";

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  Map<String, dynamic> result = {
    "auth": false,
    "message": 'Unknown error.'
  };

  final response = await http.post( url, body: body, );

  if (response.statusCode == 200) {
    Object apiResponse = json.decode(response.body);
    await storeUserData(apiResponse);
    result['auth'] = true;
    result['message'] = 'Log in successful.';
    return result;
  }

  if (response.statusCode == 401) {
    result['message'] = 'Invalid email or password.';
    return result;
  }

  return result;
}

Future<Map> register(String name, String email, String password, String passwordConfirm) async {
  final url = "https://laravelreact.com/api/v1/auth/register";

  Map<String, String> body = {
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': passwordConfirm,
  };

  Map<String, dynamic> result = {
    "success": false,
    "message": 'Unknown error.'
  };

  final response = await http.post( url, body: body, );

  if (response.statusCode == 200) {
    result['success'] = true;
    result['message'] = 'Registration successful, please log in.';
    return result;
  }

  Map apiResponse = json.decode(response.body);

  if (response.statusCode == 422) {
    if (apiResponse['errors'].containsKey('email')) {
      result['message'] = apiResponse['errors']['email'][0];
      return result;
    }

    if (apiResponse['errors'].containsKey('password')) {
      result['message'] = apiResponse['errors']['password'][0];
      return result;
    }

    return result;
  }

  return result;
}

passwordReset(String email) async {
  final url = "https://laravelreact.com/api/v1/auth/forgot-password";

  Map<String, String> body = {
    'email': email,
  };

  Map<String, dynamic> result = {
    "reset": false,
    "message": 'Unknown error.'
  };

  final response = await http.post( url, body: body, );

  if (response.statusCode == 200) {
    result['reset'] = true;
    result['message'] = "Reset successful. Please check your inbox.";
    return result;
  }

  if (response.statusCode == 422) {
    result['message'] = "We couldn't find an account with that email.";
    return result;
  }

  return result;
}

storeUserData(apiResponse) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  await storage.setString('token', apiResponse['access_token']);
  await storage.setString('name', apiResponse['user']['name']);
}

getToken() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String token = storage.getString('token');
  return token;
}

logOut(BuildContext context, [bool tokenExpired = false]) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  await storage.clear();

  if (tokenExpired == true) {
    Navigator.pushReplacementNamed(
      context,
      '/login',
      arguments: ScreenArguments(
        'Session expired. Please log in again.',
      ),
    );
  } else {
    Navigator.pushReplacementNamed(context, '/login');
  }
}