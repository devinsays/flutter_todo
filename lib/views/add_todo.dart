import 'package:flutter/material.dart';
import 'package:flutter_todo/utilities/api.dart';

class AddTodo extends StatelessWidget {
  @override

  TextEditingController textfield = TextEditingController();
  bool response;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add To Do'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              response = await addTodo(context, textfield.text);
              if (response) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
          child: new TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.done,
            controller: textfield,
          ),
        ),
      ),
    );
  }
}