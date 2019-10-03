import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/todo.dart';
import 'package:flutter_todo/utilities/api.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo_list.dart';
import 'package:flutter_todo/widgets/todo_response.dart';
import 'package:flutter_todo/widgets/add_todo.dart';

class Todos extends StatefulWidget {
  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<Todos> {

  // Active tab.
  String activeTab = 'open';

  toggleTodo(BuildContext context, Todo todo) async {
    /*
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
    */
  }

  Widget getStatusMessage(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
  }

  void loadMore() async {

    /*

    // Set apiMore based on the activeTab.
    String apiMore = (activeTab == 'open') ? openTodosApiMore : closedTodosApiMore;

    // If we're already loading or there are no more items, return early.
    if (loading || apiMore == null) {
      return;
    }

    setState(() { loading = true; });

    // Get the current todos for the active tab.
    List<Todo> currentTodos = (activeTab == 'open') ? openTodos : closedTodos;

    // Make the API call to get more todos.
    TodoResponse todosResponse = await getTodos(context, activeTab, url: apiMore);
    List<Todo> allTodos = [...currentTodos, ...todosResponse.todos];

    setState(() {
      if (activeTab == 'open') {
        openTodos = allTodos;
        openTodosApiMore = todosResponse.apiMore;
      }

      if (activeTab == 'closed') {
        closedTodos = allTodos;
        closedTodosApiMore = todosResponse.apiMore;
      }

      loading = false;
    });

    */
  }

  void showAddTaskSheet(context) {

    // The addTodo function is passed down to the AddTodo widget
    // because modals do not have access to the Provider.
    Function addTodo = Provider.of<TodoProvider>(context).addTodo;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddTodo(addTodo);
      },
    );
  }

  void addNewTodo(BuildContext context, String text) async {
    /*
    bool response = await addTodo(context, text);

    if (response) {
      Todo todo = new Todo();
      todo.value = text;
      todo.status = 'open';

      List<Todo> openTodosModified = this.openTodos;
      openTodosModified.add(todo);

      setState(() {
        openTodos = openTodosModified;
      });
    }

    Navigator.pop(context);
    */
  }

  void displayProfileMenu(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: new Text('Log out'),
                onTap: () {
                  Provider.of<AuthProvider>(context).logOut();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final openTodos = Provider.of<TodoProvider>(context).openTodos;
    final closedTodos = Provider.of<TodoProvider>(context).closedTodos;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To Do List'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Profile',
              onPressed: () {
                displayProfileMenu(context);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.check_box_outline_blank)),
              Tab(icon: Icon(Icons.check_box)),
            ],
            onTap: (int index) {
              setState(() {
                activeTab = index == 1 ? 'closed' : 'open';
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            todoList(context, openTodos, toggleTodo, loadMore),
            todoList(context, closedTodos, toggleTodo, loadMore),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTaskSheet(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

}
