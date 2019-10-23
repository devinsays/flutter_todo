import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/todo.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/widgets/styled_flat_button.dart';
import 'package:flutter_todo/widgets/todo_list.dart';
import 'package:flutter_todo/widgets/add_todo.dart';


class Todos extends StatefulWidget {
  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<Todos> {

  bool loading = false;
  String activeTab = 'open';

  toggleTodo(BuildContext context, Todo todo) async {

    String statusModified = todo.status == 'open' ? 'closed' : 'open';

    bool updated = await Provider.of<TodoProvider>(context).toggleTodo(todo);

    // Default status message.
    Widget statusMessage = getStatusMessage('Error has occured.');

    if (true == updated) {
      if (statusModified == 'open') {
        statusMessage = getStatusMessage('Task opened.');
      }

      if (statusModified == 'closed') {
        statusMessage = getStatusMessage('Task closed.');
      }
    }

    if (mounted) {
      Scaffold.of(context).showSnackBar(statusMessage);
    }
  }

  Widget getStatusMessage(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
  }

  void loadMore() async {

    // If we're already loading return early.
    if (loading) {
      return;
    }

    setState(() { loading = true; });

    // Loads more items in the activeTab.
    await Provider.of<TodoProvider>(context).loadMore(activeTab);

    // If auth token has expired, widget is disposed and state is not set.
    if (mounted) {
      setState(() { loading = false; });
    }
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
                  Navigator.pop(context);
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
