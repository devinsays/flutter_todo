import 'package:flutter/material.dart';

import 'package:flutter_todo/utilities/api.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo_response.dart';

class TodoProvider with ChangeNotifier {
  bool _initialized = false;
  bool _loading = true;

  // Stores separate lists for open and closed todos.
  List<Todo> _openTodos = List<Todo>();
  List<Todo> _closedTodos = List<Todo>();

  // The API is paginated. If there are more results we store
  // the API url in order to lazily load them later.
  String _openTodosApiMore; 
  String _closedTodosApiMore;

  bool get initialized => _initialized;
  bool get loading => _loading;
  List<Todo> get openTodos => _openTodos;
  List<Todo> get closedTodos => _closedTodos;
  String get openTodosApiMore => _openTodosApiMore;
  String get closedTodosApiMore => _closedTodosApiMore;

  getInitialData(String token) async {

    TodoResponse openTodosResponse = await getTodos(token, 'open');

    print(openTodosResponse);
    // TodoResponse closedTodosResponse = await getTodos(context, 'closed');

    _initialized = true;
    _loading = false;

    // _openTodos = openTodosResponse.todos;
    // _openTodosApiMore = openTodosResponse.apiMore;
    // _closedTodos = closedTodosResponse.todos;
    // _closedTodosApiMore = closedTodosResponse.apiMore;

    notifyListeners();
  }

}