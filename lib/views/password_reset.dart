import 'package:flutter/material.dart';

import 'package:flutter_todo/utilities/auth.dart';
import 'package:flutter_todo/widgets/screen_arguments.dart';

class PasswordReset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: PasswordResetForm(),
          ),
        ),
      ),
    );
  }
}

class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key key}) : super(key: key);

  @override
  PasswordResetFormState createState() => PasswordResetFormState();
}

class PasswordResetFormState extends State<PasswordResetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String message = '';

  Map response = new Map();

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

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await passwordReset(email);
      if (response['reset']) {
        Navigator.pushReplacementNamed(
          context,
          '/login',
          arguments: ScreenArguments(
            response['message'],
          ),
        );
      } else {
        setState(() {
          message = response['message'];
        });
      }
    }
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
            'Request Password Reset',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
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
          FlatButton(
            child: const Text(
              'Send Password Reset Email',
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
        ],
      ),
    );
  }
}
