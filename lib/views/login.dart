import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:provider/provider.dart';
import 'package:flutter_todo/models/auth.dart';
import 'package:flutter_todo/widgets/screen_arguments.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: LogInForm(),
          ),
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({Key key}) : super(key: key);

  @override
  LogInFormState createState() => LogInFormState();
}

class LogInFormState extends State<LogInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String message = '';

  String validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'Email is required.';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Valid email required.';
    }
    email = value.trim();
    return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password is required.';
    }
    password = value.trim();
    return null;
  }

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      await Provider.of<AuthRepository>(context).login(email, password);
    }
  }

  void gotoRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void gotoPasswordReset(BuildContext context) {
    Navigator.pushNamed(context, '/password-reset');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Log in to the App',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 10.0),
          Consumer<AuthRepository>(
            builder: (context, provider, child) => Text(
              provider.notification ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            validator: validateEmail,
          ),
          SizedBox(height: 15.0),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            validator: validatePassword,
          ),
          SizedBox(height: 15.0),
          FlatButton(
            child: const Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue[500],
            splashColor: Colors.blue[200],
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: submit,
          ),
          SizedBox(height: 20.0),
          Center(
            child: RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: "Don't have an account? ",
                    style: new TextStyle(color: Colors.black),
                  ),
                  new TextSpan(
                    text: 'Register.',
                    style: new TextStyle(color: Colors.blue[500]),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => gotoRegister(context),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: RichText(
              text: new TextSpan(
                text: 'Forgot Your Password?',
                style: new TextStyle(color: Colors.blue[500]),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () => gotoPasswordReset(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
