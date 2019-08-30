import 'package:flutter/material.dart';
import 'package:flutter_todo/utilities/api.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: null,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: 'New to do item'),
              controller: textController,
            ),
          ),
          ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: new Text('Save'),
                onPressed: () async {
                  bool response = await addTodo(context, textController.text);
                  if (response) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
