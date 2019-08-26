import 'package:flutter/material.dart';
import 'package:flutter_todo/utilities/auth.dart';
import 'package:flutter_todo/utilities/api.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo_list.dart';

class Todos extends StatefulWidget {
  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<Todos> {
  List<Todo> openTodos = List<Todo>();
  List<Todo> closedTodos = List<Todo>();

  @override
  initState() {
    super.initState();

    // Get open todos
    // Switch to an await?
    Future openTodosFuture = getTodos('open', context);
    openTodosFuture.then((data) {
      setState(() {
        openTodos = data;
      });
    });

    // Get closed todos
    // Switch to an await?
    // Also, maybe only load once tab gets switched?
    Future closedTodosFuture = getTodos('closed', context);
    closedTodosFuture.then((data) {
      setState(() {
        closedTodos = data;
      });
    });

  }

  toggleTodo(BuildContext context, Todo todo) async {
    List<Todo> openTodosModified = this.openTodos;
    List<Todo> closedTodosModified = this.closedTodos;

    // Set todo to 'processing'

    // Flip the status.
    String statusModified = todo.status == 'open' ? 'closed' : 'open';

    // Updates the status via an API call.
    bool updated = await toggleTodoStatus(context, todo.id, statusModified);

    // Default status message.
    // This can probably be moved into a function?
    Widget statusMessage = SnackBar(
      content: Text('Error has occured.'),
      behavior: SnackBarBehavior.floating,
    );

    if (statusModified == 'open') {
      openTodosModified.add(todo);
      closedTodosModified.remove(todo);

      statusMessage = SnackBar(
        content: Text('Task opened.'),
        behavior: SnackBarBehavior.floating,
      );
    }

    if (statusModified == 'closed') {
      closedTodosModified.add(todo);
      openTodosModified.remove(todo);
      statusMessage = SnackBar(
        content: Text('Task closed.'),
        behavior: SnackBarBehavior.floating,
      );
    }

    if (updated) {
      setState(() {
        openTodos = openTodosModified;
        closedTodos = closedTodosModified;
      });
    }

    Scaffold.of(context).showSnackBar(statusMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: Center(
        child: taskList(context, openTodos, toggleTodo),
      ),
    );
  }
}
