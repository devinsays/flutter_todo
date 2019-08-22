import 'package:flutter/material.dart';

import 'package:flutter_todo/utilities/auth.dart';
import 'package:flutter_todo/widgets/screen_arguments.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name;
  String email;
  String password;
  String passwordConfirm;
  String message = '';

  Map response = new Map();

  String validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required.';
    }
    name = value.trim();
    return null;
  }

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

  String validatePasswordConfirm(String value) {
    if (value.trim().isEmpty) {
      return 'Password is required.';
    }
    passwordConfirm = value.trim();
    return null;
  }

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await register(name, email, password, passwordConfirm);
      if (response['success']) {
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
            'Register Account',
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
              hintText: "Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            validator: validateName,
          ),
          SizedBox(height: 15.0),
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
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password Confirm",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            validator: validatePasswordConfirm,
          ),
          SizedBox(height: 15.0),
          FlatButton(
            child: const Text(
              'Register',
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
