import 'package:flutter/material.dart';
import 'package:flutter_todo/utilities/auth.dart';
import 'package:flutter_todo/utilities/api.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo_list.dart';
import 'package:flutter_todo/widgets/todo_response.dart';

class Todos extends StatefulWidget {
  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<Todos> {
  List<Todo> openTodos = List<Todo>();
  List<Todo> closedTodos = List<Todo>();

  // The API is paginated. If there are more results we store
  // the API url in order to lazily load them later.
  String openTodosApiMore; 
  String closedTodosApiMore;

  bool loading = true;

  @override
  initState() {
    super.initState();
    getInitialData();
  }

  void getInitialData() async {
    TodoResponse openTodosResponse = await getTodos(context, 'open');
    TodoResponse closedTodosResponse = await getTodos(context, 'closed');

    setState(() {
      openTodos = openTodosResponse.todos;
      openTodosApiMore = openTodosResponse.apiMore;
      closedTodos = closedTodosResponse.todos;
      closedTodosApiMore = closedTodosResponse.apiMore;
      loading = false;
    });
  }

  toggleTodo(BuildContext context, Todo todo) async {
    List<Todo> openTodosModified = this.openTodos;
    List<Todo> closedTodosModified = this.closedTodos;

    // Store the todo status.
    String statusOriginal = todo.status;
    String statusModified = todo.status == 'open' ? 'closed' : 'open';

    // Set todo to 'processing' in state.
    setState(() => todo.status = 'processing');

    // Updates the status via an API call.
    bool updated = await toggleTodoStatus(context, todo.id, statusModified);

    // Default status message.
    Widget statusMessage = getStatusMessage('Error has occured.');
  
    if (statusModified == 'open') {
      openTodosModified.add(todo);
      closedTodosModified.remove(todo);
      statusMessage = getStatusMessage('Task opened.');
    }

    if (statusModified == 'closed') {
      closedTodosModified.add(todo);
      openTodosModified.remove(todo);
      statusMessage = getStatusMessage('Task closed.');
    }

    if (updated) {
      setState(() {
        openTodos = openTodosModified;
        closedTodos = closedTodosModified;
        todo.status = statusModified;
      });
    } else {
      todo.status = statusOriginal;
    }

    Scaffold.of(context).showSnackBar(statusMessage);
  }

  Widget getStatusMessage(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
  }

  void loadMore() async {
    // If we're already loading, return early to avoid duplicates.
    if (loading || openTodosApiMore == null) { return; }
    setState(() { loading = true; });

    TodoResponse openTodosResponse = await getTodos(context, 'open', url: openTodosApiMore);
    List<Todo> allOpenTodos = [openTodos, openTodosResponse.todos].expand((x) => x).toList();

    setState(() {
      openTodos = allOpenTodos;
      openTodosApiMore = openTodosResponse.apiMore;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: Center(
        child: taskList(context, openTodos, toggleTodo, loadMore),
      ),
    );
  }
}
