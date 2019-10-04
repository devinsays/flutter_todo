import 'package:flutter/material.dart';

import 'package:flutter_todo/providers/auth.dart';
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

  // API Service
  ApiService apiService;

  // Provides access to private variables.
  bool get initialized => _initialized;
  bool get loading => _loading;
  List<Todo> get openTodos => _openTodos;
  List<Todo> get closedTodos => _closedTodos;
  String get openTodosApiMore => _openTodosApiMore;
  String get closedTodosApiMore => _closedTodosApiMore;

  // AuthProvider is required to instaniate our ApiService.
  // This gives the service access to the user token and provider methods.
  TodoProvider(AuthProvider authProvider) {
    this.apiService = ApiService(authProvider);
    init();
  }

  void init() async {

    TodoResponse openTodosResponse = await apiService.getTodos('open');
    TodoResponse closedTodosResponse = await apiService.getTodos('closed');

    _initialized = true;
    _loading = false;
    _openTodos = openTodosResponse.todos;
    _openTodosApiMore = openTodosResponse.apiMore;
    _closedTodos = closedTodosResponse.todos;
    _closedTodosApiMore = closedTodosResponse.apiMore;

    notifyListeners();
  }

  Future<bool> addTodo(String text) async {

    // Posts the new item to our API.
    bool response = await apiService.addTodo(text);

    // If API update was successful, we add the item to _openTodos.
    if (response) {
      Todo todo = new Todo();
      todo.value = text;
      todo.status = 'open';

      List<Todo> openTodosModified = _openTodos;
      openTodosModified.add(todo);

      _openTodos = openTodosModified;
      notifyListeners();

      return true;
    }

    return false;
  }

  Future<bool> toggleTodo(Todo todo) async {
    List<Todo> openTodosModified = _openTodos;
    List<Todo> closedTodosModified = _closedTodos;

    // Store the todo status.
    String statusModified = todo.status == 'open' ? 'closed' : 'open';

    // Updates the status via an API call.
    bool updated = await apiService.toggleTodoStatus(todo.id, statusModified);

    if (statusModified == 'open') {
      openTodosModified.add(todo);
      closedTodosModified.remove(todo);
    }

    if (statusModified == 'closed') {
      closedTodosModified.add(todo);
      openTodosModified.remove(todo);
    }

    if (updated) {
      _openTodos = openTodosModified;
      _closedTodos = closedTodosModified;
      notifyListeners();
    }

    return updated;
  }

}