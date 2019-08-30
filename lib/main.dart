import 'package:flutter/material.dart';
import 'package:flutter_todo/views/loading.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/register.dart';
import 'package:flutter_todo/views/password_reset.dart';
import 'package:flutter_todo/views/todos.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/login': (context) => LogIn(),
        '/register': (context) => Register(),
        '/password-reset': (context) => PasswordReset(),
        '/todos': (context) => Todos(),
      },
    ),
  );
}
