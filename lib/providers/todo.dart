import 'package:flutter/material.dart';
import 'package:flutter_todo/classes/exceptions.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/classes/todo_response.dart';
import 'package:flutter_todo/services/api.dart';
import 'package:flutter_todo/models/todo.dart';

class TodoProvider with ChangeNotifier {
  bool _initialized = false;

  // AuthProvier
  AuthProvider authProvider;

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
    _openTodos = openTodosResponse.todos;
    _openTodosApiMore = openTodosResponse.apiMore;
    _closedTodos = closedTodosResponse.todos;
    _closedTodosApiMore = closedTodosResponse.apiMore;

    notifyListeners();
  }

  Future<bool> addTodo(String text) async {
    try {
      // Posts the new item to our API.
      await apiService.addTodo(text);

      // If no exceptions were thrown by API Service,
      // we add the item to _openTodos.
      Todo todo = new Todo();
      todo.value = text;
      todo.status = 'open';

      List<Todo> openTodosModified = _openTodos;
      openTodosModified.add(todo);

      _openTodos = openTodosModified;
      notifyListeners();

      return true;
    }
    on AuthException {
      // API returned a AuthException, so user is logged out.
      await authProvider.logOut(true);
    }
    catch (Exception) {
      // Additional error messaging could be added.
      print(Exception);
    }

    // @TODO Track if this causes issue on disposal.
    return false;
  }

  Future<bool> toggleTodo(Todo todo) async {
    List<Todo> openTodosModified = _openTodos;
    List<Todo> closedTodosModified = _closedTodos;

    // Get current status in case there's an error and it can't be set.
    String status = todo.status;

    // Get the new status for the the todo.
    String statusModified = todo.status == 'open' ? 'closed' : 'open';

    // Set the todo status to processing while we wait for the API call to complete.
    todo.status = 'processing';
    notifyListeners();

    // Updates the status via an API call.
    bool updated = await apiService.toggleTodoStatus(todo.id, statusModified);

    // Modify the todo with the new status.
    Todo modifiedTodo = todo;
    modifiedTodo.status = statusModified;

    if (statusModified == 'open') {
      openTodosModified.add(modifiedTodo);
      closedTodosModified.remove(todo);
    }

    if (statusModified == 'closed') {
      closedTodosModified.add(modifiedTodo);
      openTodosModified.remove(todo);
    }

    if (updated) {
      _openTodos = openTodosModified;
      _closedTodos = closedTodosModified;
      notifyListeners();
      return updated;
    }

    // If API update failed, we set the status back to original state.
    todo.status = status;
    notifyListeners();
    return updated;
  }

  Future<void> loadMore(String activeTab) async {
    // Set apiMore based on the activeTab.
    String apiMore = (activeTab == 'open') ? _openTodosApiMore : _closedTodosApiMore;

    // If there's no more items to load, return early.
    if (apiMore == null) {
      return;
    }

    // Make the API call to get more todos.
    TodoResponse todosResponse = await apiService.getTodos(activeTab, url: apiMore);

    // Get the current todos for the active tab.
    List<Todo> currentTodos = (activeTab == 'open') ? _openTodos : _closedTodos;

    // Combine current todos with new results from API.
    List<Todo> allTodos = [...currentTodos, ...todosResponse.todos];

    if (activeTab == 'open') {
      _openTodos = allTodos;
      _openTodosApiMore = todosResponse.apiMore;
    }

    if (activeTab == 'closed') {
      _closedTodos = allTodos;
      _closedTodosApiMore = todosResponse.apiMore;
    }

    notifyListeners();
  }

}