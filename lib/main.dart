import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/views/loading.dart';
import 'package:flutter_todo/models/auth.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/register.dart';
import 'package:flutter_todo/views/password_reset.dart';
import 'package:flutter_todo/views/todos.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      builder: (context) => AuthRepository(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Router(),
          '/login': (context) => LogIn(),
          '/register': (context) => Register(),
          '/password-reset': (context) => PasswordReset(),
          '/todos': (context) => Todos(),
        },
      ),
    ),
  );
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    print('Router route.');
    
    return Consumer<AuthRepository>(
      builder: (context, user, child) {
        print(user);
        print(user.status);
        switch (user.status) {
            case Status.Uninitialized:
              return Loading();
            case Status.Unauthenticated:
              return LogIn();
            case Status.Authenticating:
              return LogIn();
            case Status.Authenticated:
              return Todos();
            default:
              return LogIn();
          }
      },
    );




    return ChangeNotifierProvider(
      builder: (_) => AuthRepository(),
      child: Consumer<AuthRepository>(
        builder: (context, AuthRepository user, _) {
          print(user);
          print(user.status);
          switch (user.status) {
            case Status.Uninitialized:
              return Loading();
            case Status.Unauthenticated:
              return LogIn();
            case Status.Authenticating:
              return LogIn();
            case Status.Authenticated:
              return Todos();
            default:
              return LogIn();
          }
        },
      ),
    );
  }
}
