import 'package:flutter/material.dart';

import 'package:flutter_todo/utilities/auth.dart';
import 'package:flutter_todo/utilities/api.dart';
import 'package:flutter_todo/models/todo.dart';

class Todos extends StatefulWidget {
  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<Todos> {
  List<Todo> todos = List<Todo>();

  Future<List<Todo>> openTodoList;
  Future<List<Todo>> archivedTodoList;

  @override
  initState() {
    super.initState();
    openTodoList = getTodos('open', context);
    archivedTodoList = getTodos('closed', context);
  }

  _toggleTodo(Todo todo, int index, BuildContext context) async {
    // Flip the status.
    String newStatus = todo.status == 'open' ? 'closed' : 'open';

    // Updates the status via an API call.
    bool updated = await toggleTodoStatus(context, todo.id, newStatus);

    // Updates the lists.
    List<Todo> openTodoListData = await openTodoList;
    List<Todo> archivedTodoListData = await archivedTodoList;

    Widget statusMessage = SnackBar(
      content: Text('Error has occured.'),
      behavior: SnackBarBehavior.floating,
    );

    if (newStatus == 'open') {
      openTodoListData.add(todo);
      archivedTodoListData.removeAt(index);
      statusMessage = SnackBar(
        content: Text('Task opened.'),
        behavior: SnackBarBehavior.floating,
      );
    }

    if (newStatus == 'closed') {
      archivedTodoListData.add(todo);
      openTodoListData.removeAt(index);
      statusMessage = SnackBar(
        content: Text('Task closed.'),
        behavior: SnackBarBehavior.floating,
      );
    }

    // Updates local state now that call has completed.
    if (updated) {
      setState(() {
        todo.status = newStatus;
        openTodoList =
            Future.delayed(Duration(milliseconds: 0), () => openTodoListData);
        archivedTodoList = Future.delayed(
            Duration(milliseconds: 0), () => archivedTodoListData);
      });
    }

    Scaffold.of(context).showSnackBar(statusMessage);
  }

  Widget showTodoList(Future todosFuture) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
        child: FutureBuilder<dynamic>(
          future: todosFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final todos = snapshot.data ?? <Todo>[];
              if (todos.length == 0) {
                return Text('No items.');
              }
              return ListView.separated(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = todos[index];
                  final statusIcon = todo.status == 'open'
                      ? Icons.radio_button_unchecked
                      : Icons.radio_button_checked;
                  return ListTile(
                    key: Key((todo.id).toString()),
                    leading: Icon(statusIcon),
                    title: Text(todo.value),
                    enabled: todo.status != 'processing',
                    onTap: () {
                      _toggleTodo(todo, index, context);
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black38,
                ),
              );
            }
            return Center(
              child: Text('No data available.'),
            );
          },
        ),
      ),
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
                  logOut(context);
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
                displayProfileMenu(
                    context); // Show Bottom Modal Sheet with Logout Link
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.check_box_outline_blank)),
              Tab(icon: Icon(Icons.check_box)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            showTodoList(openTodoList),
            showTodoList(archivedTodoList),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
