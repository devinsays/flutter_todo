import 'package:flutter/material.dart';
import 'package:flutter_todo/utilities/auth.dart';

class Loading extends StatelessWidget {

  redirect(BuildContext context) async {
    String token = await getToken();
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/todos');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {

    // Redirect once token has been retrieved.
    redirect(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('To Do App'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: new CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}