import 'package:flutter/material.dart';
import 'package:flutter_todo/utilities/auth.dart';
import 'package:flutter_todo/utilities/api.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/widgets/todo_list.dart';

class Tasks extends StatefulWidget {
  @override
  TasksState createState() => TasksState();
}

class TasksState extends State<Tasks> {
  List<Todo> tasks = List<Todo>();

  @override
  initState() {
    super.initState();
    Future tasksFuture = getTodos('open', context);
    tasksFuture.then((data) {
      setState(() {
        tasks = data;
      });
    });
  }

  toggleTodo(Todo todo, int index, BuildContext context) async {
    
    List<Todo> tasks2 = this.tasks;
    print(tasks2);
    tasks2.remove(todo);
    print(tasks2);

    setState(() {
      tasks = tasks2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Center(
        child: taskList(context, tasks, toggleTodo),
      ),
    );
  }
}
